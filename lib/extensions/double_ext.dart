import 'dart:math' as math;

extension DoubleUtils on double {
  double roundDecimals(int count) {
    num val = math.pow(10.0, count);
    return ((this * val).round() / val);
  }
}
