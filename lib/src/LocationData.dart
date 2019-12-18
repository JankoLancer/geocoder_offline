class LocationData {
  String featureName;
  String state;
  double latitude;
  double longitude;

  LocationData(this.featureName, this.state, this.latitude, this.longitude);

  static LocationData fromJson(Map<String, dynamic> json) {
    return LocationData(json['featureName'], json['state'], double.parse(json['latitude'].toString()),
        double.parse(json['longitude'].toString()));
  }

  Map<String, dynamic> toJson() => {'featureName': featureName, 'state': state, 'latitude': latitude, 'longitude': longitude};
}
