class InstructionPage {
  final String title;
  final String image;
  final String description;

  InstructionPage({
    required this.title,
    required this.image,
    required this.description,
  });

  factory InstructionPage.fromJson(Map<String, dynamic> json) {
    return InstructionPage(
      title: json['title'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }
}

class InstructionData {
  final List<InstructionPage> pages;

  InstructionData({required this.pages});

  factory InstructionData.fromJson(List<dynamic> json) {
    final pages = json.map((item) => InstructionPage.fromJson(item)).toList();
    return InstructionData(pages: pages);
  }
}