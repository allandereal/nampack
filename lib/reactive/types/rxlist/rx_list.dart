import 'package:nampack/reactive/class/rx_updater_mixin.dart';
import 'package:nampack/reactive/types/rxlist/rx_list_base.dart';

/// {@macro nampack.reactive.rx_base}
class RxList<E> = RxListBase<E> with RxOUpdatersMixin<List<E>>, RxUpdatersMixin<List<E>>;

/// {@macro nampack.reactive.rx_base}
class RxOList<E> = RxListBase<E> with RxOUpdatersMixin<List<E>>;

extension NPListExtensions<E> on List<E> {
  RxList<E> get obs => RxList<E>(this);
  RxOList<E> get obso => RxOList<E>(this);
}
