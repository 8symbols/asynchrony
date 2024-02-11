void main() async {
  await wait();
  await Future.delayed(Duration(seconds: 5));
}

Future<void> wait() async {
  try {
    final futures = [
      for (var i = 1; i < 4; ++i)
        Future.delayed(
          Duration(seconds: i),
          () => throw Exception('exception $i'),
        ),
    ];

    await Future.wait(futures);
  } catch (e, s) {
    print('throwErrors: catch $e');
  }
}

Future<void> any() async {
  try {
    final futures = [
      for (var i = 1; i < 4; ++i)
        Future.delayed(
          Duration(seconds: i),
          () => throw Exception('exception $i'),
        ),
    ];

    await Future.any(futures);
  } catch (e, s) {
    print('throwErrors: catch $e');
  }
}
