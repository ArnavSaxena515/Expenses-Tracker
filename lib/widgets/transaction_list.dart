import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_item.dart';

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
              return TransactionItem(
                userTransactions: userTransactions[index],
                deleteItem: deleteItem,
                index: index,
              );
            },
          );
  }
}
