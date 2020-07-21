import 'dart:math';

import 'package:csv/csv.dart';
import 'package:geocoder_offline/geocoder_offline.dart';
import 'package:geocoder_offline/src/SearchData.dart';
import 'package:kdtree/kdtree.dart';

import 'LocationData.dart';

class GeocodeData {
  /// List of possible bearings
  final List<String> bearings = <String>[
    'N',
    'NNE',
    'NE',
    'ENE',
    'E',
    'ESE',
    'SE',
    'SSE',
    'S',
    'SSW',
    'SW',
    'WSW',
    'W',
    'WNW',
    'NW',
    'NNW',
    'N'
  ];

  /// Angle that every possible bearings covers
  final double DIRECTION_RANGE = 22.5;

  /// String that contains all possible Location
  final String inputString;

  /// Field Delimiter in inputString
  final String fieldDelimiter;

  /// Text Delimiter in inputString
  final String textDelimiter;

  /// End of line character in inputString
  final String eol;

  /// Name of column that contains Location name
  final String featureNameHeader;

  /// Name of column that contains Location state
  final String stateHeader;

  /// Name of column that contains Location latitude
  final String latitudeHeader;

  /// Name of column that contains Location longitude
  final String longitudeHeader;

  /// Number of nearest result
  final int numMarkers;

  KDTree _kdTree;
  int _featureNameHeaderSN;
  int _stateHeaderSN;
  int _latitudeHeaderSN;
  int _longitudeHeaderSN;

  GeocodeData(this.inputString, this.featureNameHeader, this.stateHeader,
      this.latitudeHeader, this.longitudeHeader,
      {this.numMarkers = 1,
      this.fieldDelimiter = defaultFieldDelimiter,
      this.textDelimiter = defaultTextDelimiter,
      this.eol = defaultEol}) {
    var rowsAsListOfValues = const CsvToListConverter().convert(inputString,
        fieldDelimiter: fieldDelimiter,
        textDelimiter: textDelimiter,
        eol: eol,
        shouldParseNumbers: false);

    _featureNameHeaderSN =
        rowsAsListOfValues[0].indexWhere((x) => x == featureNameHeader);
    _stateHeaderSN = rowsAsListOfValues[0].indexWhere((x) => x == stateHeader);
    _latitudeHeaderSN =
        rowsAsListOfValues[0].indexWhere((x) => x == latitudeHeader);
    _longitudeHeaderSN =
        rowsAsListOfValues[0].indexWhere((x) => x == longitudeHeader);

    if (_featureNameHeaderSN == -1 ||
        _stateHeaderSN == -1 ||
        _latitudeHeaderSN == -1 ||
        _longitudeHeaderSN == -1) {
      throw Exception('Some of header is not find in file');
    }

    var locations = rowsAsListOfValues
        .sublist(1)
        .map((model) => LocationData(
            model[_featureNameHeaderSN],
            model[_stateHeaderSN],
            double.tryParse(model[_latitudeHeaderSN].toString()) ?? -1,
            double.tryParse(model[_longitudeHeaderSN].toString()) ?? -1))
        .map((model) => model.toJson())
        .toList();

    _kdTree = KDTree(locations, _distance, ['latitude', 'longitude']);
  }

  double _distance(location1, location2) {
    var lat1 = location1['latitude'],
        lon1 = location1['longitude'],
        lat2 = location2['latitude'],
        lon2 = location2['longitude'];

    var R = 3958.8; // Radius of the earth in miles
    var dLat = _deg2rad(lat2 - lat1); // deg2rad below
    var dLon = _deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in miles
    return d;
  }

  double _deg2rad(deg) {
    return deg * (pi / 180);
  }

  double _rad2deg(rad) {
    return rad * (180 / pi);
  }

  String _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return null;
    }

    var latitude1 = _deg2rad(lat1);
    var latitude2 = _deg2rad(lat2);
    var longDiff = _deg2rad(lon2 - lon1);
    var y = sin(longDiff) * cos(latitude2);
    var x = cos(latitude1) * sin(latitude2) -
        sin(latitude1) * cos(latitude2) * cos(longDiff);

    var degrees = ((_rad2deg(atan2(y, x)) + 360) % 360) - 11.25;

    var index = (degrees ~/ DIRECTION_RANGE);

    return bearings[index];
  }

  List<LocationResult> search(double latitute, double longitude) {
    var result = <LocationResult>[];
    var point = {'latitude': latitute, 'longitude': longitude};
    var nearest = _kdTree.nearest(point, numMarkers);
    var searchData = SearchData(latitute, longitude);

    nearest.forEach((x) {
      var location = LocationData.fromJson(x[0]);
      double distance = x[1];
      var bearing = _calculateBearing(
          location.latitude, location.longitude, latitute, longitude);
      result.add(LocationResult(location, distance, bearing, searchData));
    });

    return result;
  }
}
