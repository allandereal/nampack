import 'package:nampack/nampack.dart';
import 'package:nampack/reactive/class/rx_base.dart';
import 'package:nampack/reactive/class/rx_updaters.dart';

mixin RxUpdatersMixin<T> on RxBase<T> {
  late final _updaters = RxUpdaters();

  @override
  T get valueR {
    RxNotifier.pullObservers(_updaters);
    return super.value;
  }

  @override
  void addListener(NamCallback listener) => _updaters.add(listener);

  @override
  void removeListener(NamCallback listener) => _updaters.remove(listener);

  @override
  void refresh() => _updaters.notifyAll();

  @override
  void close() => _updaters.clear();
}

mixin RxOUpdatersMixin<T> on RxBase<T> {
  late final _updaters = RxUpdaters();

  @override
  void addListener(NamCallback listener) => _updaters.add(listener);

  @override
  void removeListener(NamCallback listener) => _updaters.remove(listener);

  @override
  void refresh() => _updaters.notifyAll();

  @override
  void close() => _updaters.clear();
}
