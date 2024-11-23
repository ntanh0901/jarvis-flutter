import 'dart:convert';

///AssistantDto
class AssistantDto {
  Id? id;
  Model model;
  late String name; // Thêm trường name và khởi tạo

  AssistantDto({
    this.id,
    required this.model,
  }) {
    // Gán giá trị cho name dựa trên id
    name = _generateNameFromId(id);
  }

  factory AssistantDto.fromJson(Map<String, dynamic> json) => AssistantDto(
    id: idValues.map[json["id"]]!,
    model: modelValues.map[json["model"]] ?? Model.DIFY,
  );

  Map<String, dynamic> toJson() => {
    "id": idValues.reverse[id],
    "model": modelValues.reverse[model],
    "name": name, // Thêm name vào toJson
  };

  @override
  String toString() => '$id ($model)';

  // Hàm nội bộ để tạo name từ id
  String _generateNameFromId(Id? id) {
    if (id == null) return "Unknown";
    switch (id) {
      case Id.CLAUDE_3_HAIKU_20240307:
        return "Claude 3 Haiku";
      case Id.CLAUDE_3_SONNET_20240229:
        return "Claude 3 Sonnet";
      case Id.GEMINI_15_FLASH_LATEST:
        return "Gemini 1.5 Flash Latest";
      case Id.GEMINI_15_PRO_LATEST:
        return "Gemini 1.5 Pro Latest";
      case Id.GPT_4_O:
        return "GPT-4O";
      case Id.GPT_4_O_MINI:
        return "GPT-4O Mini";
      default:
        return "Unknown";
    }
  }
}

enum Id {
  CLAUDE_3_HAIKU_20240307,
  CLAUDE_3_SONNET_20240229,
  GEMINI_15_FLASH_LATEST,
  GEMINI_15_PRO_LATEST,
  GPT_4_O,
  GPT_4_O_MINI
}

final idValues = EnumValues({
  "claude-3-haiku-20240307": Id.CLAUDE_3_HAIKU_20240307,
  "claude-3-sonnet-20240229": Id.CLAUDE_3_SONNET_20240229,
  "gemini-1.5-flash-latest": Id.GEMINI_15_FLASH_LATEST,
  "gemini-1.5-pro-latest": Id.GEMINI_15_PRO_LATEST,
  "gpt-4o": Id.GPT_4_O,
  "gpt-4o-mini": Id.GPT_4_O_MINI
});

enum Model {
  DIFY
}

final modelValues = EnumValues({
  "dify": Model.DIFY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
