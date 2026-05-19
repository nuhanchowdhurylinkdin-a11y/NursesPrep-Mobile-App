class MaterialDetailModel {
  final String id;
  final String title;
  final String description;
  final MaterialCategory? category;
  final MaterialTopic? topic;
  final bool isSaved;
  final bool hasViewed;
  final double? readingProgress;
  final MaterialResource? resource;
  final MaterialContent? content;
  final MaterialActions actions;

  MaterialDetailModel({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.topic,
    required this.isSaved,
    required this.hasViewed,
    this.readingProgress,
    this.resource,
    this.content,
    required this.actions,
  });

  static double? _parseReadingProgress(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is Map) {
      final pct = value['progress_percentage'];
      if (pct is num) return pct.toDouble();
    }
    return null;
  }

  factory MaterialDetailModel.fromJson(Map<String, dynamic> json) {
    return MaterialDetailModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] != null
          ? MaterialCategory.fromJson(json['category'])
          : null,
      topic: json['topic'] != null
          ? MaterialTopic.fromJson(json['topic'])
          : null,
      isSaved: json['is_saved'] ?? false,
      hasViewed: json['has_viewed'] ?? false,
      readingProgress: _parseReadingProgress(json['reading_progress']),
      resource: json['resource'] != null
          ? MaterialResource.fromJson(json['resource'])
          : null,
      content: json['content'] != null
          ? MaterialContent.fromJson(json['content'])
          : null,
      actions: MaterialActions.fromJson(json['actions'] ?? {}),
    );
  }
}

class MaterialCategory {
  final String id;
  final String name;

  MaterialCategory({required this.id, required this.name});

  factory MaterialCategory.fromJson(Map<String, dynamic> json) {
    return MaterialCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class MaterialTopic {
  final String id;
  final String name;

  MaterialTopic({required this.id, required this.name});

  factory MaterialTopic.fromJson(Map<String, dynamic> json) {
    return MaterialTopic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class MaterialResource {
  final String fileUrl;
  final String fileName;
  final int pageCount;
  final int estimatedReadMinutes;

  MaterialResource({
    required this.fileUrl,
    required this.fileName,
    required this.pageCount,
    required this.estimatedReadMinutes,
  });

  factory MaterialResource.fromJson(Map<String, dynamic> json) {
    return MaterialResource(
      fileUrl: json['file_url'] ?? '',
      fileName: json['file_name'] ?? '',
      pageCount: json['page_count'] ?? 0,
      estimatedReadMinutes: json['estimated_read_minutes'] ?? 0,
    );
  }
}

class MaterialContent {
  final String body;
  final List<String> sections;
  final List<String> clinicalPearls;

  MaterialContent({
    required this.body,
    required this.sections,
    required this.clinicalPearls,
  });

  factory MaterialContent.fromJson(Map<String, dynamic> json) {
    return MaterialContent(
      body: json['body'] ?? '',
      sections: (json['sections'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      clinicalPearls: (json['clinical_pearls'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class MaterialActions {
  final bool bookmarkSupported;
  final bool markAsCompleteSupported;
  final bool downloadSupported;

  MaterialActions({
    required this.bookmarkSupported,
    required this.markAsCompleteSupported,
    required this.downloadSupported,
  });

  factory MaterialActions.fromJson(Map<String, dynamic> json) {
    return MaterialActions(
      bookmarkSupported: json['bookmark_supported'] ?? false,
      markAsCompleteSupported: json['mark_as_complete_supported'] ?? false,
      downloadSupported: json['download_supported'] ?? false,
    );
  }
}
