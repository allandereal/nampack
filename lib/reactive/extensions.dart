import 'package:nampack/reactive/class/rx.dart';

extension NamReactiveUtils<T> on T {
  Rx<T> get obs => Rx<T>(this);
  RxO<T> get obso => RxO<T>(this);
}
