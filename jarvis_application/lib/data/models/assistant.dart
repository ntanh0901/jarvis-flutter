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

final List<Assistant> assistants = [
  Assistant(
    dto: AssistantDto(id: Id.GPT_4_O_MINI, model: Model.DIFY),
    imagePath: 'assets/images/gpt-4o-mini.png',
  ),
  Assistant(
    dto: AssistantDto(id: Id.GPT_4_O, model: Model.DIFY),
    imagePath: 'assets/images/gpt-4o.png',
  ),
  Assistant(
    dto: AssistantDto(id: Id.GEMINI_15_FLASH_LATEST, model: Model.DIFY),
    imagePath: 'assets/images/gemini-1.5-flash.png',
  ),
  Assistant(
    dto: AssistantDto(id: Id.GEMINI_15_PRO_LATEST, model: Model.DIFY),
    imagePath: 'assets/images/gemini-1.5-pro.jpg',
  ),
  Assistant(
    dto: AssistantDto(id: Id.CLAUDE_3_HAIKU_20240307, model: Model.DIFY),
    imagePath: 'assets/images/claude-3-haiku.png',
  ),
  Assistant(
    dto: AssistantDto(id: Id.CLAUDE_3_SONNET_20240229, model: Model.DIFY),
    imagePath: 'assets/images/claude-3-sonnet.jpg',
  ),
];
