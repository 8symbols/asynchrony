import 'package:async/async.dart';

void main() {
  cancelCompletion();
}

void tryCancelFutureCompletion() {
  final future = Future.delayed(Duration(seconds: 1), () => print('future'));

  final cancelableOperation = CancelableOperation.fromFuture(future);

  cancelableOperation.value.then((_) => print('value'));

  // cancelableOperation.cancel();
}

void cancelCompletion() {
  var isCancelled = false;

  final future = Future.delayed(Duration(seconds: 1), () {
    if (isCancelled) {
      return;
    }

    print('future');
  });

  final cancelableOperation = CancelableOperation.fromFuture(
    future,
    onCancel: () => isCancelled = true,
  );

  cancelableOperation.value.then((_) => print('value'));

  // cancelableOperation.cancel();
}
