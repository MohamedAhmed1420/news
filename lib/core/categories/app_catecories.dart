import 'package:flutter/cupertino.dart';

class AppCatecories {
  String? id;
  String? name;
  String? image;

  AppCatecories({required this.id, required this.name, required this.image });
  static List<AppCatecories> categories=[
      AppCatecories(id: "general", name: "General", image: "assets/categories/general.png"),
      AppCatecories(id: "business", name: "Business", image: "assets/categories/busniess.png"),
      AppCatecories(id: "sports", name: "Sports", image: "assets/categories/sport.png"),
      AppCatecories(id: "technology", name: "Technology", image: "assets/categories/technology.png"),
      AppCatecories(id: "health", name: "Health", image: "assets/categories/health.png"),
      AppCatecories(id: "science", name: "Science", image: "assets/categories/science.png"),
      AppCatecories(id: "entertainment", name: "Entertainment", image: "assets/categories/entertainment.png"),
  ];
}
