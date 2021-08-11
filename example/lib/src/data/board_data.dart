class BoardData {
  final int targetIo;
  final int offset;
  final int payload;

  const BoardData(this.targetIo, this.offset, this.payload);

  BoardData.configuration(this.targetIo)
      : offset = 0x1f,
        payload = 0;

  BoardData.lightDimmerOutput(this.targetIo)
      : offset = 0x1,
        payload = 0x1;
  BoardData.lightOnOffOutput(this.targetIo)
      : offset = 0x1,
        payload = 0;
  BoardData.shutterOutput(this.targetIo)
      : offset = 0x1,
        payload = 0x3;

  BoardData.lightInterrupterInput(this.targetIo)
      : offset = 0x2,
        payload = 0;
  BoardData.lightPushInput(this.targetIo)
      : offset = 0x2,
        payload = 0x1;
  BoardData.lightNoneInput(this.targetIo)
      : offset = 0x2,
        payload = 0x1ff;

  BoardData.shutterInput(this.targetIo)
      : offset = 0x2,
        payload = 0x2;

  BoardData.power(this.targetIo)
      : offset = 0x03,
        payload = 0;

  factory BoardData.decode(int level) {
    final payload = (level & 0x1FF);
    final offset = ((level >> 9) & 0x1F);
    var io = (level >> (9 + 5)) & 0x3;
    if (level < 0) {
      io = io | 0x2;
    }
    return BoardData(io, offset, payload);
  }

  int toByte() {
    int buff;
    int outLevel;
    buff = ((targetIo & 0x3) << (9 + 5)) | ((offset & 0x1f) << (9)) | (payload & 0x1FF);
    buff = buff.toUnsigned(16);
    if (buff & (1 << 15) != 0) {
      buff = ~buff ^ 0x01;
      outLevel = buff * -1;
    } else {
      outLevel = buff;
    }
    return outLevel;
  }

  @override
  String toString() => 'targetIo: $targetIo, offset: $offset, payload: $payload';
}
