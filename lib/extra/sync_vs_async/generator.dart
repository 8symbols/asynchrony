import 'dart:io';

enum _Mode {
  sync,
  async,
  asyncAwait,
}

Future<void> main() async {
  const depth = 2000;
  for (final mode in _Mode.values) {
    _generate(mode: mode, depth: depth);
  }
}

Future<void> _generate({required _Mode mode, required int depth}) async {
  final filename = switch (mode) {
    _Mode.sync => 'sync.dart',
    _Mode.async => 'async.dart',
    _Mode.asyncAwait => 'async_await.dart',
  };

  final file = await File(filename).create();
  final fileSink = file.openWrite();

  fileSink.write('''
Future<void> main() async {
  Future.microtask(() => print('microtask 1'));
  Future.microtask(() => print('microtask 2'));
  Future(() => print('event 1'));
  Future(() => print('event 2'));
  final stopwatch = Stopwatch()..start();
  print(await function0());
  print(stopwatch.elapsed);
}
''');

  for (var i = 0; i < depth - 1; ++i) {
    final function = switch (mode) {
      _Mode.sync => '''
Future<String> function$i() {
  return function${i + 1}();
}
''',
      _Mode.async => '''
Future<String> function$i() async {
  return function${i + 1}();
}
''',
      _Mode.asyncAwait => '''
Future<String> function$i() async {
  return await function${i + 1}();
}
''',
    };

    fileSink.write('\n$function');
  }

  fileSink.write('''

Future<String> function${depth - 1}() {
  return Future.value('result');
}
''');

  await fileSink.flush();
  await fileSink.close();
}
