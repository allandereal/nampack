import 'dart:collection';

import 'package:dart_extensions/dart_extensions.dart' show NPMapUtils, NPMapUtilsNullable, NPMapExtNull;

import 'package:nampack/reactive/class/rx_base.dart';

part 'rx_map_extensions.dart';

abstract class RxMapBase<K, V> extends RxBase<Map<K, V>> with MapMixin<K, V> {
  RxMapBase(super._value);

  Map<K, V> get _value => super.valueRaw;

  @override
  int get length => value.length;

  @override
  V? operator [](Object? key) => value[key];

  @override
  void operator []=(K key, V value) {
    _value[key] = value;
    refresh();
  }

  @override
  Iterable<K> get keys => value.keys;

  @override
  void clear() {
    _value.clear();
    refresh();
  }

  @override
  V? remove(Object? key) {
    final removed = _value.remove(key);
    refresh();
    return removed;
  }
}
