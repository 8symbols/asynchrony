import 'dart:async';

void main() {
  print('main start');

  final stream = Stream.periodic(Duration(seconds: 1), (computationCount) {
    return 'completed $computationCount times';
  }).asBroadcastStream(
      // onCancel: (subscription) {
      //   subscription.cancel();
      // },
      );

  final subscription1 = stream.listen(print);
  final subscription2 = stream.listen(print);

  Future.delayed(Duration(seconds: 3), () => subscription1.cancel());

  Future.delayed(Duration(seconds: 5), () => subscription2.cancel());

  print('main end');
}
