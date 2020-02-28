import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class OrderInput extends StatefulWidget {
  final Function addOrder;

  OrderInput(this.addOrder);


  @override
  _OrderInputState createState() => _OrderInputState();
}

class _OrderInputState extends State<OrderInput> {
  final nameController = TextEditingController();
  final placeController = TextEditingController();
  final balanceamountController = TextEditingController();
  final advanceamountController = TextEditingController();
  final timeController = TextEditingController();
  final typeController = TextEditingController();
  DateTime selectedDate;
  DateTime currentDate = DateTime.now();

  var isLoading = false;

  void submitForm() {
    if (advanceamountController.text.isEmpty ||
        balanceamountController.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final enteredName = nameController.text;
    final enteredPlace = placeController.text;
    final balanceAmount = double.parse(balanceamountController.text);
    final advanceAmount = double.parse(advanceamountController.text);
    final enteredType = typeController.text;
    final enteredTime = timeController.text;


    if (enteredName.isEmpty ||
        enteredType.isEmpty ||
        enteredPlace.isEmpty ||
        (advanceAmount < 0 || balanceAmount < 0) ||
        selectedDate == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    widget
        .addOrder(enteredName, enteredPlace, advanceAmount, balanceAmount,
            enteredType, selectedDate, enteredTime)
        .catchError((error) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occured!'),
          content: Text('Please Check Your Internet is running fine.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }).then((_) {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now().add(
        new Duration(days: 1000),
      ),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
                  child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              color: Theme.of(context).canvasColor,
              elevation: 5,
              child: Container(
                padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Name'),
                      controller: nameController,
                      onSubmitted: (_) => submitForm(),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Place'),
                      controller: placeController,
                      onSubmitted: (_) => submitForm(),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(labelText: 'MakeUp type'),
                            controller: typeController,
                            onSubmitted: (_) => submitForm(),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: 'Morning/Evening'),
                            controller: timeController,
                            onSubmitted: (_) => submitForm(),
                          ),
                        )
                      ],
                    ),
                    //Container(
                    //height: 45,
                    //child:
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: 'Advance Amount'),
                            controller: advanceamountController,
                            keyboardType: TextInputType.number,
                            onSubmitted: (_) => submitForm(),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: 'Balance Amount'),
                            controller: balanceamountController,
                            keyboardType: TextInputType.number,
                            onSubmitted: (_) => submitForm(),
                          ),
                        ),
                      ],
                    ),
                    //),
                    // TextField(
                    //       decoration: InputDecoration(labelText: 'Advance Amount'),
                    //       controller: advanceamountController,
                    //       keyboardType: TextInputType.number,
                    //       onSubmitted: (_) => submitForm(),
                    //     ),

                    //       TextField(
                    //       decoration: InputDecoration(labelText: 'Balance Amount'),
                    //       controller: balanceamountController,
                    //       keyboardType: TextInputType.number,
                    //       onSubmitted: (_) => submitForm(),
                    //     ),
                    Container(
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              selectedDate == null
                                  ? 'No Date Chosen!'
                                  : 'Picked Date: ${DateFormat.yMd().format(selectedDate)}',
                            ),
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Choose Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                            onPressed: presentDatePicker,
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      child: Text(
                        'Add Order',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).canvasColor,
                      onPressed: submitForm,
                    ),
                  ],
                ),
              ),
            ),
        );
  }
}
