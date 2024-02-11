import 'dart:async';

void main() {
  print('main start');

  final timer = Timer.periodic(Duration(seconds: 2), (timer) {
    print('time has come ${timer.tick} time');
    // if (timer.tick == 3) {
    //   timer.cancel();
    // }
  });

  print('main end');
}
