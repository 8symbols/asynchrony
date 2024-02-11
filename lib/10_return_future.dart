void main() async {
  print(await foo());
}

Future<int> bar() => Future.value(42);

Future<int> foo() async {
  try {
    return bar();
  } catch (exception) {
    print(exception);
    return -1;
  }
}
