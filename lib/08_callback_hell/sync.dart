void main() {
  print('main start');

  try {
    print('value = ${getValue()}');
  } catch (_) {
    print('can\'t get value');
  }

  print('computation = ${compute()}');
  print('main end');
}

int getValue() {
  print('getValue start');
  return 42;
}

int compute() {
  print('compute start');

  try {
    int value;

    try {
      value = getValue();
    } catch (_) {
      value = -42;
    }

    return value * value;
  } catch (_) {
    return -1;
  }
}
