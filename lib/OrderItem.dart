import 'package:flutter/material.dart';
import './Order.dart';


class OrderItem extends StatelessWidget {
  final Order order;
  final Function removeOrder;
  OrderItem(this.order,this.removeOrder);

  void showOrderDetails(context)
  {
    Navigator.of(context).pushNamed('/order-details',arguments: order).then((result){
      if(result!=null)
      {
        removeOrder(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: () => showOrderDetails(context),
          splashColor: Theme.of(context).primaryColor,
          child: Card(
        child: Center(
          child: Text(
            order.name,
            style: TextStyle(
                color: Colors.white, fontFamily: 'RobotoCondensed', fontSize: 24),
          ),
        ),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
