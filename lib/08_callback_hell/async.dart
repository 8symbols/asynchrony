void main() {
  print('main start');

  getValue()
      .then((value) => print('value = $value'))
      .onError((_, __) => print('can\'t get value'))
      .then(
    (_) {
      compute().then((result) {
        print('computation = $result');
        print('main end');
      });
    },
  );
}

Future<int> getValue() {
  print('getValue start');
  return Future.value(42);
}

Future<int> compute() {
  print('compute start');

  return getValue()
      .onError((_, __) => -42)
      .then((value) => value * value)
      .onError((_, __) => -1);
}
