import 'dart:collection';

import 'package:dart_extensions/dart_extensions.dart' show DEListieExt;

import 'package:nampack/reactive/class/rx_base.dart';

part 'rx_list_extensions.dart';

abstract class RxListBase<E> extends RxBase<List<E>> with ListMixin<E> {
  RxListBase(super._value);

  List<E> get _value => super.valueRaw;

  @override
  int get length => value.length;

  @override
  E operator [](int index) => value[index];

  @override
  void operator []=(int index, E value) {
    _value[index] = value;
    refresh();
  }

  @override
  set length(int newLength) {
    _value.length = newLength;
    refresh();
  }

  @override
  void add(E element) {
    _value.add(element);
    refresh();
  }

  @override
  void addAll(Iterable<E> iterable) {
    _value.addAll(iterable);
    refresh();
  }

  @override
  void insert(int index, E element) {
    _value.insert(index, element);
    refresh();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _value.insertAll(index, iterable);
    refresh();
  }

  @override
  bool remove(Object? element) {
    final removed = _value.remove(element);
    refresh();
    return removed;
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _value.removeWhere(test);
    refresh();
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _value.retainWhere(test);
    refresh();
  }

  @override
  Iterable<E> where(bool Function(E element) test) => value.where(test);

  @override
  Iterable<T> whereType<T>() => value.whereType<T>();

  @override
  void sort([int Function(E a, E b)? compare]) {
    _value.sort(compare);
    refresh();
  }
}
