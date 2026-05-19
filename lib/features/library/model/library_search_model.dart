import 'library_home_model.dart';

class LibrarySearchModel {
  final String query;
  final List<RecentSearchItem> recentSearches;
  final List<TrendingTopicItem> trendingTopics;
  final List<StudyGuideItem> materials;

  LibrarySearchModel({
    required this.query,
    required this.recentSearches,
    required this.trendingTopics,
    required this.materials,
  });

  factory LibrarySearchModel.fromJson(Map<String, dynamic> json) {
    return LibrarySearchModel(
      query: json['query']?.toString() ?? '',
      recentSearches: (json['recent_searches'] as List?)
              ?.map((e) =>
                  RecentSearchItem.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      trendingTopics: (json['trending_topics'] as List?)
              ?.map((e) =>
                  TrendingTopicItem.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      materials: (json['materials'] as List?)
              ?.map((e) =>
                  StudyGuideItem.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
    );
  }
}

class RecentSearchItem {
  final String id;
  final String query;
  final String? updatedAt;

  RecentSearchItem({
    required this.id,
    required this.query,
    this.updatedAt,
  });

  factory RecentSearchItem.fromJson(Map<String, dynamic> json) {
    return RecentSearchItem(
      id: json['id']?.toString() ?? '',
      query: json['query']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

class TrendingTopicItem {
  final String topicId;
  final String title;
  final String subtitle;

  TrendingTopicItem({
    required this.topicId,
    required this.title,
    required this.subtitle,
  });

  factory TrendingTopicItem.fromJson(Map<String, dynamic> json) {
    return TrendingTopicItem(
      topicId: json['topic_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
    );
  }
}
