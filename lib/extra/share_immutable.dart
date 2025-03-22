import 'dart:async';
import 'dart:isolate';

void main() {
  immutable();
}

Future<void> mutable() async {
  final worker = Worker<List<int>>();
  await worker.spawn();

  final list = List.filled(10000000, 0);

  worker.sendData(list);
  await Completer().future;
}

Future<void> immutable() async {
  final worker = Worker<String>();
  await worker.spawn();

  final string = 'aaaaaaaaaa' * 10000000;

  worker.sendData(string);
  await Completer().future;
}

class Worker<T> {
  late SendPort _sendPort;
  final Completer<void> _isolateReady = Completer.sync();

  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
    }
  }

  Future<void> sendData(T data) async {
    await _isolateReady.future;
    _sendPort.send(data);
  }
}

Object? data;

void _startRemoteIsolate(SendPort port) {
  final receivePort = ReceivePort();
  port.send(receivePort.sendPort);
  receivePort.listen((message) {
    data = message;
  });
}
