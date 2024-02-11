import 'dart:async';

void main() {
  print('main start');

  final timer = Timer(Duration(seconds: 2), () {
    print('time has come');
  });

  print('main end');
  // timer.cancel();
}
