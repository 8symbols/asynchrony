// Неявная обертка в Future.value(), идет в микротаски.
Future<void> foo() async {
  print('foo');
}

Future<void> main() async {
  print('main start');
  Future.microtask(() => print('microtask 1'));
  Future.microtask(() => print('microtask 2'));
  Future(() => print('event 1'));
  Future(() => print('event 2'));

  await foo();

  print('main end');
}
