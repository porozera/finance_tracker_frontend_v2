import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category.model.dart';

const String BASE_URL = "http://10.0.2.2:8000/api";  // Replace with your API base URL

class CategoryApi {
  // Create a new category
  Future<int> create(Category category) async {
    final url = Uri.parse('$BASE_URL/categories');

    print('Sending account data: ${jsonEncode(category.toJson())}');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];  // Assuming the API returns the created category's ID
    } else {
      throw Exception('Failed to create account. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Fetch a list of categories with optional summary
  Future<List<Category>> find({bool withSummery = true}) async {
    final url = Uri.parse('$BASE_URL/categories${withSummery ? '?withSummery=true' : ''}');
    final response = await http.get(url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');  // Debug log

    if (response.statusCode == 200) {
      List<dynamic> categoriesJson = jsonDecode(response.body);
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }

  }

  // Update an existing category
  Future<int> update(Category category) async {
    final url = Uri.parse('$BASE_URL/categories/${category.id}');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      return category.id!;  // Return the ID of the updated category
    } else {
      throw Exception('Failed to update category');
    }
  }

  // Upsert (update or create) a category
  Future<int> upsert(Category category) async {
    if (category.id != null) {
      return await update(category);
    } else {
      return await create(category);
    }
  }

  // Delete a category
  Future<int> delete(int id) async {
    final url = Uri.parse('$BASE_URL/categories/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return id;  // Return the ID of the deleted category
    } else {
      throw Exception('Failed to delete category');
    }
  }

  // Delete all categories
  Future<void> deleteAll() async {
    final url = Uri.parse('$BASE_URL/categories');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete all categories');
    }
  }
}
