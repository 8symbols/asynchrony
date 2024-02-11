import 'dart:isolate';

void main() async {
  // ReceivePort();
  final isolate = await Isolate.spawn(
    (message) {
      for (var i = 0; i < 1 << 62; ++i) {
        if (i % 100000 == 0) {
          print(i);
        }
      }
    },
    'initial message',
  );
}
