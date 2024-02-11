Stream<String> lines(Stream<String> source) async* {
  var partial = '';

  await for (final chunk in source) {
    var lines = chunk.split('\n');
    lines[0] = partial + lines[0];
    partial = lines.removeLast();
    for (final line in lines) {
      yield line;
    }
  }

  if (partial.isNotEmpty) {
    yield partial;
  }
}

Stream<int> timedCounter(Duration interval, [int? maxCount]) async* {
  var i = 0;

  while (true) {
    await Future.delayed(interval);

    print('timedCounter: $i');
    yield i;
    ++i;

    if (i == maxCount) {
      break;
    }
  }
}

Stream<int> defaultTimedCounter() async* {
  yield* timedCounter(Duration(seconds: 1));

  // Это почти то же самое, что
  // await for (var value in someStream) {
  //   yield value;
  // }
  // , но yield* прокидывает ошибки и не прерывается на первой ошибке.
}

void main() async {
  final stream = timedCounter(Duration(milliseconds: 800), 10);
  final subscription = stream.listen(
    print,
    onDone: () => print('done'),
    onError: (e) => print('error: $e'),
    cancelOnError: false,
  );

  await Future.delayed(Duration(seconds: 3));
  subscription.pause();
  await Future.delayed(Duration(seconds: 3));
  subscription.resume();
}
