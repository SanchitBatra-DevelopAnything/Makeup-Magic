

class Order 
{
  final String id;
  final String name;
  final String place;
  final String type;
  final double advanceAmount;
  final double balanceAmount;
  final String orderDate;
  final DateTime testDate;
  final String time;

  Order({this.time,this.id,this.name,this.place,this.type,this.advanceAmount,this.balanceAmount,this.orderDate,this.testDate});
}