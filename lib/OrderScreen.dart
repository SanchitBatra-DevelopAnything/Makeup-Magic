import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './order_details_screen.dart';
import './main_drawer.dart';
import './Order.dart';
import './orderInput.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './OrderItem.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> allOrders = [];

  List<Order> filteredOrders = [];
  var loadedData = false;
  var isLoading = false;
  var isDeleting = false;

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  @override
  void initState() {
    // TODO: implement initState
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification : onnSelectNotification);

    setState(() {
      isLoading = true;
    });


    fetchOrders().then((_) {

      setState(() {
        isLoading = false;
      });
      checkToProduceNotifications();
    });
    if (!loadedData) {
      filteredOrders = allOrders;
      loadedData = true;
    }
    super.initState();
  }

  void checkToProduceNotifications(){
    print('CHECKING FOR NOTIFICATIONS');
    for(var i = 0;i<allOrders.length;i++){
      var date = DateTime.parse(change(allOrders[i].orderDate));
      if(date.isAfter(DateTime.now()) && date.difference(DateTime.now()).inDays == 0){
        showNotification(i,allOrders[i].id);
      }
    }
  }


  String change(String dateOfOrder){   //change is a customFormat function to sort remaining orders.
    var data = dateOfOrder.split("/");
    String date = data[1];
    String month = data[0];
    String year = data[2];
    int m = int.parse(month);
    if(m<10){
      month = '0'+month;
    }
    int d = int.parse(date);
    if(d < 10){
      date = '0'+date;
    }
    var a = year+month+date;
    print('Changed Date : $a');
    return a;
  }



  Future<Order> fetchOrders() async {
    try{
    const url = 'https://makeup-time.firebaseio.com/orders.json';
    var response = await http.get(url);
    var extractedData = json.decode(response.body) as Map<String, dynamic>;
    print('extracted Data = $extractedData');
    final List<Order> loadedOrders = [];
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(Order(
        id: orderId,
        advanceAmount: orderData['advanceAmount'],
        balanceAmount: orderData['balanceAmount'],
        type: orderData['type'],
        name: orderData['name'],
        place: orderData['place'],
        orderDate: orderData['selectedDate'],
        time : orderData['time'],
      ));
    });
    print(loadedOrders.length);
    setState(() {
      allOrders = loadedOrders;
      filteredOrders = loadedOrders;
    });} catch(error){
      showDialog(context: context , builder: (ctx)=> AlertDialog(
        title: Text('An Error Occured!'),
        content : Text('Please check your internet connection , Or You got no orders left!!'),
        actions: <Widget>[
          FlatButton(child: Text('Okay'),onPressed: (){
            Navigator.of(ctx).pop();
          },)
        ],
      )
      ).then((_){
        setState(() {
          isLoading = false;
        });
      });
    }
  }

    Future onnSelectNotification(String payload) {
    debugPrint("payload : $payload");
    var loadedOrder = allOrders.where((order)=>order.id == payload).toList();
    Navigator.of(context).pushNamed('/order-details',arguments: loadedOrder[0]);
  }


  showNotification(int id,String orderId) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High,importance: Importance.Max
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        id, 'Kiran , You got order tomorrow', 'TAP HERE FOR ORDER DETAILS!', platform,
        payload: orderId);
  }

  void filterOrdersOnPlace(value) {
    setState(() {
      filteredOrders = allOrders
          .where((order) =>
              order.place.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  

  void removeOrder(String orderId) async{
    final url = 'https://makeup-time.firebaseio.com/orders/$orderId.json';
    setState(() {
      isDeleting = true;
    });
    await http.delete(url);
    //fetchOrders();
     setState(() {
      allOrders.removeWhere((order)=>order.id == orderId);
      filteredOrders = allOrders;
      isDeleting = false;
    });
    print('$orderId is the about to delete');
  }

  Future<void> addOrder(String name, String place, double advanceAmount,
    double balanceAmount, String type, DateTime selectedDate , String time) {
    const url = 'https://makeup-time.firebaseio.com/orders.json';
    return http
        .post(url,
            body: json.encode({
              'name': name,
              'place': place,
              'advanceAmount': advanceAmount,
              'balanceAmount': balanceAmount,
              'type': type,
              'selectedDate': DateFormat.yMd().format(selectedDate),
              'time' : time
            }))
        .then((response) {
      final newOrder = Order(
          name: name,
          place: place,
          advanceAmount: advanceAmount,
          balanceAmount: balanceAmount,
          type: type,
          time : time,
          orderDate: DateFormat.yMd().format(selectedDate),
          testDate: selectedDate,
          id: json.decode(response.body)['name']);

      setState(() {
        allOrders.add((newOrder));
      });
    }).catchError((error) {
      Navigator.of(context).pop();
      throw error;
    });
  }

  void startOrderInput(BuildContext ctx) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: OrderInput(addOrder),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  Future<void> refreshPageOnPull() async
  {
    await fetchOrders();
  }

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: !isSearching
              ? Text('My Orders')
              : TextField(
                  autofocus: true,
                  onChanged: (value) => filterOrdersOnPlace(value),
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontFamily: 'RobotoCondensed',
                    fontSize: 22,
                  ),
                  decoration: InputDecoration(
                      hintText: "Search Place",
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).canvasColor,
                      ),
                      hintStyle: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: 22,
                          fontFamily: 'RobotoCondensed')),
                ),
          actions: <Widget>[
            !isSearching
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        filteredOrders = allOrders;
                      });
                    },
                  ),
          ],
        ),
        body: isLoading || isDeleting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: filteredOrders.length == 0
                    ? Text(
                        'No Orders left!!',
                        style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'RobotoCondensed',
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      )
                    : RefreshIndicator(
                        onRefresh: refreshPageOnPull,
                        child: GridView.builder(
                          padding: EdgeInsets.all(25),
                          itemCount: filteredOrders.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemBuilder: (context, index) {
                            return OrderItem(
                                filteredOrders[index], removeOrder);
                          },
                        ),
                      ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !isSearching
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => startOrderInput(context),
              )
            : Text(''));
  }
}
