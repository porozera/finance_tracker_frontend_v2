import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Category {
  int? id;
  String name;
  IconData icon;
  Color color;
  double? budget;
  double? expense;

  Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.budget,
    this.expense,
  });

  factory Category.fromJson(Map<String, dynamic> data) => Category(
    id: data["id"],
    name: data["name"],
    icon: IconData(data["icon"], fontFamily: 'MaterialIcons'),
    color: Color(data["color"]),
    budget: data["budget"] != null
        ? double.tryParse(data["budget"].toString()) ?? 0.0
        : 0.0,
    expense: data["expense"] != null
        ? double.tryParse(data["expense"].toString()) ?? 0.0
        : 0.0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon.codePoint,
    "color": color.value,
    "budget": budget?.toStringAsFixed(2), // Simpan sebagai string untuk konsistensi
    "expense": expense?.toStringAsFixed(2),
  };
}
