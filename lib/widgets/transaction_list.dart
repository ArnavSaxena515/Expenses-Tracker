import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key, required this.userTransactions, required this.deleteItem}) : super(key: key);
  final List<Transaction> userTransactions;
  final Function deleteItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: userTransactions.isEmpty
          ? Column(
              children: [
                Text(
                  "No transactions added yet",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/image/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
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
                      DateFormat.yMMMMEEEEd().format(userTransactions[index].date),
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 13,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                      ),
                      onPressed: () => deleteItem(userTransactions[index].id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
