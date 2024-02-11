import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'todo_dto.dart';

void main() async {
  final echoUrl = Uri.https('echo.zuplo.io');
  await oneTimeRequest(echoUrl);

  // try {
  //   final todos = await getTodos();
  //   print('todos count: ${todos.length}');
  //   print('first todo: ${todos.first}');
  // } catch (e) {
  //   print('exception: $e');
  // }
}

Future<void> oneTimeRequest(Uri url) async {
  try {
    var response = await http.post(
      url,
      headers: {'header1': 'value1'},
      body: {'name': 'doodle', 'color': 'blue'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (e) {
    print('error: $e');
  }
}

Future<void> requestWithClient(Uri url) async {
  final client = http.Client();

  try {
    final queryParameters = {
      'param1': 'one',
      'param2': 'two',
    };

    var response = await client.get(
      url.replace(queryParameters: queryParameters),
      headers: {'header1': 'value1'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (e) {
    print('error: $e');
  } finally {
    client.close(); // А если не закрыть?
  }
}

Future<List<TodoDto>> getTodos() async {
  final url = Uri.https('jsonplaceholder.typicode.com', 'todos');

  final response = await http.get(url);

  if (response.statusCode != HttpStatus.ok) {
    throw Exception('bad code');
  }

  final string = response.body;
  final jsonList = jsonDecode(string) as List<dynamic>;
  return jsonList.map((json) => TodoDto.fromJson(json)).toList();
}
