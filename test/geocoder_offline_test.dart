import 'dart:io';

import 'package:geocoder_offline/geocoder_offline.dart';
import 'package:test/test.dart';

void main() {
  test('Test distance', () {
    final distance = GeocodeData.calculateDistance(49, -121, 49.2, -121.2);

    // distance is 16.517293271014562
    expect(distance, allOf([greaterThan(16), lessThan(17)]));
  });

  test('Test geocoding usgs', () {
    var geocoder = GeocodeData(
        File(Directory.current.path + '/example/NationalFedCodes_20191101.csv')
            .readAsStringSync(),
        'FEATURE_NAME',
        'STATE_ALPHA',
        'PRIMARY_LATITUDE',
        'PRIMARY_LONGITUDE',
        fieldDelimiter: ',',
        eol: '\n');

    var result = geocoder.search(41.881832, -87.623177, numMarkers: 1);
    expect(result.length, 1);
    expect(result.first.distance.toInt(), 1);
    expect(result.first.bearing, 'ESE');
    expect(result.first.location.featureName, 'Cook County');
    expect(result.first.gnisFormat.trim(), '1mi ESE of Cook County, IL');
  });

  test('Test geocoding geonames', () {
    var geocoder = GeocodeData(
        File(Directory.current.path + '/example/cities15000.txt')
            .readAsStringSync(),
        'name',
        'country code',
        'latitude',
        'longitude',
        fieldDelimiter: '\t',
        eol: '\n');

    var result = geocoder.search(41.881832, -87.623177, numMarkers: 1);
    expect(result.length, 1);
    expect(result.first.distance.toInt(), 0);
    expect(result.first.bearing, 'E');
    expect(result.first.location.featureName, 'Chicago Loop');
    expect(result.first.gnisFormat.trim(), 'Chicago Loop, US');
  });

  test('Test number of nearest result', () {
    var geocoder = GeocodeData(
        File(Directory.current.path + '/example/cities15000.txt')
            .readAsStringSync(),
        'name',
        'country code',
        'latitude',
        'longitude',
        fieldDelimiter: '\t',
        eol: '\n');

    var result = geocoder.search(41.881832, -87.623177, numMarkers: 2);
    expect(result.length, 2);
    expect(result.first.distance.toInt(), 1);
    expect(result.first.bearing, 'SE');
    expect(result.first.location.featureName, 'Near North Side');
    expect(result.first.gnisFormat.trim(), '1mi SE of Near North Side, US');
    expect(result.last.distance.toInt(), 0);
    expect(result.last.bearing, 'E');
    expect(result.last.location.featureName, 'Chicago Loop');
    expect(result.last.gnisFormat.trim(), 'Chicago Loop, US');
  });
}
