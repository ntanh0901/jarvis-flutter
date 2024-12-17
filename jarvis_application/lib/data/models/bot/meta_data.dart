class MetaData {
  final int limit;
  final int total;
  final int offset;
  final bool hasNext;

  MetaData({
    required this.limit,
    required this.total,
    required this.offset,
    required this.hasNext,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      offset: json['offset'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'total': total,
      'offset': offset,
      'hasNext': hasNext,
    };
  }
}