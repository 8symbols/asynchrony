import 'dart:collection';

final microtaskQueue = Queue<Code>();

final eventQueue = Queue<Code>();

void eventLoop() {
  while (microtaskQueue.isNotEmpty ||
      eventQueue.isNotEmpty ||
      hasExternalCodeSources()) {
    if (microtaskQueue.isNotEmpty) {
      final microtask = microtaskQueue.removeFirst();
      execute(microtask);
      continue;
    }

    if (eventQueue.isNotEmpty) {
      final event = eventQueue.removeFirst();
      execute(event);
    }
  }
}

abstract class Code {}

void execute(Code code) {
  throw UnimplementedError();
}

bool hasExternalCodeSources() {
  // - scheduled timers
  // - outstanding I/O operations
  // - open receive ports
  throw UnimplementedError();
}
