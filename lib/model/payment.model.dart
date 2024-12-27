import 'package:intl/intl.dart';

import 'account.model.dart';
import 'category.model.dart';

enum PaymentType {
  debit,
  credit
}
class Payment {
  final int? id;
  final String title;
  final String description;
  final Account account;
  final Category category;
  final double amount;
  final PaymentType type;
  final DateTime datetime;

  Payment({
    required this.id,
    required this.title,
    required this.description,
    required this.account,
    required this.category,
    required this.amount,
    required this.type,
    required this.datetime,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      account: Account.fromJson(json['account']),
      category: Category.fromJson(json['category']),
      amount: double.parse(json['amount']), // Konversi String ke double
      type: json['type'] == "CR" ? PaymentType.credit : PaymentType.debit,
      datetime: DateTime.parse(json['datetime']),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "account": account.id,
    "category": category.id,
    "amount": amount,
    "datetime": DateFormat('yyyy-MM-dd kk:mm:ss').format(datetime),
    "type": type == PaymentType.credit ? "CR": "DR",
  };
}