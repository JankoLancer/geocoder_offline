class LocationData {
  /// Name of Location
  String? featureName;

  /// State of Location
  String? state;

  /// Latitude position of Location
  double? latitude;

  /// Longitude position of Location
  double? longitude;

  LocationData(this.featureName, this.state, this.latitude, this.longitude);

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
}
