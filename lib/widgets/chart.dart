// ignore_for_file: must_be_immutable

import 'package:expenses_tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatefulWidget {
  Chart({Key? key, required this.recentTransactions, required this.height, required this.referenceDate}) : super(key: key);
  final List<Transaction> recentTransactions;
  final double height;
  DateTime referenceDate;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  // getter to get groupedTransactions, grouped by weekdays for current day and previous 6 days.
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      //obtain the weekday to group the transactions for a particular weekday. Index goes from 0-6
      // so now - 0 = today, now-1 = yesterday, so on
      final weekDay = DateTime.now().subtract(Duration(days: index)); // subtract the index from current day
      // to get values for previous days

      double totalSum = 0.0; // value to store total amount spent on that particular weekday
      for (int i = 0; i < widget.recentTransactions.length; i++) {
        if (widget.recentTransactions[i].date.day == weekDay.day &&
            widget.recentTransactions[i].date.month == weekDay.month &&
            widget.recentTransactions[i].date.year == weekDay.year) {
          totalSum += widget.recentTransactions[i].amount;
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

// function to get transaction values before a certain date that is passed as a parameter
  List<Map<String, Object>> groupedTransactionValuesBeforeDate(DateTime dateReference) {
    return List.generate(7, (index) {
      //obtain the weekday to group the transactions for a particular weekday. Index goes from 0-6
      // so now - 0 = referenceDate, now-1 = yesterday, so on
      final weekDay = dateReference.subtract(Duration(days: index)); // subtract the index from given day
      // to get values for previous days

      double totalSum = 0.0; // value to store total amount spent on that particular weekday
      for (int i = 0; i < widget.recentTransactions.length; i++) {
        if (widget.recentTransactions[i].date.day == weekDay.day &&
            widget.recentTransactions[i].date.month == weekDay.month &&
            widget.recentTransactions[i].date.year == weekDay.year) {
          totalSum += widget.recentTransactions[i].amount;
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
  }

  // getter to calc total spending before a certain date
  double totalSpendingBeforeDate(DateTime dateReference) {
    return groupedTransactionValuesBeforeDate(dateReference).fold(0, (sum, item) => sum += item['amount'] as double);
  }

  // getter to calc total spending
  // DateTime dateReference = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height * 0.15,
          //allows user to adjust the date to see expendtitures in different weeks
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.referenceDate = widget.referenceDate.subtract(const Duration(days: 7));
                      //   print(dateReference.toString());
                    });
                  },
                  icon: Icon(
                    Icons.arrow_left,
                    color: Theme.of(context).primaryColor,
                  )),
              Text(
                "${DateFormat.yMMMMd().format(widget.referenceDate.subtract(const Duration(days: 7)))} - ${DateFormat.yMMMMd().format(widget.referenceDate)}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 13,
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (widget.referenceDate.add(const Duration(days: 7)).isBefore(DateTime.now())) {
                        widget.referenceDate = widget.referenceDate.add(const Duration(days: 7));
                      }
                      // print(dateReference.toString());
                    });
                  },
                  icon: Icon(
                    Icons.arrow_right,
                    color: Theme.of(context).primaryColor,
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year), lastDate: DateTime.now())
                          .then((selectedDate) {
                        if (selectedDate == null) {
                          return;
                        }
                        setState(() => widget.referenceDate = selectedDate);
                      });
                    },
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Theme.of(context).primaryColor,
                    )),
              )
            ],
          ),
        ),
        SizedBox(
          height: widget.height * 0.75,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...groupedTransactionValuesBeforeDate(widget.referenceDate).map(
                    (data) {
                      // print("Day: ${data['day']}, amount : ${data['amount']}");
                      return Flexible(
                        fit: FlexFit.tight,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: widget.height),
                          child: ChartBar(
                            label: data['day'].toString(),
                            spentAmount: (data['amount'] as double),
                            spentPercentageTotal:
                                totalSpendingBeforeDate(widget.referenceDate) == 0.0 ? 0.0 : (data['amount'] as double) / totalSpendingBeforeDate(widget.referenceDate),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
          ),
        ),
        Expanded(
            child: Text(
          "Expenditure for that week: ₹${totalSpendingBeforeDate(widget.referenceDate).toStringAsFixed(2)}",
          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
        ))
      ],
    );
  }
}
