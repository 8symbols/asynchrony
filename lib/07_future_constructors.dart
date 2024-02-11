void main() {
  unnamed();
}

// event
void unnamed() {
  _testFutureOrder(() => Future(() {}).then((_) => print('unnamed')));
}

// event
void delayed() {
  _testFutureOrder(
    () => Future.delayed(Duration.zero).then((_) => print('delayed')),
  );
}

// microtask
void value() {
  _testFutureOrder(() => Future.value(42).then((_) => print('value')));
}

// зависит от вложенной future
void valueFuture() {
  _testFutureOrder(
    () => Future.value(
      Future(() => print('future')),
    ).then((_) => print('value')),
  );
}

// microtask
void sync() {
  _testFutureOrder(() => Future.sync(() => 42).then((_) => print('sync')));
}

// зависит от вложенной future
void syncFuture() {
  _testFutureOrder(
    () => Future.sync(
      () => Future(() => print('future')),
    ).then((_) => print('sync')),
  );
}

// microtask
void error() {
  _testFutureOrder(() => Future.error(42).then((_) => print('error')));
}

// В промышленном коде опираться на предположение о порядке выполнения
// операция в event loop - плохо, потому что это детали реализации,
// которые в будущих релизах могут измениться.
void _testFutureOrder<T>(Future<T> Function() createFuture) {
  Future.microtask(() => print('microtask before'));
  Future(() => print('event before'));

  createFuture();

  Future.microtask(() => print('microtask after'));
  Future(() => print('event after'));
}
