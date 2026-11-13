import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/counter_state.dart';

final riverpodCounterProvider = NotifierProvider<RiverpodCounterNotifier, CounterState>(RiverpodCounterNotifier.new);

class RiverpodCounterNotifier extends Notifier<CounterState> {
  Timer? _timer;

  @override
  CounterState build() {
    ref.onDispose(() => _timer?.cancel());
    return const CounterState();
  }

  void increment() => state = state.copyWith(count: state.count + 1);
  void decrement() => state = state.copyWith(count: state.count - 1);
  void reset() => state = state.copyWith(count: 0);

  void toggleTimer() {
    if (state.isRunning) {
      _stopTimer();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => increment());
      state = state.copyWith(isRunning: true);
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  void onLifecycleChanged(String lifecycle) {
    state = state.copyWith(lifecycle: lifecycle);
    if (lifecycle != 'resumed' && state.isRunning) _stopTimer();
  }
}
