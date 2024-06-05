import 'package:flutter/foundation.dart';

/// Base Implementation for Rx* instances that extends [RxBaseCore]
/// providing a setter and a set function.
///
/// {@macro nampack.reactive.rx_base}
abstract class RxBase<T> extends RxBaseCore<T> {
  RxBase(super.value);

  /// Sets a value and notifies listener. has no effect if the value is the same.
  set value(T other) {
    if (_value == other) return;
    _value = other;
    refresh();
  }

  /// Sets a value without notifying listeners
  void set(T val) => _value = val;
}

mixin RxExecuterMixin<T> on RxBase<T> {
  /// Executes a callback then calls [refresh]. useful for batch modifications in a loop, etc.
  void execute(void Function(T value) fn) {
    fn(_value);
    refresh();
  }
}

/// Core Implementation for Rx* instances. this class doesn't provide a way to update the value.
/// {@template nampack.reactive.rx_base}
/// One may expose as [RxBaseCore] getter to prevent modifications.
/// {@endtemplate}
abstract class RxBaseCore<T> implements Listenable {
  RxBaseCore(this._value);

  T _value;

  /// Raw value.
  @nonVirtual
  T get value => _value;

  /// A getter that automatically add the builder callback as a listener,
  /// meant to be used with [Obx].
  T get valueR => _value;

  /// Notifies current listeners.
  void refresh();

  /// Disposes resources, by default this clears the notifiers and nullify updater manager class
  /// calling other methods on the object after [close] will throw [RxDisposedException].
  void close();

  /// Re-initializes the listener manager class.
  /// any previous listeners are already lost and can no longer be notified.
  void reInit();

  @override
  String toString() => _value.toString();
}
