class AssistantDto {
  final String id;
  final String model;

  AssistantDto({required this.id, required this.model});

  Map<String, dynamic> toJson() => {
    'id': id,
    'model': model,
  };

  factory AssistantDto.fromJson(Map<String, dynamic> json) {
    return AssistantDto(
      id: json['id'],
      model: json['model'],
    );
  }
}
