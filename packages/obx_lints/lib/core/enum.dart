// ignore_for_file: constant_identifier_names

enum ObxLintPriority {
  avoid_value_r_getter(1),
  avoid_value_r_getter_all(2),
  non_reactive_value_inside_obx(3),
  non_reactive_value_inside_obx_all(4),
  prefer_rx_toggle(5),
  prefer_rx_toggle_all(6);

  const ObxLintPriority(int value) : value = 10 + value;
  final int value;
}
