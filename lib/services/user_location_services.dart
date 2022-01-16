import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zonain/model/user_location.dart';

class UserLocationService {
  final Location userLocation = Location();
  // final StreamController<UserLocation> _userLocationStreamController =
  //     StreamController<UserLocation>();
  // Stream<UserLocation> get userLocationStream =>
  //     _userLocationStreamController.stream;
  final BehaviorSubject<UserLocation> _userLocationStreamSubject =
      BehaviorSubject<UserLocation>();
  ValueStream<UserLocation> get userLocationStream =>
      _userLocationStreamSubject.stream;

  UserLocationService() {
    userLocation.requestPermission().then(
      (permissionStatus) {
        if (permissionStatus == PermissionStatus.granted ||
            permissionStatus == PermissionStatus.grantedLimited) {
          userLocation.onLocationChanged.listen((locationData) {
            // ignore: unnecessary_null_comparison
            if (locationData != null) {
              _userLocationStreamSubject.add(
                UserLocation(
                    latitude: locationData.latitude!,
                    longitude: locationData.longitude!),
              );
            }
          });
        }
      },
    );
  }

  void dispose() => _userLocationStreamSubject.close();
}
