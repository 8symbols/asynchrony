import 'dart:async';

void main() async {
  print('main start');

  final controller = StreamController<int>();
  final sink = controller.sink;
  final stream = controller.stream;

  final subscription = stream.listen(print);

  sink.add(1);
  controller.add(2);
  sink.add(3);

  await subscription.cancel();
  await controller.close();

  print('main end');
}
