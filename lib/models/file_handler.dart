//Class to handler reading and writing data to local storage
import 'dart:convert';

import 'package:expenses_tracker/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileHandler {
  final SharedPreferences prefs; //gets a shared preference from user's memory

  FileHandler({required this.prefs});

  String objectToString(Transaction object) {
    String objectAsString = "";
    objectAsString = jsonEncode(object); //json encoder for serializable class to convert object data into a json string

    return objectAsString;
  }

  // function to write the user data in a file
  void writeData(List<Transaction> listToWrite) {
    List<String> collectiveData = [];
    for (var element in listToWrite) {
      collectiveData.add(objectToString(element)); //write data into user's local storage via the preference
    }
    prefs.setStringList('transactions', collectiveData); //write the list of json strings to memory
  }

  List<Transaction> readData() {
    //function to read user transaction data from shared preferences
    List<Transaction> transactions = []; //empty list to be populated and returned
    final data = prefs.getStringList('transactions'); //get the list of strings from the file
    if (data!.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        var newData = jsonDecode(data[i]); //returns a dynamic object that must be parsed into a transaction object so that it can be added to the transactions list
        Transaction newItem = Transaction(
            id: newData["id"], title: newData["title"], amount: newData["amount"], date: DateTime.parse(newData["date"]), description: newData["description"]);
        transactions.add(newItem);
      }
    } else {
      transactions = [];
    }
    transactions.sort((b, a) {
      return a.date.compareTo(b.date);
    }); // sort transactions according to date

    return transactions;
  }
}
