import 'package:flutter/material.dart';
import './Order.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatelessWidget {
  showAlert(BuildContext context, Order receivedOrder) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete this order?'),
            content: Text('Are you sure?'),
            actions: <Widget>[
              MaterialButton(
                child: Text(
                  'YES',
                  style: TextStyle(color: Colors.pink),
                ),
                elevation: 6,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(receivedOrder.id);
                },
              ),
              MaterialButton(
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.pink),
                ),
                elevation: 6,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final receivedOrder = ModalRoute.of(context).settings.arguments as Order;

    String changeToDayWali(DateTime date) {
      return DateFormat.yMMMMEEEEd().format(date);
    }

    String changeToDate(String dateOfOrder) {
      var data = dateOfOrder.split("/");
      String date = data[1];
      String month = data[0];
      String year = data[2];
      int m = int.parse(month);
      if (m < 10) {
        month = '0' + month;
      }
      int d = int.parse(date);
      if (d < 10) {
        date = '0' + date;
      }
      var a = year + month + date;
      print('Changed Date : $a');
      return a;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${receivedOrder.name}'s Details"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Order Details',
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Text(
              'Name : ${receivedOrder.name}',
              style: TextStyle(fontSize: 30, fontFamily: 'RobotoCondensed'),
            ),
            Divider(),
            Text(
              'Place : ${receivedOrder.place}',
              style: TextStyle(fontSize: 30, fontFamily: 'RobotoCondensed'),
            ),
            Divider(),
            Text(
              'MakeUp : ${receivedOrder.type} , ${receivedOrder.time}',
              style: TextStyle(fontSize: 30, fontFamily: 'RobotoCondensed'),
            ),
            Divider(),
            Text(
              'Advanced Collected : ${receivedOrder.advanceAmount}',
              style: TextStyle(fontSize: 30, fontFamily: 'RobotoCondensed'),
            ),
            Divider(),
            Text(
              'Balance amount : ${receivedOrder.balanceAmount}',
              style: TextStyle(fontSize: 30, fontFamily: 'RobotoCondensed'),
            ),
            Divider(),
            Text(
              'Booked for : ${changeToDayWali(DateTime.parse(changeToDate(receivedOrder.orderDate)))}',
              style: TextStyle(fontSize: 30, fontFamily: 'RobotoCondensed'),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    width: 2,
                  ),
                  flex: 1,
                ),
                Expanded(
                  flex: 3,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    heroTag : "btn1",
                    onPressed: () {
                      showAlert(context, receivedOrder);
                    },
                    backgroundColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 2,
                  ),
                  flex: 1,
                ),
                Expanded(
                  flex: 3,
                  child: FloatingActionButton(
                    heroTag : "btn2",
                    child: Icon(
                      Icons.update,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(child: SizedBox(width: 2), flex: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
