import 'package:dart_extensions/dart_extensions.dart' show NPMapUtils, NPMapUtilsNullable, NPMapExtNull;

import 'package:nampack/reactive/class/rx_base.dart';

part 'rx_map_extensions.dart';

abstract class RxMapBase<K, V> extends RxBase<Map<K, V>> {
  RxMapBase(super._value);

  Map<K, V> get _value => super.value;
}
