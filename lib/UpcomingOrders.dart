import 'package:flutter/material.dart';
import './main_drawer.dart';
import './Order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


class Menu extends StatefulWidget {

  //final List<Order> orders;
  
  //Menu(this.orders);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  
  var isLoading = false;
  List<Order> orders = [];

  List<Order> remainingOrders = [];


  @override
  void initState() {
    // TODO: implement initState
    
    setState(() {
      isLoading = true;
    });
    fetchOrders().then((_){
      setState(() {
        orders.sort((a,b){
          return a.testDate.compareTo(b.testDate);
        });
        isLoading = false;
      });
    });
    super.initState();
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
    if(d<10)
    {
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
        testDate: DateTime.parse(change(orderData['selectedDate']),),
      ));
    });
    print(loadedOrders.length);
    setState(() {
      orders = loadedOrders.where((order)=>order.testDate.isAfter(DateTime.now())).toList();
      //filteredOrders = loadedOrders;
    });} catch(error){
      print('error is : $error');
      showDialog(context: context , builder: (ctx)=> AlertDialog(
        title: Text('An Error Occured!'),
        content : Text('Please check your internet connection , Or Please call Sanchit'),
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

  String changeToDayWali(DateTime date) {
      return DateFormat.yMMMMEEEEd().format(date);
    }

    void openDetails(Order openThisOrder){
      Navigator.of(context).pushNamed('/order-details',arguments: openThisOrder);
    }



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer : MainDrawer(),
        appBar: AppBar(title: Text('My Upcoming Orders'),),  
        body: isLoading? Center(child: CircularProgressIndicator(),) :  Padding(
        padding: EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context,index){
            return Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                      onTap: () => openDetails(orders[index])               
                      ,child: ListTile(
                      leading: CircleAvatar(
                        radius: 35,
                        child: Text(orders[index].type.substring(0,1).toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20.0),),
                      ),
                      title: Text(orders[index].place,style:TextStyle(fontWeight: FontWeight.bold , fontSize: 20.0,color: Colors.white),),
                      subtitle: Text(changeToDayWali(DateTime.parse(change(orders[index].orderDate))),style: TextStyle(fontSize: 18.0,color: Colors.white),),
                      trailing: Text(orders[index].name,style: TextStyle(fontSize: 20 , color: Colors.white),),
                      isThreeLine: true,
                    ),
                  ),
                ),
                Divider(height: 20,),
              ],
            );
          },
        ),
      ),
    );
  }
}