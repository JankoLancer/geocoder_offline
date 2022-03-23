import 'package:meta/meta.dart';

@immutable
class LocationData {
  /// Name of Location
  final String? featureName;

  /// State of Location
  final String? state;

  /// Latitude position of Location
  final double? latitude;

  /// Longitude position of Location
  final double? longitude;

  const LocationData(
      this.featureName, this.state, this.latitude, this.longitude);

  static LocationData fromJson(Map<String, dynamic> json) {
    return LocationData(
        json['featureName'],
        json['state'],
        double.parse(json['latitude'].toString()),
        double.parse(json['longitude'].toString()));
  }

  Map<String, dynamic> toJson() => {
        'featureName': featureName,
        'state': state,
        'latitude': latitude,
        'longitude': longitude
      };

  @override
  String toString() {
    return 'LocationData(featureName: $featureName, state: $state, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationData &&
        other.featureName == featureName &&
        other.state == state &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode =>
      featureName.hashCode ^
      state.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
}
