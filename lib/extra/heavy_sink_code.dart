void main() {
  heavyComputation();
}

void heavyComputation() {
  for (var i = 0; i < 1000000; ++i) {
    for (var j = 0; j < 1000000; ++j) {
      // ...
    }
  }
}

Future<void> heavyComputationWithGaps() async {
  const requiredFps = 60;
  const timePerFrameMs = 1000 / requiredFps;

  final stopwatch = Stopwatch()..start();

  for (var i = 0; i < 1000000; ++i) {
    if (stopwatch.elapsed.inMilliseconds >= timePerFrameMs) {
      await Future.delayed(Duration.zero);
      stopwatch.reset();
    }

    for (var j = 0; j < 1000000; ++j) {
      // ...
    }
  }
}
