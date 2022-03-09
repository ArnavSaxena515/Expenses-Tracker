import 'package:expenses_tracker/widgets/chart.dart';
import 'package:expenses_tracker/widgets/new_transaction.dart';
import 'package:expenses_tracker/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expenses Tracker",
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold),
              titleLarge: const TextStyle(fontFamily: 'Ubuntu', fontSize: 25, fontWeight: FontWeight.bold),
              titleSmall: const TextStyle(fontFamily: 'Ubuntu', fontSize: 15, fontWeight: FontWeight.bold),
            ),
        appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(fontFamily: 'Ubuntu', fontSize: 20, fontWeight: FontWeight.bold)),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(secondary: Colors.amber),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(id: "t1", title: "Jacket", amount: 1200, date: DateTime.now()),
    // Transaction(id: "t2", title: "Shoes", amount: 2000, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      //tx is transaction
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addUserTransaction(double amount, String title, String description, DateTime date) {
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
      description: description,
    );
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(
            addTransactionMethod: _addUserTransaction,
          );
        });
  }

  void _deleteTransaction(String id) => setState(() => _userTransactions.removeWhere((tx) => tx.id == id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses Tracker"),
        actions: [
          IconButton(
            onPressed: () {
              _startAddNewTransaction(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Chart(recentTransactions: _recentTransactions),
          ),
          TransactionList(
            userTransactions: _userTransactions,
            deleteItem: _deleteTransaction,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _startAddNewTransaction(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
