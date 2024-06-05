import 'package:nampack/reactive/class/rx_updater_mixin.dart';

import 'rx_map_base.dart';

/// {@macro nampack.reactive.rx_base}
class RxMap<K, V> = RxMapBase<K, V> with RxOUpdatersMixin<Map<K, V>>, RxUpdatersMixin<Map<K, V>>;

/// {@macro nampack.reactive.rx_base}
class RxOMap<K, V> = RxMapBase<K, V> with RxOUpdatersMixin<Map<K, V>>;

extension NPMapExtensions<K, V> on Map<K, V> {
  RxMap<K, V> get obs => RxMap<K, V>(this);
  RxOMap<K, V> get obso => RxOMap<K, V>(this);
}
