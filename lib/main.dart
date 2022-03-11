import 'dart:io';

import 'package:expenses_tracker/widgets/chart.dart';
import 'package:expenses_tracker/widgets/new_transaction.dart';
import 'package:expenses_tracker/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

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
  final List<Transaction> _userTransactions = []; // List to hold the objects of Transaction Model class

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
  bool _showChart = false;
  Column buildLandscapeColumn(MediaQueryData mediaQuery, PreferredSizeWidget appBar, BuildContext context, Container chartContainer, SizedBox transactionsListBox) {
    return Column(//Column to draw if landscape orientation
        children: [
      SizedBox(
        //Widget to show switch if we use landscape mode, should only be visible if orientation is landscape
        height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch.adaptive(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: _showChart,
                onChanged: (value) {
                  setState(() => _showChart = value);
                }),
            Text(
              "Show Chart",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      // if showChart is true, display chart, else display transactionsList
      _showChart ? chartContainer : transactionsListBox,
    ]

        //showChart && landscape: show Chart
        //showchart && !landscape => show TransactionList
        //!landscape => showChart and TransactionList

        );
  } // function to return a column for landscape orientation

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool _isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = Platform
            .isIOS // add type of widget because dart inference will see this object as a type widget and widget by default does not have a preferred sized object, so mention that apBar is a preferred size widget
        ? CupertinoNavigationBar(
            middle: const Text("Expenses Tracker"),
            trailing: Row(
              children: [
                IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: const Icon(
                    CupertinoIcons.add,
                  ),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text("Expenses Tracker"),
            actions: [
              IconButton(
                onPressed: () {
                  _startAddNewTransaction(context);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ) as PreferredSizeWidget;
    final chartContainer = Container(
      height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) *
          (_isLandscape ? 0.7 : 0.3), // change scaling factor based on the device orientation
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Chart(recentTransactions: _recentTransactions),
    );
    final transactionsListBox = SizedBox(
      height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * (_isLandscape ? 0.9 : 0.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: TransactionList(
          userTransactions: _userTransactions,
          deleteItem: _deleteTransaction,
        ),
      ),
    );

    final _screenBody = _isLandscape
        ? buildLandscapeColumn(mediaQuery, appBar, context, chartContainer, transactionsListBox)
        : Column(
            // for landscape mode show chart as well as transactions list
            children: [
              chartContainer,
              transactionsListBox,
            ],
          );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: _screenBody,
          )
        : Scaffold(
            appBar: appBar,
            body: _screenBody,
            floatingActionButton: Platform.isIOS
                ? const SizedBox()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                  ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
  }
}
