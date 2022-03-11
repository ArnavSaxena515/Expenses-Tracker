import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  const NewTransaction({Key? key, required this.addTransactionMethod}) : super(key: key);
  final Function addTransactionMethod;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _descriptionTextController = TextEditingController(text: "");

  final _titleTextController = TextEditingController();

  final _amountTextController = TextEditingController();
  DateTime _dateSelected = DateTime.now();
  bool _datePicked = false;

  void _submitMethod() {
    final title = _titleTextController.text;
    final description = _descriptionTextController.text;
    final amount = double.parse(_amountTextController.text);

    if (title.isEmpty || amount <= 0 || _datePicked == false) return;
    _datePicked = false;
    widget.addTransactionMethod(amount, title, description, _dateSelected);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year), lastDate: DateTime.now()).then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() => _dateSelected = selectedDate);
      _datePicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          right: 8.0,
          bottom: 8.0 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter service/item bought",
                  labelText: "Title",
                ),
                controller: _titleTextController,
                onSubmitted: (_) {
                  _submitMethod();
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter cost",
                  labelText: "Amount",
                ),
                onSubmitted: (_) {
                  _submitMethod();
                },
                controller: _amountTextController,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter additional information(optional)",
                  labelText: "Comments",
                ),
                controller: _descriptionTextController,
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_datePicked == false ? "No Date Chosen" : "Date picked: ${DateFormat.yMMMMEEEEd().format(_dateSelected)}"),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        "Choose Date",
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                  foregroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                ),
                onPressed: _submitMethod,
                child: const Text(
                  "Add Transaction",
                  // style: TextStyle(
                  //   color: Colors.purple,
                  // ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
