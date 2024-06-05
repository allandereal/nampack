import 'package:nampack/reactive/class/rx.dart';

/// An alias for `Rx<T?>`
///
/// {@macro nampack.reactive.rx_base}
class Rxn<T> extends Rx<T?> {
  Rxn([super.value]);
}

/// An alias for `RxO<T?>`
///
/// {@macro nampack.reactive.rx_base}
class RxnO<T> extends RxO<T?> {
  RxnO([super._value]);
}
