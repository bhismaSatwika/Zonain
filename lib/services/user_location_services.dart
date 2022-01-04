import 'dart:async';
import 'package:location/location.dart';
import 'package:zonain/model/user_location.dart';

class UserLocationService {
  final Location userLocation = Location();
  final StreamController<UserLocation> _userLocationStreamController =
      StreamController<UserLocation>();
  Stream<UserLocation> get userLocationStream =>
      _userLocationStreamController.stream;

  UserLocationService() {
    userLocation.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        userLocation.onLocationChanged.listen((locationData) {
          // ignore: unnecessary_null_comparison
          if (locationData != null) {
            _userLocationStreamController.add(
              UserLocation(
                  latitude: locationData.latitude!,
                  longitude: locationData.longitude!),
            );
          }
        });
      }
    });
  }

  void dispose() => _userLocationStreamController.close();
}
