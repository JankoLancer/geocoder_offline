import '../geocoder_offline.dart';
import './SearchData.dart';

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

  String get gnisFormat {
    return '${distance.toInt()}mi $bearing ${location.state} ${location.featureName}';
  }
}
