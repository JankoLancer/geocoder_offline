import 'dart:io';

import 'package:geocoder_offline/geocoder_offline.dart';

void main() {
  var geocoder = GeocodeData(
      File(Directory.current.path + '/example/cities15000.txt').readAsStringSync(),
      'name',
      'country code',
      'latitude',
      'longitude',
      fieldDelimiter: '\t',
      eol: '\n');

  var result = geocoder.search(41.881832, -87.623177);
  print(result.first.gnisFormat);
}
