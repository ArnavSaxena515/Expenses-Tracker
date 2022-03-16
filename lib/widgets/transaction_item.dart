import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'delete_button.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.userTransactions,
    required this.deleteItem,
    required this.index,
  }) : super(key: key);

  final Transaction userTransactions;
  final Function deleteItem;
  final int index;

  @override
  Widget build(BuildContext context) {
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
                "\$${userTransactions.amount.toStringAsFixed(2)}",
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
          userTransactions.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMMd().format(userTransactions.date),
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
                        userTransactions.description as String,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      DeleteButton(
                        deleteItem: deleteItem,
                        userTransactions: userTransactions,
                      ),
                    ],
                  ),
                );
              })
            : DeleteButton(
                deleteItem: deleteItem,
                userTransactions: userTransactions,
              ),
      ),
    );
  }
}
