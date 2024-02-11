import 'dart:async';

class AsyncOperation {
  final _completer = Completer<int>();

  Future<int> doOperation() {
    _startOperation();
    return _completer.future;
  }

  void _startOperation() {
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
