// Выполнение в порядке типа dfs.
//
// Не задокументировано, может поменяться в будущих версиях.
void main() {
  print('main start');

  final future1 = Future(() => print('future1'));

  final future11 = future1.then((_) => print('future11'));

  final future111 = future11.then((_) => print('future111'));

  final future12 = future1.then((_) => print('future12'));

  final future121 = future12.then((_) => print('future121'));

  final future112 = future11.then((_) => print('future112'));

  print('main end');
}
