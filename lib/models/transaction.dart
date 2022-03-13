import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String? description;
  String? dateAsString;

  Transaction({required this.id, required this.title, required this.amount, required this.date, this.description, this.dateAsString}) {
    dateAsString = DateFormat.yMMMMd().format(date).toString();
  }

  String dateToString() {
    return DateFormat.yMMMMd().format(date).toString();
  }

  DateTime stringToDate() {
    return DateTime.parse(dateAsString!);
  }

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  // Transaction.fromJson(Map<Object, dynamic> json)
  //     : id = json['id'],
  //       title = json['title'],
  //       amount = json['amount'],
  //       //      DateFormat.yMMMMd().format(date).toString()
  //       date = json['date'],
  //       description = json['description'];
  //
  // static Map<String, dynamic> toJson(Transaction value) =>
  //     {'id': value.id, 'title': value.title, 'amount': value.amount, 'date': value.date, 'description': value.description};
}
