import 'dart:async';

abstract class Base<T> {
  FutureOr<T> someMethod();
}

abstract class AsyncChild<T> extends Base<T> {
  @override
  Future<T> someMethod();
}

abstract class SyncChild<T> extends Base<T> {
  @override
  T someMethod();
}
