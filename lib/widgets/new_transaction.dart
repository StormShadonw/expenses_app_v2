import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransactionHandler;

  NewTransaction({this.newTransactionHandler}) {
    print("cto NewTransaction Widget");
  }

  @override
  _NewTransactionState createState() {
    print("createState NewTransaction Widget");
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  _NewTransactionState() {
    print("State NewTransaction Widget");
  }

  @override
  void initState() {
    // TODO: implement initState
    print("InitState NewTransaction Widget");
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    // TODO: implement didUpdateWidget
    print("didUpdate NewTransaction Widget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("dispose NewTransaction Widget");
    super.dispose();
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    final enteredDate = _selectedDate;

    if (enteredAmount > 0 && enteredTitle.isNotEmpty && enteredDate != null) {
      widget.newTransactionHandler(enteredTitle, enteredAmount, enteredDate);
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(
                    decimal:
                        true), //Se usa en vez de .number como enum porque este funciona bien en IOS
                onSubmitted: (_) => _submitData(),
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountController,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? "No Date Chosen!"
                          : "Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}"),
                    ),
                    AdaptiveFlatButton(
                      handler: _presentDatePicker,
                      buttonText: "Choose Date",
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _submitData,
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Add Transaction",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.button.color,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
