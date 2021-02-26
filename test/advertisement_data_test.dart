import 'package:flutter_test/flutter_test.dart';
import 'package:nordic_nrf_mesh/src/utils/advertisement_data.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('Check if address correspond to the one in advertisement data', () {
    final data = {
      'ED:E4:50:B2:FB:C3': '9FA17819-6407-E043-83FB-B250E46DC3EF',
      'C2:A5:D1:FD:87:C3': 'E04B7DA8-CA77-2C44-8387-FDD1A5025E44',
      'E9:9B:4C:42:E8:03': '8F5A5B2E-59DF-1E4B-83E8-424C9B691FED',
      'EB:54:6D:95:19:B0': '4C2279BD-5208-F545-B019-956D54ABE171',
      'F3:3B:41:F8:B3:02': '8DDF4093-1246-644F-82B3-F8413B73EC32',
      'E7:B1:36:53:BF:60': '194781D9-A7D1-E042-A0BF-5336B1679AF7',
      'DA:B3:A1:FC:E1:D3': 'D1640C64-3AE1-EF43-93E1-FCA1B39AE94A',
      'D4:83:A8:02:68:A1': '3C3CDFE6-E7BB-AA46-A168-02A88394A787',
      'FB:80:1B:67:45:B3': '55959A8F-DB79-8343-B345-671B803BBABE'
    };
    for (final key in data.keys) {
      final rawData = Uuid().parse(data[key]);
      expect(
        addressIsInAdvertisementData(key.split(':').map((e) => int.parse(e, radix: 16)).toList(), rawData),
        isTrue,
        reason: '$key is not in $rawData',
      );
    }
  });
}
