class AppCategory {
  String id;
  String name;
  String image;

  AppCategory({required this.id, required this.name, required this.image});
  static List<AppCategory> categories = [
    AppCategory(id: "general", name: "General", image: "assets/categories/general.png"),
    AppCategory(id: "business", name: "Business", image: "assets/categories/busniess.png"),
    AppCategory(id: "sports", name: "Sports", image: "assets/categories/sport.png"),
    AppCategory(id: "technology", name: "Technology", image: "assets/categories/technology.png"),
    AppCategory(id: "health", name: "Health", image: "assets/categories/health.png"),
    AppCategory(id: "science", name: "Science", image: "assets/categories/science.png"),
    AppCategory(id: "entertainment", name: "Entertainment", image: "assets/categories/entertainment.png"),
  ];
}
