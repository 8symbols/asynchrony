import 'dart:async';

// Отличия: https://api.flutter.dev/flutter/dart-async/Stream-class.html

void main() {
  print('main start');
  // Подписки в стримах идут через микротаски
  Future(() => print('event'));

  final controller = StreamController<int>();
  final broadcastController = StreamController<int>.broadcast();

  for (var i = 0; i < 3; ++i) {
    // Только single subscription кеширует события до подписки
    controller.add(i);
    broadcastController.add(i);
  }

  final subscription = controller.stream.listen((number) {
    print('single: $number');
  });

  final broadcastSubscription = broadcastController.stream.listen((number) {
    print('broadcast: $number');
  });

  subscription.pause();
  broadcastSubscription.pause();

  for (var i = 3; i < 6; ++i) {
    // Оба кеширует события во время паузы.
    // Чтобы избежать лишнего кеширования, для broadcast лучше отменить подписку
    // и начать заново, если события во время паузы не важны.

    controller.add(i);
    broadcastController.add(i);
  }

  subscription.resume();
  broadcastSubscription.resume();

  Future.delayed(Duration(seconds: 1), () async {
    await broadcastSubscription.cancel();
    await subscription.cancel();
    await broadcastController.close();
    await controller.close();
  });

  print('main end');
}
