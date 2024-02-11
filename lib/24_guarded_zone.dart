import 'dart:async';

void main() async {
  await unhandledErrors();
}

Future<void> throwErrors() async {
  try {
    final futures = [
      for (var i = 1; i < 4; ++i)
        Future.delayed(
          Duration(seconds: i),
          () => throw Exception('exception $i'),
        ),
    ];

    for (final future in futures) {
      await future;
    }
  } catch (e, s) {
    print('throwErrors: catch $e');
  }
}

Future<void> unhandledErrors() => throwErrors();

Future<void> handledErrors() async {
  await runZonedGuarded(
    throwErrors,
    (error, stack) {
      print('runZonedGuarded: catch $error');
    },
  );
}
