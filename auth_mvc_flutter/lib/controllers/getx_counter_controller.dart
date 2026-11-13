import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class GetXCounterController extends GetxController with WidgetsBindingObserver {
  final count = 0.obs;
  final isRunning = false.obs;
  final lifecycle = 'resumed'.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  void increment() => count.value++;
  void decrement() => count.value--;
  void reset() => count.value = 0;

  void toggleTimer() {
    if (isRunning.value) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    isRunning.value = true;
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) => increment());
  }

  void _stopTimer() {
    isRunning.value = false;
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    lifecycle.value = state.name;
    if (state != AppLifecycleState.resumed && isRunning.value) _stopTimer();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.onClose();
  }
}
