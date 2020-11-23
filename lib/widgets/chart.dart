import 'package:expenses_app_v2/models/transaction.dart';
import 'package:expenses_app_v2/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart({this.recentTransactions});

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var c = 0; c < recentTransactions.length; c++) {
        if (recentTransactions[c].date.day == weekDay.day &&
            recentTransactions[c].date.month == weekDay.month &&
            recentTransactions[c].date.year == weekDay.year) {
          totalSum += recentTransactions[c].amount;
        }
      }
      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, element) {
      return sum + element["amount"];
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build() Chart");
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionsValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  label: data["day"],
                  spendingAmount: data["amount"],
                  spendingPctOfTotal: totalSpending == 0.0
                      ? 0.0
                      : (data["amount"] as double) / totalSpending,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
