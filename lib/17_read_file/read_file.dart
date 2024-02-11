import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('alice.txt');

  // await file.readAsString();
  // file.readAsStringSync();

  Stream<List<int>> content = file.openRead();

  var lineNumber = 0;
  await content
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map((line) => '${++lineNumber}: $line')
      .where((line) => line.contains('Alice'))
      .skip(3)
      .take(5)
      .expand((line) => [line, line])
      .forEach(print);
}
