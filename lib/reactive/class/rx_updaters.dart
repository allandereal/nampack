import 'package:nampack/nampack.dart';

class RxUpdaters {
  RxUpdaters();

  late final _updaters = <NamCallback>[];

  void add(NamCallback updater) => _updaters.add(updater);
  bool contains(NamCallback updater) => _updaters.contains(updater);
  bool remove(NamCallback updater) => _updaters.remove(updater);

  void notifyAll() {
    final int length = _updaters.length;
    if (length == 0) return;

    if (length == 1) {
      _updaters[0]();
    } else {
      for (int i = 0; i < length; i++) {
        _updaters[i]();
      }
    }
  }

  void clear() => _updaters.clear();
}
