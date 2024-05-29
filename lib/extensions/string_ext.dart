extension StringUtils on String {
  String capitalizeFirst() {
    final word = this;
    if (word.length > 1) {
      try {
        return "${word[0].toUpperCase()}${word.substring(1)}";
      } catch (_) {}
    }
    return word;
  }
}
