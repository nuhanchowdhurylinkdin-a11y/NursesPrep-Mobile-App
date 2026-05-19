class PracticeDataModel {
  final List<CategoryModel> categories;
  final List<TopicModel> topics;
  final List<DifficultyModel> difficulties;
  final List<LicenseModel> licenses;

  PracticeDataModel({
    required this.categories,
    required this.topics,
    required this.difficulties,
    required this.licenses,
  });

  factory PracticeDataModel.fromJson(Map<String, dynamic> json) {
    return PracticeDataModel(
      categories: (json['categories'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      topics: (json['topics'] as List)
          .map((e) => TopicModel.fromJson(e))
          .toList(),
      difficulties: (json['difficulties'] as List)
          .map((e) => DifficultyModel.fromJson(e))
          .toList(),
      licenses: (json['licenses'] as List)
          .map((e) => LicenseModel.fromJson(e))
          .toList(),
    );
  }
}

class CategoryModel {
  final String id;
  final String categoryName;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      categoryName: json['category_name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class TopicModel {
  final String id;
  final String topicName;
  final DateTime createdAt;

  TopicModel({
    required this.id,
    required this.topicName,
    required this.createdAt,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] ?? '',
      topicName: json['topic_name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class DifficultyModel {
  final String id;
  final String levelName;
  final DateTime createdAt;

  DifficultyModel({
    required this.id,
    required this.levelName,
    required this.createdAt,
  });

  factory DifficultyModel.fromJson(Map<String, dynamic> json) {
    return DifficultyModel(
      id: json['id'] ?? '',
      levelName: json['level_name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class LicenseModel {
  final String id;
  final String licenseName;
  final DateTime createdAt;

  LicenseModel({
    required this.id,
    required this.licenseName,
    required this.createdAt,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      id: json['id'] ?? '',
      licenseName: json['license_name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
