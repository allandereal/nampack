import 'package:nampack/reactive/class/rx.dart';
import 'package:nampack/reactive/class/rx_base.dart';

extension NamReactiveUtils<T> on T {
  Rx<T> get obs => Rx<T>(this);
  RxO<T> get obso => RxO<T>(this);
}

extension RxBoolUtils<T> on RxBase<bool> {
  bool toggle() => value = !value;
}
