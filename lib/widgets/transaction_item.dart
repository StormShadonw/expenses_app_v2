import 'dart:math';

import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.buttonLarge,
    @required this.transaction,
    @required this.deleteTxHandler,
  }) : super(key: key);

  final bool buttonLarge;
  final Transaction transaction;
  final Function deleteTxHandler;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
  @override
  void initState() {
    super.initState();
    const avaliableColors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple,
    ];
    _bgColor = avaliableColors[Random().nextInt(avaliableColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: ListTile(
        trailing: widget.buttonLarge
            ? FlatButton.icon(
                onPressed: () {
                  widget.deleteTxHandler(widget.transaction.id);
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  widget.deleteTxHandler(widget.transaction.id);
                },
                color: Theme.of(context).errorColor,
              ),
        title: Text(widget.transaction.title,
            style: Theme.of(context).textTheme.title),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date)),
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
                child:
                    Text("\$${widget.transaction.amount.toStringAsFixed(2)}")),
          ),
        ),
      ),
    );
  }
}
