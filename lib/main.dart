import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './UpcomingOrders.dart';
import './hairdos.dart';
import './partyMakeups.dart';
import './bridals.dart';
import './order_details_screen.dart';
import './OrderScreen.dart';
import './openImage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Makeup Time',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.green[900],
        canvasColor: Colors.green[50],
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              body2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              title: TextStyle(fontSize: 22, fontFamily: 'RobotoCondensed'),
            ),
      ),
      routes: {
        '/' : (context)=>OrderScreen(),
        '/order-details' : (context)=>OrderDetails(),
        '/bridals' : (context)=>Bridals(),
        '/hairdos' : (context)=>HairDos(),
        '/partyMakeups' : (context)=>PartyMakeUps(),
        '/myMenu' : (context)=>Menu(),
        '/open-image' : (context) => OpenImage(),
      },
    );
  }
}
