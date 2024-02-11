import 'dart:async';

// Плохая реализация: стартует до первой подписки, не реагирует на паузу.
Stream<int> badTimedCounter(Duration interval, [int? maxCount]) {
  final controller = StreamController<int>();

  int counter = 0;

  Timer.periodic(interval, (timer) {
    counter++;
    controller.add(counter);
    if (maxCount != null && counter == maxCount) {
      timer.cancel();
      controller.close();
    }
  });

  return controller.stream;
}

Stream<int> goodTimedCounter(Duration interval, [int? maxCount]) {
  late StreamController<int> controller;
  Timer? timer;
  int counter = 0;

  void tick() {
    ++counter;
    controller.add(counter);
    if (counter == maxCount) {
      timer?.cancel();
      controller.close();
    }
  }

  void startTimer() {
    timer = Timer.periodic(interval, (_) => tick());
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  controller = StreamController<int>(
    onListen: startTimer,
    onPause: stopTimer,
    onResume: startTimer,
    onCancel: stopTimer,
  );

  // controller = StreamController<int>.broadcast(
  //   onListen: startTimer,
  //   // onPause: stopTimer,
  //   // onResume: startTimer,
  //   onCancel: stopTimer,
  // );

  return controller.stream;
}
