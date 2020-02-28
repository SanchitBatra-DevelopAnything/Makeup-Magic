import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  Widget buildTile(String title,IconData icon,Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 170,
            width: double.infinity,
            child: Text(
              'Makeup Magic!',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor,
                fontSize: 30,
              ),
            ),
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
          ),
          SizedBox(
            height: 25,
          ),
          buildTile('All Orders', Icons.mail_outline,(){
            Navigator.of(context).pushReplacementNamed('/');
          }),
          buildTile('Upcoming Orders',Icons.mail_outline , (){
            Navigator.of(context).pushReplacementNamed('/myMenu');
          }),
          buildTile('Bridals',Icons.spa,(){
            Navigator.of(context).pushReplacementNamed('/bridals');
          }),
          buildTile('Hair Dos',Icons.spa,(){
            Navigator.of(context).pushReplacementNamed('/hairdos');
          }),
          buildTile('Party Makeups',Icons.spa,(){
            Navigator.of(context).pushReplacementNamed('/partyMakeups');
          }),
        ],
      ),
    );
  }
}
