import 'dart:async';

// Синхронный контроллер, особенно broadcast, ломает API работы стримов.
// Не используйте его никогда. Здесь он представлен исключительно в
// ознакомительных целях.
//
// Что может сломаться:
// https://api.dart.dev/stable/3.2.6/dart-async/SynchronousStreamController-class.html
//
// Почему это существует:
// Synchronous controllers exist as a primitive to allow people to write other
// streams manipulation libraries without introducing extra delays. You should
// rarely be using a stream controller at all, preferring to use an async*
// method to create the stream.
//
// Аналогично с Completer.sync().
void main() async {
  final controller = StreamController<int>();
  final syncController = StreamController<int>(sync: true);

  controller.stream.listen((event) => print('controller: $event'));
  syncController.stream.listen((event) => print('syncController: $event'));

  print('Step 1');
  controller.add(37);

  print('Step 2');
  syncController.add(42);

  print('Step 3');
  await Future.delayed(Duration.zero);

  print('Step 4');
}
