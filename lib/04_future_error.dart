import 'dart:async';

void main() {
  print('main start');

  final future = Future.delayed(Duration(seconds: 2), () {
    print('time has come');
    throw Exception('surprise');
    return 42;
  });

  future
      .then((value) => print('answer is $value'))
      .onError((error, stackTrace) => print(error))
      .then((value) => print('second then'))
      .onError((error, stackTrace) => print(error));

  print('main end');
}
