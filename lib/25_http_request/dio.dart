import 'dart:io';

import 'package:dio/dio.dart';

import 'todo_dto.dart';

void main() async {
  final echoUrl = 'https://echo.free.beeceptor.com';
  await post(echoUrl);

  // try {
  //   final todos = await getTodos();
  //   print('todos count: ${todos.length}');
  //   print('first todo: ${todos.first}');
  // } catch (e) {
  //   print('exception: $e');
  // }
}

Future<void> get(String url) async {
  final dio = Dio();

  try {
    final queryParameters = {
      'param1': 'one',
      'param2': 'two',
    };

    var response = await dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(
        headers: {'header1': 'value1'},
      ),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.data}');
  } catch (e) {
    print('error: $e');
  } finally {
    dio.close();
  }
}

Future<void> post(String url) async {
  final dio = Dio();

  try {
    var response = await dio.post(
      url,
      data: {'name': 'doodle', 'color': 'blue'},
      options: Options(
        headers: {'header1': 'value1'},
      ),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.data}');
  } catch (e) {
    print('error: $e');
  } finally {
    dio.close();
  }
}

Future<List<TodoDto>> getTodos() async {
  const url = 'https://jsonplaceholder.typicode.com/todos';

  final dio = Dio();

  try {
    final response = await dio.get(url);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('bad code');
    }

    final jsonList = response.data as List<dynamic>;
    return jsonList.map((json) => TodoDto.fromJson(json)).toList();
  } finally {
    dio.close();
  }
}
