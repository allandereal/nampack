part of 'rx_map_base.dart';

extension RxMapExtensions<K, V> on RxMapBase<K, V> {
  void execute(void Function(Map<K, V> value) fn) {
    fn(_value);
    refresh();
  }

  void assign(K key, V value) {
    _value.assign(key, value);
    refresh();
  }

  void assignAll(Map<K, V> other) {
    _value.assignAll(other);
    refresh();
  }

  void assignAllEntries(Iterable<MapEntry<K, V>> newEntries) {
    _value.assignAllEntries(newEntries);
    refresh();
  }

  void sort([int Function(MapEntry<K, V> a, MapEntry<K, V> b)? compare]) {
    _value.sort(compare);
    refresh();
  }

  void sortBy(Comparable<dynamic> Function(MapEntry<K, V> e) key) {
    _value.sortBy(key);
    refresh();
  }

  void sortByReverse(Comparable<dynamic> Function(MapEntry<K, V> e) key) {
    _value.sortByReverse(key);
    refresh();
  }

  List<MapEntry<K, V>> sorted([int Function(MapEntry<K, V> a, MapEntry<K, V> b)? compare]) {
    return _value.sorted(compare);
  }

  List<MapEntry<K, V>> sortedBy(Comparable<dynamic> Function(MapEntry<K, V> e) key) {
    return _value.sortedBy(key);
  }

  List<MapEntry<K, V>> sortedByReverse(Comparable<dynamic> Function(MapEntry<K, V> e) key) {
    return _value.sortedByReverse(key);
  }

  void optimizedAdd(Iterable<MapEntry<K, V>> entries, int max) {
    _value.optimizedAdd(entries, max);
    refresh();
  }

  void reAssign(K oldKey, K newKey, {V? newValue}) {
    _value.reAssign(oldKey, newKey, newValue: newValue);
    refresh();
  }
}

extension RxMapUtilsNullable<K, V> on RxMapBase<K, V?> {
  void reAssignNullable(K oldKey, K newKey, {V? newValue}) {
    _value.reAssignNullable(oldKey, newKey, newValue: newValue);
    refresh();
  }
}

extension RxMapExtNull<K, E> on RxMapBase<K, List<E>?> {
  void addForce(K key, E item) {
    _value.addForce(key, item);
    refresh();
  }

  void insertForce(int index, K key, E item) {
    _value.insertForce(index, key, item);
    refresh();
  }

  void addNoDuplicatesForce(K key, E item, {bool preventDuplicates = true}) {
    _value.addNoDuplicatesForce(key, item, preventDuplicates: preventDuplicates);
    refresh();
  }

  void addAllNoDuplicatesForce(K key, Iterable<E> items, {bool preventDuplicates = true}) {
    _value.addAllNoDuplicatesForce(key, items, preventDuplicates: preventDuplicates);
    refresh();
  }
}
