part of 'rx_list_base.dart';

extension RxListExtensions<E, Id> on RxListBase<E> {
  void execute(void Function(List<E> value) fn) {
    fn(_value);
    refresh();
  }

  void assign(E element) {
    _value.assign(element);
    refresh();
  }

  void assignAll(Iterable<E> iterable) {
    _value.assignAll(iterable);
    refresh();
  }

  void loop(void Function(E item) action) {
    _value.loop(action);
    refresh();
  }

  void loopAdv(void Function(E item, int index) action) {
    _value.loopAdv(action);
    refresh();
  }

  void reverseLoop(void Function(E item) action) {
    _value.reverseLoop(action);
    refresh();
  }

  void reverseLoopAdv(void Function(E e, int index) function) {
    _value.reverseLoopAdv(function);
    refresh();
  }

  /// returns true if [item] was removed.
  bool addOrRemove(E item) {
    final removed = _value.addOrRemove(item);
    refresh();
    return removed;
  }

  void replaceWhere(bool Function(E e) test, E Function(E old) newElement, {void Function()? onMatch}) {
    _value.replaceWhere(test, newElement, onMatch: onMatch);
    refresh();
  }

  void replaceSingleWhere(bool Function(E e) test, E Function(E old) newElement, {void Function()? onMatch}) {
    _value.replaceSingleWhere(test, newElement, onMatch: onMatch);
    refresh();
  }

  void replaceItems(E oldElement, E newElement, {void Function()? onMatch}) {
    _value.replaceItems(oldElement, newElement, onMatch: onMatch);
    refresh();
  }

  void replaceItem(E oldElement, E newElement, {void Function()? onMatch}) {
    _value.replaceItem(oldElement, newElement, onMatch: onMatch);
    refresh();
  }

  E? getEnum(String? string) => _value.getEnum(string);
  E? getEnumLoose(String? string) => _value.getEnumLoose(string);

  void insertSafe(int index, E object) {
    _value.insertSafe(index, object);
    refresh();
  }

  void insertAllSafe(int index, Iterable<E> objects) {
    _value.insertAllSafe(index, objects);
    refresh();
  }

  void sortBy(Comparable Function(E e) key) {
    _value.sortBy(key);
    refresh();
  }

  void sortByReverse(Comparable Function(E e) key) {
    _value.sortByReverse(key);
    refresh();
  }

  void sortByAlt(Comparable Function(E e) key, Comparable Function(E e) alternative) {
    _value.sortByAlt(key, alternative);
    refresh();
  }

  void sortByReverseAlt(Comparable Function(E e) key, Comparable Function(E e) alternative) {
    _value.sortByReverseAlt(key, alternative);
    refresh();
  }

  void sortByAlts(List<Comparable Function(E e)> alternatives) {
    _value.sortByAlts(alternatives);
    refresh();
  }

  void sortByReverseAlts(List<Comparable Function(E e)> alternatives) {
    _value.sortByReverseAlts(alternatives);
    refresh();
  }

  int removeWhereWithDifference(bool Function(E element) test) {
    final res = _value.removeWhereWithDifference(test);
    refresh();
    return res;
  }

  bool isEqualTo(List<E> q2) {
    return value.isEqualTo(q2);
  }

  /// returns number of items removed.
  int removeDuplicates([Id Function(E element)? id]) {
    final res = _value.removeDuplicates(id);
    refresh();
    return res;
  }

  List<E> uniqued([Id Function(E element)? id]) {
    return _value.uniqued(id);
  }

  List<T> mapped<T>(T Function(E e) toElement) {
    return _value.mapped(toElement);
  }

  List<T> mappedUniqued<T>(T Function(E e) toElement) {
    return _value.mappedUniqued(toElement);
  }

  List<T> mappedUniquedList<T>(Iterable<T> Function(E e) toElements) {
    return _value.mappedUniquedList(toElements);
  }

  void addNoDuplicates(E item, {bool preventDuplicates = true}) {
    _value.addNoDuplicates(item, preventDuplicates: preventDuplicates);
    refresh();
  }

  void addAllNoDuplicates(Iterable<E> item, {bool preventDuplicates = true}) {
    _value.addAllNoDuplicates(item, preventDuplicates: preventDuplicates);
    refresh();
  }

  E? lastWhereEff(bool Function(E e) test, {E? fallback}) {
    return value.lastWhereEff(test, fallback: fallback);
  }

  E? firstWhereEff(bool Function(E e) test, {E? fallback}) {
    return value.firstWhereEff(test, fallback: fallback);
  }

  void retainWhereAdvanced(bool Function(E element, int index) test, {int? keepIndex}) {
    _value.retainWhereAdvanced(test, keepIndex: keepIndex);
    refresh();
  }
}
