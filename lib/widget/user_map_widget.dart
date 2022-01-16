import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zonain/common/result_state.dart';
import 'package:zonain/model/user_location.dart';
import 'package:zonain/provider/map_provider.dart';
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
  void initState() {
    _markers.add(_marker(-8.409518, 115.275915));
    super.initState();
  }

  @override
  void dispose() {
    userLocationService.dispose();
    super.dispose();
  }

  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserLocation>(
      stream: userLocationService.userLocationStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          _markers.first =
              _marker(snapshot.data!.latitude, snapshot.data!.longitude);
        }
        return Stack(
          children: [
            Consumer<MapProvider>(
              builder: (context, provider, _) {
                if (provider.state == ResultState.loading) {
                  return const Center(
                    child: Text('Memuat Map...'),
                  );
                } else if (provider.state == ResultState.error) {
                  return const Center(
                    child: Text('Terjadi Error'),
                  );
                } else {
                  _markers.clear();
                  _markers.add(_marker(
                      snapshot.data!.latitude, snapshot.data!.longitude));
                  final reports = provider.reports;
                  for (int i = 0; i < reports.length; i++) {
                    _markers.add(
                      Marker(
                        markerId: MarkerId(reports[i].id),
                        position:
                            LatLng(reports[i].latitude, reports[i].longitude),
                      ),
                    );
                  }
                  return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _defaultBali,
                    onMapCreated: (GoogleMapController controller) {
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                    },
                    markers:
                        snapshot.hasData ? _markers.toSet() : _markers.toSet(),
                  );
                }
              },
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
      },
    );
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
