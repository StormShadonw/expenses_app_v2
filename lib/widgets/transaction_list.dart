import '../models/transaction.dart';
import 'package:flutter/material.dart';

import './transaction_item.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTxHandler;

  TransactionsList({this.transactions, this.deleteTxHandler});

  @override
  Widget build(BuildContext context) {
    print("build() TransactionList");
    final mediaQuery = MediaQuery.of(context);
    final buttonLargeInItem = mediaQuery.size.width >= 460 ? true : false;

    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constrains) {
            return Column(
              children: [
                Text(
                  "No transactions added yet!",
                  style: Theme.of(context).textTheme.title,
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: constrains.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView(
            children: transactions
                .map((e) => TransactionItem(
                      buttonLarge: buttonLargeInItem,
                      deleteTxHandler: deleteTxHandler,
                      transaction: e,
                      key: ValueKey(e.id),
                    ))
                .toList(),
          );
  }
}
