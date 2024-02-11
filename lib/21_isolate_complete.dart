import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

void main() async {
  final worker = await Worker.spawn();
  print(await worker.parseJson('{"key":"value"}'));
  print(await worker.parseJson('"banana"'));
  print(await worker.parseJson('[true, false, null, 1, "string"]'));
  print(await Future.wait([
    worker.parseJson('"yes"'),
    worker.parseJson('"no"'),
  ]));
  worker.close();
}

class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  static Future<Worker> spawn() async {
    final initialReceivePort = RawReceivePort();
    final connectionCompleter = Completer<(ReceivePort, SendPort)>.sync();

    initialReceivePort.handler = (initialMessage) {
      final sendPort = initialMessage as SendPort;
      connectionCompleter.complete((
        ReceivePort.fromRawReceivePort(initialReceivePort),
        sendPort,
      ));
    };

    try {
      await Isolate.spawn(_startRemoteIsolate, initialReceivePort.sendPort);
    } on Object {
      initialReceivePort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connectionCompleter.future;

    return Worker._(receivePort, sendPort);
  }

  Worker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  Future<Object?> parseJson(String message) async {
    if (_closed) {
      throw StateError('Closed');
    }
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, message));
    return await completer.future;
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response);
    }

    if (_closed && _activeRequests.isEmpty) {
      _responses.close(); // А если не закрывать?
    }
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }
      final (int id, String jsonText) = message as (int, String);
      try {
        final jsonData = jsonDecode(jsonText);
        sendPort.send((id, jsonData));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) {
        _responses.close();
      }
      print('--- port closed --- ');
    }
  }
}
