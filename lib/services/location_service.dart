import 'dart:async';
import 'package:location/location.dart';
import 'package:poc/models/user_location.dart';

class LocationService {
  late UserLocation _currentLocation;
  Location location = Location();

  // continuously get location updates
  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  LocationService() {
    location.requestPermission().then((granted) {
      location.onLocationChanged.listen((locationData) {
        _locationController.add(UserLocation(
            latitude: locationData.latitude,
            longitude: locationData.longitude));
      });
    });
  }

  Stream<UserLocation> get locationStream => _locationController.stream;
  Future<Object> getLocation() async {
    try {
      var userLocation = await location.getLocation();

      _currentLocation = UserLocation(
          longitude: userLocation.longitude, latitude: userLocation.latitude);
    } catch (e) {
      return e;
    }
    return _currentLocation;
  }
}
