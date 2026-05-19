class LibraryHomeModel {
  final SavedTopicsInfo savedTopics;
  final List<MedicalCategoryItem> medicalCategories;
  final List<StudyGuideItem> studyGuides;

  LibraryHomeModel({
    required this.savedTopics,
    required this.medicalCategories,
    required this.studyGuides,
  });

  factory LibraryHomeModel.fromJson(Map<String, dynamic> json) {
    return LibraryHomeModel(
      savedTopics: SavedTopicsInfo.fromJson(json['saved_topics'] ?? {}),
      medicalCategories: (json['medical_categories'] as List?)
              ?.map((e) => MedicalCategoryItem.fromJson(e))
              .toList() ??
          [],
      studyGuides: (json['study_guides'] as List?)
              ?.map((e) => StudyGuideItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SavedTopicsInfo {
  final int totalBookmarked;

  SavedTopicsInfo({required this.totalBookmarked});

  factory SavedTopicsInfo.fromJson(Map<String, dynamic> json) {
    return SavedTopicsInfo(
      totalBookmarked: json['total_bookmarked'] ?? 0,
    );
  }
}

class MedicalCategoryItem {
  final String id;
  final String name;
  final int totalMaterials;

  MedicalCategoryItem({
    required this.id,
    required this.name,
    required this.totalMaterials,
  });

  factory MedicalCategoryItem.fromJson(Map<String, dynamic> json) {
    return MedicalCategoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      totalMaterials: json['total_materials'] ?? 0,
    );
  }
}

class StudyGuideItem {
  final String id;
  final String title;
  final String description;
  final String itemType;
  final String badgeLabel;
  final GuideCategory? category;
  final GuideTopic? topic;
  final String? fileName;
  final String? fileUrl;
  final int? pageCount;
  final int? estimatedReadMinutes;
  final bool isSaved;
  final bool hasViewed;
  final String userState;
  final double? progressPercentage;
  final String? thumbnailUrl;
  final String? updatedAt;

  StudyGuideItem({
    required this.id,
    required this.title,
    required this.description,
    required this.itemType,
    required this.badgeLabel,
    this.category,
    this.topic,
    this.fileName,
    this.fileUrl,
    this.pageCount,
    this.estimatedReadMinutes,
    required this.isSaved,
    required this.hasViewed,
    required this.userState,
    this.progressPercentage,
    this.thumbnailUrl,
    this.updatedAt,
  });

  bool get isPdf =>
      fileName != null && fileName!.toLowerCase().endsWith('.pdf');

  factory StudyGuideItem.fromJson(Map<String, dynamic> json) {
    return StudyGuideItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      itemType: json['item_type'] ?? '',
      badgeLabel: json['badge_label'] ?? '',
      category: json['category'] != null
          ? GuideCategory.fromJson(json['category'])
          : null,
      topic: json['topic'] != null
          ? GuideTopic.fromJson(json['topic'])
          : null,
      fileName: json['file_name'],
      fileUrl: json['file_url'],
      pageCount: json['page_count'],
      estimatedReadMinutes: json['estimated_read_minutes'],
      isSaved: json['is_saved'] ?? false,
      hasViewed: json['has_viewed'] ?? false,
      userState: json['user_state'] ?? 'unread',
      progressPercentage: json['progress_percentage'] != null
          ? (json['progress_percentage'] as num).toDouble()
          : null,
      thumbnailUrl: json['thumbnail_url'],
      updatedAt: json['updated_at'],
    );
  }
}

class GuideCategory {
  final String id;
  final String name;

  GuideCategory({required this.id, required this.name});

  factory GuideCategory.fromJson(Map<String, dynamic> json) {
    return GuideCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class GuideTopic {
  final String id;
  final String name;

  GuideTopic({required this.id, required this.name});

  factory GuideTopic.fromJson(Map<String, dynamic> json) {
    return GuideTopic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
