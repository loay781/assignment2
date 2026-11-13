class CounterState {
  final int count;
  final bool isRunning;
  final String lifecycle;

  const CounterState({this.count = 0, this.isRunning = false, this.lifecycle = 'resumed'});

  CounterState copyWith({int? count, bool? isRunning, String? lifecycle}) {
    return CounterState(
      count: count ?? this.count,
      isRunning: isRunning ?? this.isRunning,
      lifecycle: lifecycle ?? this.lifecycle,
    );
  }
}
