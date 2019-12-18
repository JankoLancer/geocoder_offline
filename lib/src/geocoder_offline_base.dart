import 'dart:math';

import 'package:csv/csv.dart';
import 'package:geocoder_offline/geocoder_offline.dart';
import 'package:kdtree/kdtree.dart';

import 'LocationData.dart';

class GeocodeData {
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
  final double DIRECTION_RANGE = 22.5;
  final String inputString;
  final int numMarkers;
  final String fieldDelimiter;
  final String textDelimiter;
  final String eol;
  final String featureNameHeader;
  final String stateHeader;
  final String latitudeHeader;
  final String longitudeHeader;

  KDTree kdTree;
  int featureNameHeaderSN;
  int stateHeaderSN;
  int latitudeHeaderSN;
  int longitudeHeaderSN;

  GeocodeData(this.inputString, this.featureNameHeader, this.stateHeader, this.latitudeHeader, this.longitudeHeader,
      {this.numMarkers = 1,
      this.fieldDelimiter = defaultFieldDelimiter,
      this.textDelimiter = defaultTextDelimiter,
      this.eol = defaultEol}) {
    var rowsAsListOfValues = const CsvToListConverter().convert(inputString,
        fieldDelimiter: fieldDelimiter, textDelimiter: textDelimiter, eol: eol, shouldParseNumbers: false);

    featureNameHeaderSN = rowsAsListOfValues[0].indexWhere((x) => x == featureNameHeader);
    stateHeaderSN = rowsAsListOfValues[0].indexWhere((x) => x == stateHeader);
    latitudeHeaderSN = rowsAsListOfValues[0].indexWhere((x) => x == latitudeHeader);
    longitudeHeaderSN = rowsAsListOfValues[0].indexWhere((x) => x == longitudeHeader);

    if (featureNameHeaderSN == -1 || stateHeaderSN == -1 || latitudeHeaderSN == -1 || longitudeHeaderSN == -1) {
      throw Exception('Some of header is not find in file');
    }

    var locations = rowsAsListOfValues
        .sublist(1)
        .map((model) => LocationData(
            model[featureNameHeaderSN],
            model[stateHeaderSN],
            double.tryParse(model[latitudeHeaderSN].toString()) ?? -1,
            double.tryParse(model[longitudeHeaderSN].toString()) ?? -1))
        .map((model) => model.toJson())
        .toList();

    kdTree = KDTree(locations, _distance, ['latitude', 'longitude']);
  }

  double _distance(location1, location2) {
    var lat1 = location1['latitude'],
        lon1 = location1['longitude'],
        lat2 = location2['latitude'],
        lon2 = location2['longitude'];

    var R = 3958.8; // Radius of the earth in miles
    var dLat = _deg2rad(lat2 - lat1); // deg2rad below
    var dLon = _deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) + cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in miles
    return d;
  }

  double _deg2rad(deg) {
    return deg * (pi / 180);
  }

  String _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return null;
    }

    var latitude1 = _deg2rad(lat1);
    var latitude2 = _deg2rad(lat2);
    var longDiff = _deg2rad(lon2 - lon1);
    var y = sin(longDiff) * cos(latitude2);
    var x = cos(latitude1) * sin(latitude2) - sin(latitude1) * cos(latitude2) * cos(longDiff);

    var degrees = ((_deg2rad(atan2(y, x)) + 360) % 360) - 11.25;

    var index = (degrees ~/ DIRECTION_RANGE);

    return bearings[index];
  }

  List<LocationResult> search(double latitute, double longitude) {
    var result = <LocationResult>[];
    var point = {'latitude': latitute, 'longitude': longitude};
    var nearest = kdTree.nearest(point, numMarkers);

    nearest.forEach((x) {
      var location = LocationData.fromJson(x[0]);
      double distance = x[1];
      var bearing = _calculateBearing(latitute, longitude, location.latitude, location.longitude);
      result.add(LocationResult(location, distance, bearing));
    });

    return result;
  }
}
