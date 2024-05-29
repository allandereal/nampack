import 'package:nampack/reactive/class/rx_updater_mixin.dart';
import 'package:nampack/reactive/types/rxlist/rx_list_base.dart';

class RxList<E> = RxListBase<E> with RxUpdatersMixin<List<E>>;
class RxOList<E> = RxListBase<E> with RxOUpdatersMixin<List<E>>;

extension NPListExtensions<E> on List<E> {
  RxList<E> get obs => RxList<E>(this);
  RxOList<E> get obso => RxOList<E>(this);
}
