void main() {
  uncompletedFuture();
}

// Выполняется синхронно
void uncompletedFuture() {
  print('uncompletedFuture start');

  late Future future;
  future = Future(() {
    print('future');

    Future.microtask(() => print('nested microtask'));
    Future(() => print('nested future'));
    future.then((_) => print('then'));

    return 42;
  });

  print('uncompletedFuture end');
}

// Идет в микротаски
void completedFuture() {
  print('completedFuture start');

  final future = Future(() {
    print('future');
    return 42;
  });

  future.then((value) {
    Future.microtask(() => print('nested microtask'));
    Future(() => print('nested future'));
    future.then((_) => print('then'));
  });

  print('completedFuture end');
}
