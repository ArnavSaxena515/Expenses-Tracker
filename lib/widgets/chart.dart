import 'package:expenses_tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key, required this.recentTransactions}) : super(key: key);
  final List<Transaction> recentTransactions;

  // getter to get groupedTransactions, grouped by weekdays for current day and previous 6 days.
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      //obtain the weekday to group the transactions for a particular weekday. Index goes from 0-6
      // so now - 0 = today, now-1 = yesterday, so on
      final weekDay = DateTime.now().subtract(Duration(days: index)); // subtract the index from current day
      // to get values for previous days

      double totalSum = 0.0; // value to store total amount spent on that particular weekday
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day && recentTransactions[i].date.month == weekDay.month && recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      } // loop through the total list of transactions to see
      // which transaction matches current day

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
    // return a map from the function that has the day and amount keys to indicate the expenditure for a weekday
    // this is done till the list that is generated has a size of 7

    //overall, generate a list of key value pairs to group the total transaction by days for the last 7 days and
    // sum the amount for each day
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0, (sum, item) => sum += item['amount'] as double);
  } // getter to calc total spending

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: groupedTransactionValues
                .map(
                  (data) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      label: data['day'].toString(),
                      spentAmount: (data['amount'] as double),
                      spentPercentageTotal: totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
