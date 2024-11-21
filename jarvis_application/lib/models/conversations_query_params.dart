
import 'assistant_dto.dart';

class ConversationsQueryParams {
  String? cursor;
  int? limit;
  Id? assistantId;
  Model? assistantModel;

  ConversationsQueryParams({
     this.cursor ='',
     this.limit=100,
     this.assistantId,
     this.assistantModel,
  });

  void setCursor(String cursor) {
    this.cursor = cursor;
  }
  void setLimit(int limit) {
    this.limit = limit;
  }
  void setAssistantId(Id assistantId) {
    this.assistantId = assistantId;
  }
  void setAssistantModel(Model assistantModel) {
    this.assistantModel = assistantModel;
  }

  factory ConversationsQueryParams.fromJson(Map<String, dynamic> json) {
    return ConversationsQueryParams(
      cursor: json['cursor'],
      limit: json['limit'],
      assistantId: idValues.map[json['assistantId']]!,
      assistantModel: modelValues.map[json["assistantModel"]] ?? Model.DIFY,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cursor': cursor,
      'limit': limit,
      'assistantId': assistantId,
      'assistantModel': assistantModel,
    };
  }
  Map<String, dynamic> toJson2Params() {
    return {
      'assistantId': idValues.reverse[assistantId],
      'assistantModel': modelValues.reverse[assistantModel],
    };
  }


}
