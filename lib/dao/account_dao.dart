import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/account.model.dart';

const String BASE_URL = "http://10.0.2.2:8000/api";  // Replace with your API base URL

class AccountApi {
  // Create account
  Future<int> create(Account account) async {
    final url = Uri.parse('$BASE_URL/accounts');

    // Log untuk memeriksa data yang akan dikirim
    print('Sending account data: ${jsonEncode(account.toJson())}');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(account.toJson()),
    );

    if (response.statusCode == 201) {
      // Jika berhasil, kembalikan ID dari respons
      return jsonDecode(response.body)['id'];
    } else {
      // Jika gagal, lemparkan kesalahan yang lebih detail
      throw Exception('Failed to create account. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Get list of accounts with optional summary
  Future<List<Account>> find({bool withSummery = false}) async {
    final url = Uri.parse('$BASE_URL/accounts${withSummery ? '?withSummery=true' : ''}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> accountsJson = jsonDecode(response.body);
      return accountsJson.map((json) => Account.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  // Update account
  Future<int> update(Account account) async {
    final url = Uri.parse('$BASE_URL/accounts/${account.id}');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(account.toJson()),
    );

    if (response.statusCode == 200) {
      return account.id!;
    } else {
      throw Exception('Failed to update account');
    }
  }

  // Upsert (update or create) account
  Future<int> upsert(Account account) async {
    if (account.id != null) {
      return await update(account);
    } else {
      return await create(account);
    }
  }

  // Delete account
  Future<int> delete(int id) async {
    final url = Uri.parse('$BASE_URL/accounts/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return id;
    } else {
      throw Exception('Failed to delete account');
    }
  }
}
