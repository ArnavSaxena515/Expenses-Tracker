import 'package:flutter/material.dart';

import '../models/transaction.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
    required this.deleteItem,
    required this.userTransactions,
  }) : super(key: key);

  final Function deleteItem;
  final Transaction userTransactions;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Theme.of(context).errorColor,
      ),
      onPressed: () => deleteItem(userTransactions.id),
    );
  }
}
