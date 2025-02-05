import 'dart:async';

class AsyncOperation {
  final _completer = Completer<int>();

  Future<int> waitOperation() {
    return _completer.future;
  }

  void doOperation() {
    try {
      // ...
      _finishOperation(42);
    } catch (error) {
      _errorHappened(error);
    }
  }

  void _finishOperation(int result) {
    _completer.complete(result);
  }

  void _errorHappened(error) {
    _completer.completeError(error);
  }
}
