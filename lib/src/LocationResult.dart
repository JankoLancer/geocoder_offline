import '../geocoder_offline.dart';

class LocationResult {
  LocationData location;
  double distance;
  String bearing;
  
  LocationResult(this.location, this.distance, this.bearing);

  String get gnisFormat {
    return '${distance.toInt()}mi $bearing ${location.state} ${location.featureName}';
  }
}
