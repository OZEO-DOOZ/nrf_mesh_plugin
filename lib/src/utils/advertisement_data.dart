String _toMacAddress(final List<int> bytes) => bytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':');

List<int> _maskAddress(final List<int> address) => [
      address.first | 0xc0,
      ...address.sublist(1, address.length - 1),
      address.last | 0xc0,
    ];

List<int> _macAddressBytesFromAdvertisementData(final List<int> advertisementData) =>
    advertisementData.sublist(2).reversed.toList().sublist(2, 8);

/// Check if the [address] correspond to the one in [advertisementData]
bool addressIsInAdvertisementData(final List<int> address, final List<int> advertisementData) =>
    _toMacAddress(_maskAddress(address)) ==
    _toMacAddress(_maskAddress(_macAddressBytesFromAdvertisementData(advertisementData)));

/// Generate all the possible addresses from the [advertisementData]
Stream<String> macAddressesFromAdvertisementData(final List<int> advertisementData) async* {
  final broadcastMac = _macAddressBytesFromAdvertisementData(advertisementData);
  final targetMac = broadcastMac;
  for (var i = 0; i < 4; i++) {
    for (var j = 0; j < 4; j++) {
      final testMac = [
        (targetMac[0] & 0x3f) + (i << 6),
        ...targetMac.sublist(1, 5),
        (targetMac[5] & 0x3f) + (j << 6),
      ];
      if (_toMacAddress(_maskAddress(broadcastMac)) == _toMacAddress(_maskAddress(testMac))) {
        yield _toMacAddress(testMac);
      }
    }
  }
}
