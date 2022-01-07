import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zonain/model/user_location.dart';
import 'package:zonain/services/user_location_services.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  UserLocationService userLocationService = UserLocationService();

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _defaultBali = CameraPosition(
    target: LatLng(-8.409518, 115.275915),
    zoom: 14.4746,
  );

  CameraPosition _myLoaction(double latitude, double longitude) {
    return CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 17,
    );
  }

  Marker _marker(double latitude, double longitude) {
    return Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(latitude, longitude),
    );
  }

  @override
  void dispose() {
    userLocationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserLocation>(
        stream: userLocationService.userLocationStream,
        builder: (_, snapshot) {
          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _defaultBali,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: snapshot.hasData
                    ? {
                        _marker(
                            snapshot.data!.latitude, snapshot.data!.longitude),
                      }
                    : {_marker(-8.409518, 115.275915)},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 32),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (snapshot.hasData) {
                        _goToMyLocation(
                            snapshot.data!.latitude, snapshot.data!.longitude);
                      }
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> _goToMyLocation(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        _myLoaction(latitude, longitude),
      ),
    );
  }
}
