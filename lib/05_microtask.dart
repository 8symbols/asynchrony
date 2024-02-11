import 'dart:async';

void main() {
  print('main start');

  final timer = Timer.run(() => print('Timer.run'));
  final future1 = Future(() => print('Future'));

  scheduleMicrotask(() => print('scheduleMicrotask'));
  final future2 = Future.microtask(() => print('Future.microtask'));

  print('main end');
}
