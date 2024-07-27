import 'dart:async';
import 'package:flutter/widgets.dart';

enum SchedulerTrigger {
  appear,
  mounted,
}

class SchedulerOptions {
  final bool autoStart;
  final SchedulerTrigger type;
  final SchedulerTrigger? trigger;

  SchedulerOptions({
    this.autoStart = true,
    this.type = SchedulerTrigger.appear,
    this.trigger,
  });
}

class Scheduler {
  final Function() fn;
  final Duration interval;
  final SchedulerOptions options;
  Timer? _timer;

  Scheduler(this.fn, this.interval, [SchedulerOptions? options])
      : options = options ?? SchedulerOptions();

  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(interval, (_) {
      fn();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
  }
}

mixin SchedulerMixin<T extends StatefulWidget> on State<T> {
  final List<Scheduler> _schedulers = [];

  Scheduler useScheduler(Function() fn, Duration interval,
      [SchedulerOptions? options]) {
    final scheduler = Scheduler(fn, interval, options);
    _schedulers.add(scheduler);

    if (scheduler.options.autoStart) {
      if (scheduler.options.type == SchedulerTrigger.appear) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scheduler.start();
        });
      } else {
        scheduler.start();
      }
    }

    if (scheduler.options.trigger == SchedulerTrigger.appear) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fn();
      });
    } else if (scheduler.options.trigger == SchedulerTrigger.mounted) {
      fn();
    }

    return scheduler;
  }

  @override
  void dispose() {
    for (var scheduler in _schedulers) {
      scheduler.dispose();
    }
    super.dispose();
  }
}
