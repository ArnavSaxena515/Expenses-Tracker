import 'package:flutter/material.dart';

import '../models/transaction.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
    required this.deleteItem,
    required this.userTransactions,
    required this.index,
  }) : super(key: key);

  final Function deleteItem;
  final List<Transaction> userTransactions;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Theme.of(context).errorColor,
      ),
      onPressed: () => deleteItem(userTransactions[index].id),
    );
  }
}
