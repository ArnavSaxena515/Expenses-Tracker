import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'delete_button.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key, required this.userTransactions, required this.deleteItem}) : super(key: key);
  final List<Transaction> userTransactions;
  final Function deleteItem;

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                FittedBox(
                  child: Text(
                    "No transactions added yet",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.10,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.70,
                  child: Image.asset(
                    'assets/image/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: userTransactions.length,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 6,
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Text(
                          "\$${userTransactions[index].amount.toStringAsFixed(2)}",
                          textAlign: TextAlign.center,
                          // style: TextStyle(
                          //   color: Theme.of(context).primaryColor,
                          //   fontSize: 20,
                          //   fontWeight: FontWeight.bold,
                          // ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    userTransactions[index].title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd().format(userTransactions[index].date),
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 13,
                    ),
                  ),
                  trailing: MediaQuery.of(context).size.width > 400
                      ? LayoutBuilder(builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth - 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userTransactions[index].description as String,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                DeleteButton(
                                  deleteItem: deleteItem,
                                  userTransactions: userTransactions,
                                  index: index,
                                ),
                              ],
                            ),
                          );
                        })
                      : DeleteButton(
                          deleteItem: deleteItem,
                          userTransactions: userTransactions,
                          index: index,
                        ),
                ),
              );
            },
          );
  }
}
