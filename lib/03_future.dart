import 'dart:async';

void main() {
  print('main start');

  final future = Future.delayed(Duration(seconds: 2), () {
    print('time has come');
    return 42;
  });

  future.then((value) => print('answer is $value'));

  print('main end');
  // future.cancel(); // Отменить невозможно
}
