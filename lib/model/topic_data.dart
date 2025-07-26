class TopicData {
  final Map<String, List<String>> categories;

  TopicData({required this.categories});

  factory TopicData.fromJson(Map<String, dynamic> json) {
    final categories = <String, List<String>>{};
    json.forEach((key, value) {
      if (value is List) {
        categories[key] = value.cast<String>();
      }
    });
    return TopicData(categories: categories);
  }

  List<String> get categoryNames => categories.keys.toList();

  List<String> getTopicsForCategory(String category) {
    return categories[category] ?? [];
  }
}