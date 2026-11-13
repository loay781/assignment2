import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../controllers/getx_counter_controller.dart';
import '../controllers/riverpod_counter_notifier.dart';
import '../models/counter_state.dart';

class CounterComparisonPage extends StatelessWidget {
  const CounterComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التكليف الأول — إدارة الحالة'),
          centerTitle: true,
          bottom: const TabBar(tabs: [Tab(text: 'GetX'), Tab(text: 'Riverpod 2.x')]),
        ),
        body: const TabBarView(children: [GetXCounterView(), RiverpodCounterView()]),
      ),
    );
  }
}

class GetXCounterView extends StatefulWidget {
  const GetXCounterView({super.key});
  @override State<GetXCounterView> createState() => _GetXCounterViewState();
}

class _GetXCounterViewState extends State<GetXCounterView> {
  late final GetXCounterController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(GetXCounterController(), tag: 'assignment_getx');
  }

  @override
  void dispose() {
    Get.delete<GetXCounterController>(tag: 'assignment_getx');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => CounterBody(
      framework: 'GetX',
      concept: 'GetxController + Rx + Obx',
      count: controller.count.value,
      isRunning: controller.isRunning.value,
      lifecycle: controller.lifecycle.value,
      onIncrement: controller.increment,
      onDecrement: controller.decrement,
      onReset: controller.reset,
      onToggle: controller.toggleTimer,
    ));
  }
}

class RiverpodCounterView extends ConsumerStatefulWidget {
  const RiverpodCounterView({super.key});
  @override ConsumerState<RiverpodCounterView> createState() => _RiverpodCounterViewState();
}

class _RiverpodCounterViewState extends ConsumerState<RiverpodCounterView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref.read(riverpodCounterProvider.notifier).onLifecycleChanged(state.name);
  }

  @override
  Widget build(BuildContext context) {
    return const RiverpodCounterContent();
  }
}

class RiverpodCounterContent extends ConsumerWidget {
  const RiverpodCounterContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(riverpodCounterProvider);
    final controller = ref.read(riverpodCounterProvider.notifier);
    return CounterBody(
      framework: 'Modern Riverpod 2.x',
      concept: 'Notifier + ConsumerWidget/Consumer',
      count: state.count,
      isRunning: state.isRunning,
      lifecycle: state.lifecycle,
      onIncrement: controller.increment,
      onDecrement: controller.decrement,
      onReset: controller.reset,
      onToggle: controller.toggleTimer,
    );
  }
}

class CounterBody extends StatelessWidget {
  final String framework;
  final String concept;
  final int count;
  final bool isRunning;
  final String lifecycle;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final VoidCallback onToggle;

  const CounterBody({super.key, required this.framework, required this.concept, required this.count, required this.isRunning, required this.lifecycle, required this.onIncrement, required this.onDecrement, required this.onReset, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final color = framework == 'GetX' ? Colors.indigo : Colors.teal;
    return ListView(padding: const EdgeInsets.all(20), children: [
      Card(color: color.withOpacity(.1), elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(framework, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 5), Text(concept),
        const SizedBox(height: 12), Row(children: [Icon(Icons.circle, size: 12, color: isRunning ? Colors.green : Colors.grey), const SizedBox(width: 6), Text(isRunning ? 'المؤقت يعمل' : 'المؤقت متوقف'), const Spacer(), Text('Lifecycle: $lifecycle', style: const TextStyle(fontSize: 12))]),
      ]))),
      const SizedBox(height: 28),
      Center(child: Text('$count', style: TextStyle(fontSize: 88, fontWeight: FontWeight.w800, color: color))),
      const SizedBox(height: 24),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton.filled(onPressed: onDecrement, icon: const Icon(Icons.remove), tooltip: 'إنقاص'),
        const SizedBox(width: 22),
        IconButton.filled(onPressed: onIncrement, icon: const Icon(Icons.add), tooltip: 'زيادة'),
      ]),
      const SizedBox(height: 20),
      FilledButton.icon(onPressed: onToggle, icon: Icon(isRunning ? Icons.pause : Icons.play_arrow), label: Text(isRunning ? 'إيقاف المؤقت' : 'تشغيل المؤقت')),
      const SizedBox(height: 10),
      OutlinedButton.icon(onPressed: onReset, icon: const Icon(Icons.restart_alt), label: const Text('إعادة تعيين العداد')),
      const SizedBox(height: 24),
      const Text('الاختبار المطلوب: شغّل المؤقت، اخرج من التطبيق أو صغّره، ثم عُد إليه. ستلاحظ تسجيل حالة دورة الحياة وإيقاف المؤقت عند مغادرة التطبيق.', style: TextStyle(height: 1.5)),
    ]);
  }
}
