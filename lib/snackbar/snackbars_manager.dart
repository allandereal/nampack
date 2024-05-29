class SnackbarManager {
  static int get currentOpenSnackbars => _currentOpen;
  static int _currentOpen = 0;

  static final _closers = <void Function(), bool?>{};

  static void add(void Function() closeFn) {
    _closers[closeFn] = true;
    _currentOpen++;
  }

  static void remove(void Function() closeFn) {
    _closers.remove(closeFn);
    _currentOpen--;
  }

  static void closeAll() {
    final fns = _closers.keys.toList();
    _closers.clear();

    final int length = fns.length;
    for (int i = 0; i < length; i++) {
      fns[i]();
    }
  }
}
