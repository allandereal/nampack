import 'package:flutter/foundation.dart';

abstract class RxBase<T> implements Listenable {
  RxBase(this._value);

  T _value;

  @nonVirtual
  T get value => _value;

  T get valueR => _value;

  set value(T other) {
    if (_value == other) return;
    _value = other;
    refresh();
  }

  void refresh();
  void close();

  @override
  String toString() => _value.toString();
}
