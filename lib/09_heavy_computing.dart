import 'dart:async';

void compute() {
  for (var i = 0; i < 1 << 62; ++i) {}
}

void main() async {
  Timer.periodic(Duration(seconds: 1), (timer) {
    print('timer: ${timer.tick}');
  });

  await Future.delayed(Duration(seconds: 2));
  compute();
}
