# Offline Geocoder

Dart library for super-fast offline reverse geocoding. Package use k-d tree for a search of the nearest location in a given file.
One when Geocoder is initialized, search for location is super-fast, about 4-5 milliseconds. This fork adds functionality to save the kdtree as json and load it again. This makes initializing
the geocode data much quicker.

## Data

For using the reverse geocoding library you need to provide а file with data about places among you want to run reverse geocoding. 
In examples you can see how to use а library with two example files:
 1. [GeoNames data](https://www.geonames.org) file with all world cities with a population above 15 000
 2. [USGS data](https://www.usgs.gov/core-science-systems/ngp/board-on-geographic-names/download-gnis-data) file with USA cities with a population above 5000.

Library allows you to use any other file who has at least data about name, latitude, and longitude of places you want to search.

## Usage

### Import
```dart
import 'package:geocoder_offline/geocoder_offline.dart';
```

### Initialization
```dart
var geocoder = GeocodeData(
    File('/example/NationalFedCodes_20191101.csv').readAsStringSync(), //input string
    'FEATURE_NAME', // place name header
    'STATE_ALPHA', // state/countery header
    'PRIMARY_LATITUDE', // latitute header
    'PRIMARY_LONGITUDE', // longitude header
    fieldDelimiter: ',', // fields delimiter
    eol: '\n');
```

### Reverse geocoding
```dart
List<LocationResult> result = geocoder.search(41.881832, -87.623177);
```

## Features and bugs

If you any problem using library or you have any new needs, please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/JankoLancer/geocoder_offline/issues
