Future<void> main() async {
  print('main start');

  try {
    print('value = ${await getValue()}');
  } catch (_) {
    print('can\'t get value');
  }

  print('computation = ${await compute()}');
  print('main end');
}

Future<int> getValue() {
  print('getValue start');
  return Future.value(42);
}

Future<int> compute() async {
  print('compute start');

  try {
    int value;

    try {
      value = await getValue();
    } catch (_) {
      value = -42;
    }

    return value * value;
  } catch (_) {
    return -1;
  }
}
