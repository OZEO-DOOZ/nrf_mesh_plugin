extension BitFieldString on int {
  String bitField({int width = 8}) => toRadixString(2).padLeft(width, '0');
}
