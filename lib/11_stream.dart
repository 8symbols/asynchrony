import 'dart:async';

void main() {
  print('main start');

  final stream = Stream.periodic(Duration(seconds: 1), (computationCount) {
    return 'completed $computationCount times';
  });

  // final subscription = stream.listen(print);
  // // // subscription.cancel();
  // // final subscription2 = stream.listen(print);
  //
  // Future.delayed(Duration(seconds: 3), () => subscription.cancel());

  print('main end');
}
