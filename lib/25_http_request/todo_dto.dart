import 'package:json_annotation/json_annotation.dart';

part 'todo_dto.g.dart';

@JsonSerializable()
class TodoDto {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'userId')
  final int userId;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'completed', defaultValue: false)
  final bool isCompleted;

  const TodoDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.isCompleted,
  });
  //
  // TodoDto.fromJson(Map<String, dynamic> json)
  //     : id = json['id'],
  //       userId = json['userId'],
  //       title = json['title'],
  //       isCompleted = json['completed'];
  //
  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'userId': userId,
  //       'title': title,
  //       'completed': isCompleted,
  //     };

  factory TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoDtoToJson(this);

  @override
  String toString() => 'TodoDto: '
      'id = $id, '
      'userId = $userId, '
      'title = $title, '
      'completed = $isCompleted';
}
