import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('alice.txt');

  // await file.readAsString();
  // file.readAsStringSync();

  Stream<List<int>> content = file.openRead();

  var lineNumber = 0;
  await content
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map((line) => '${++lineNumber}: $line')
      .where((line) => line.contains('Alice'))
      .skip(3)
      .take(5)
      .transform(DuplicateTransformer())
      .forEach(print);
}

class DuplicateTransformer<T> extends StreamTransformerBase<T, T> {
  late final _controller = StreamController<T>(
    onListen: _onListen,
    onCancel: _onCancel,
    onPause: () => _subscription?.pause(),
    onResume: () => _subscription?.resume(),
  );

  StreamSubscription<T>? _subscription;

  late Stream<T> _stream;

  @override
  Stream<T> bind(Stream<T> stream) {
    _stream = stream;
    return _controller.stream;
  }

  void _onListen() {
    _subscription = _stream.listen(
      _onData,
      onError: _controller.addError,
      onDone: _controller.close,
    );
  }

  void _onCancel() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _onData(T data) {
    _controller.add(data);
    _controller.add(data);
  }
}
