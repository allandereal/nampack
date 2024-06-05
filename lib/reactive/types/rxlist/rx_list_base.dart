import 'package:dart_extensions/dart_extensions.dart' show DEListieExt;

import 'package:nampack/reactive/class/rx_base.dart';

part 'rx_list_extensions.dart';

abstract class RxListBase<E> extends RxBase<List<E>> with RxExecuterMixin<List<E>> {
  RxListBase(super._value);

  List<E> get _value => super.value;

  E operator [](int index) => valueR[index];

  void operator []=(int index, E value) {
    _value[index] = value;
    refresh();
  }
}
