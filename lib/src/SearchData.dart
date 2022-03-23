import 'package:meta/meta.dart';

@immutable
class SearchData {
  final double latitude;
  final double longitude;

  const SearchData(this.latitude, this.longitude);

  @override
  String toString() => 'SearchData(latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchData &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
