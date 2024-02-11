void main() {
  print('main start');

  final stream = Stream.periodic(const Duration(seconds: 1), (count) {
    if (count == 2) {
      throw Exception('Surprise');
    }
    return count;
  }).asBroadcastStream().handleError((e, s) => print('stream: $e'));

  final subscription1 = stream.listen(
    print,
    onError: (e, s) => print('subscription1 error: $e'),
  );

  final subscription2 = stream.listen(
    print,
    // onError: (e, s) => print('subscription2 error: $e'),
    // cancelOnError: true,
  );

  print('main end');
}
