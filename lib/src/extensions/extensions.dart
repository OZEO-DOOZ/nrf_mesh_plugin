extension BitFieldString on int {
  /// A method to "pretty-print" a given integer as a series of [width] bit(s)
  String bitField({int width = 8}) => toRadixString(2).padLeft(width, '0');
}
