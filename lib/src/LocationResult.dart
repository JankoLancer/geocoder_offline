import 'package:meta/meta.dart';

import './SearchData.dart';
import '../geocoder_offline.dart';

@immutable
class LocationResult {
  /// Location data that was finded in search. Contains data from provided search file.
  final LocationData location;

  /// Search data contains latitude and longitude that was searched for.
  final SearchData searchData;

  /// Distance beetween search data and location data
  final double distance;

  /// Bearing beetween search data and location data
  final String? bearing;

  const LocationResult(
      this.location, this.distance, this.bearing, this.searchData);

  /// Get LocationResult representation in GNIS format
  String get gnisFormat {
    if (distance < 1) {
      return '${location.featureName}, ${location.state} ';
    }
    return '${distance.toInt()}mi $bearing of ${location.featureName}, ${location.state} ';
  }

  @override
  String toString() {
    return 'LocationResult(location: $location, searchData: $searchData, distance: $distance, bearing: $bearing)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationResult &&
        other.location == location &&
        other.searchData == searchData &&
        other.distance == distance &&
        other.bearing == bearing;
  }

  @override
  int get hashCode =>
      location.hashCode ^
      searchData.hashCode ^
      distance.hashCode ^
      bearing.hashCode;
}
