import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/account.model.dart';
import '../model/category.model.dart';
import '../model/payment.model.dart';

const String BASE_URL = "http://10.0.2.2:8000/api";  // Replace with your API base URL

class PaymentApi {
  // Create a new payment transaction
  Future<int> create(Payment payment) async {
    final url = Uri.parse('$BASE_URL/payments');

    print('Sending account data: ${jsonEncode(payment.toJson())}');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];  // Assuming the API returns the created payment's ID
    } else {
      throw Exception('Failed to create account. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Fetch payment transactions with optional filters
  Future<List<Payment>> find({
    DateTimeRange? range,
    PaymentType? type,
    Category? category,
    Account? account,
  }) async {
    final url = Uri.parse('$BASE_URL/payments');

    // Build query parameters
    Map<String, String> params = {};
    if (range != null) {
      params['start_date'] = DateFormat('yyyy-MM-dd').format(range.start);
      params['end_date'] = DateFormat('yyyy-MM-dd').format(range.end.add(const Duration(days: 1)));
    }
    if (type != null) {
      params['type'] = type == PaymentType.credit ? 'DR' : 'CR';
    }
    if (account != null) {
      params['account_id'] = account.id.toString();
    }
    if (category != null) {
      params['category_id'] = category.id.toString();
    }

    // Add query parameters to the URL
    final uri = url.replace(queryParameters: params);

    final response = await http.get(uri, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> paymentsJson = jsonDecode(response.body);
      return paymentsJson.map((json) => Payment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load payments');
    }
  }


  // Update an existing payment transaction
  Future<int> update(Payment payment) async {
    final url = Uri.parse('$BASE_URL/payments/${payment.id}');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode == 200) {
      return payment.id!;  // Return the ID of the updated payment
    } else {
      throw Exception('Failed to update payment');
    }
  }

  // Upsert (update or create) a payment transaction
  Future<int> upsert(Payment payment) async {
    if (payment.id != null) {
      return await update(payment);
    } else {
      return await create(payment);
    }
  }

  // Delete a specific payment transaction
  Future<int> deleteTransaction(int id) async {
    final url = Uri.parse('$BASE_URL/payments/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return id;  // Return the ID of the deleted payment
    } else {
      throw Exception('Failed to delete payment');
    }
  }

  // Delete all payment transactions
  Future<void> deleteAllTransactions() async {
    final url = Uri.parse('$BASE_URL/payments');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete all payments');
    }
  }
}
