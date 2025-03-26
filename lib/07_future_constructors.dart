// В промышленном коде опираться на предположение о порядке выполнения
// операция в event loop - плохо, потому что это детали реализации,
// которые в будущих релизах могут измениться.
Future<void> main() async {
  final callbacks = <Future<void> Function()>[
    unnamed,
    delayed,
    value,
    valueFuture,
    sync,
    syncFuture,
    error,
  ];

  for (final callback in callbacks) {
    await callback();
    await Future.delayed(Duration.zero);
  }
}

Future<void> unnamed() => _testFutureOrder(
      name: 'unnamed',
      createFuture: () => Future(() {}),
    );

Future<void> delayed() => _testFutureOrder(
      name: 'delayed',
      createFuture: () => Future.delayed(Duration.zero),
    );

Future<void> value() => _testFutureOrder(
      name: 'value',
      createFuture: () => Future.value(42),
    );

Future<void> valueFuture() => _testFutureOrder(
      name: 'value with future',
      createFuture: () => Future.value(Future(() {})),
    );

Future<void> sync() => _testFutureOrder(
      name: 'sync',
      createFuture: () => Future.sync(() => 42),
    );

Future<void> syncFuture() => _testFutureOrder(
      name: 'sync with future',
      createFuture: () => Future.sync(
        () => Future(() {}),
      ),
    );

Future<void> error() => _testFutureOrder(
      name: 'error',
      createFuture: () => Future.error(42),
    );

Future<void> _testFutureOrder<T>({
  required String name,
  required Future<T> Function() createFuture,
}) async {
  const results = ['синхронно', 'microtask', 'event'];
  var index = 0;

  Future.microtask(() => ++index);
  Future(() => ++index);

  try {
    await createFuture();
  } catch (_) {}

  final result = results[index];
  print('$name: $result');
}
