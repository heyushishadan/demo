import 'dart:convert';

class DiaryEntry {
  final String id;
  String title;
  String content;
  DateTime updatedAt;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  factory DiaryEntry.newEntry() {
    final now = DateTime.now();
    return DiaryEntry(
      id: now.microsecondsSinceEpoch.toString(),
      title: '未命名日记',
      content: '',
      updatedAt: now,
    );
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static String encodeList(List<DiaryEntry> entries) {
    final list = entries.map((e) => e.toJson()).toList();
    return jsonEncode(list);
  }

  static List<DiaryEntry> decodeList(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded.map((e) => DiaryEntry.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }
}
