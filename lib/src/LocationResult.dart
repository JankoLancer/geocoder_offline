import './SearchData.dart';
import '../geocoder_offline.dart';

class LocationResult {
  /// Location data that was finded in search. Contains data from provided search file.
  LocationData location;

  /// Search data contains latitude and longitude that was searched for.
  SearchData searchData;

  /// Distance beetween search data and location data
  double distance;

  /// Bearing beetween search data and location data
  String bearing;

  LocationResult(this.location, this.distance, this.bearing, this.searchData);

  /// Get LocationResult representation in GNIS format
  String get gnisFormat {
    if (distance < 1) {
      return '${location.featureName}, ${location.state} ';
    }
    return '${distance.toInt()}mi $bearing of ${location.featureName}, ${location.state} ';
  }
}
