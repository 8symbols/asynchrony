import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

void main() async {
  getJsonFromFile();
}

Future<void> getJsonFromFile() async {
  const filename = 'some_json.txt';

  final jsonData = await Isolate.run(() async {
    final fileData = await File(filename).readAsString();
    final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
    return jsonData;
  });

  print(jsonData);
}

Future<void> tryMutate() async {
  final list = [1, 2];

  await Isolate.run(() {
    list.add(3);
    print('worker isolate: $list');
  });

  print('main isolate: $list');
}

// Что можно передавать:
// https://api.dart.dev/stable/3.2.6/dart-isolate/SendPort/send.html
Future<void> dieFromCapturedUnsendable() async {
  const filename = 'some_json.txt';
  final openedFile = File(filename).open();

  final jsonData = await Isolate.run(() async {
    print(openedFile.runtimeType);
    final fileData = await File(filename).readAsString();
    final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
    return jsonData;
  });

  print(jsonData);
}

// Замыкания могут неявно захватывать лишнее и приводить к проблемам,
// лучше передавать в [Isolate.run] функцию, в которой все нужное состояние
// будет передаваться аргументами.
Future<void> getJsonFromFileWithoutClosure() async {
  const filename = 'some_json.txt';

  final jsonData = await Isolate.run(() => getJson(filename));

  print(jsonData);
}

Future<Map<String, dynamic>> getJson(String filename) async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
  return jsonData;
}
