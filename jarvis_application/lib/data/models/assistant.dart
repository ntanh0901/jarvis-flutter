import 'assistant_dto.dart';

class Assistant {
  final AssistantDto dto;
  final String imagePath;

  Assistant({
    required this.dto,
    required this.imagePath,
  });

  Id? get id => dto.id;
  Model get model => dto.model;
}
