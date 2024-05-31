import 'package:flutter/material.dart';

import 'package:nampack/reactive/class/rx_base.dart';

class ObxO<T> extends StatelessWidget {
  final RxBase<T> rx;
  final Widget Function(T value) builder;

  const ObxO({super.key, required this.rx, required this.builder});

  @override
  StatelessElement createElement() => _RxOListenerBuilder(rx, this);

  @override
  Widget build(BuildContext context) => builder(rx.value);
}

class ObxOContext<T> extends StatelessWidget {
  final RxBase<T> rx;
  final Widget Function(BuildContext context, T value) builder;

  const ObxOContext({super.key, required this.rx, required this.builder});

  @override
  StatelessElement createElement() => _RxOListenerBuilder(rx, this);

  @override
  Widget build(BuildContext context) => builder(context, rx.value);
}

class _RxOListenerBuilder<T> extends StatelessElement {
  _RxOListenerBuilder(this.rx, super.widget);

  final RxBase<T> rx;

  void _updateWidget() {
    if (mounted) {
      markNeedsBuild();
    }
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    rx.addListener(_updateWidget);
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    super.unmount();
    rx.removeListener(_updateWidget);
  }
}
