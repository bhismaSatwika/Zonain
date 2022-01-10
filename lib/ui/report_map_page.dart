import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zonain/common/navigation.dart';
import 'package:zonain/model/user_location.dart';
import 'package:zonain/services/user_location_services.dart';

class ReportMapPage extends StatefulWidget {
  const ReportMapPage({Key? key}) : super(key: key);
  static const routeName = './report_map_page';

  @override
  State<ReportMapPage> createState() => _ReportMapPageState();
}

class _ReportMapPageState extends State<ReportMapPage> {
  UserLocationService userLocationService = UserLocationService();
  final Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor customIcon;
  final Set<Marker> _markers = {};
  bool myLocation = false;

  @override
  void initState() {
    createCustomMarker();
    super.initState();
  }

  // @override
  // void dispose() {
  //   userLocationService.dispose();
  //   super.dispose();
  // }

  void createCustomMarker() async {
    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(1, 1)),
      'images/Vector.png',
    ).then((value) {
      setState(() {
        customIcon = value;
      });
    });
  }

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

  Marker _myLocationMarker(double latitude, double longitude) {
    var myLocation = Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(latitude, longitude),
      infoWindow: const InfoWindow(
        title: 'My Location',
        snippet: 'This is Your Location',
      ),
      icon: customIcon,
    );
    _markers.add(myLocation);
    return myLocation;
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
              myLocationEnabled: false,
              initialCameraPosition: _defaultBali,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _addCustomMarker(const LatLng(-8.409518, 115.275915));
              },
              markers: _markers,
              onTap: (latLng) {
                if (_markers.isNotEmpty) {
                  _markers.clear();
                }
                _addCustomMarker(latLng);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 32),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  onPressed: () {
                    if (snapshot.hasData) {
                      setState(() {
                        myLocation = true;
                      });
                      _goToMyLocation(
                          snapshot.data!.latitude, snapshot.data!.longitude);
                      if (_markers.isNotEmpty) {
                        _markers.clear();
                        _myLocationMarker(
                            snapshot.data!.latitude, snapshot.data!.longitude);
                      } else {
                        _myLocationMarker(
                            snapshot.data!.latitude, snapshot.data!.longitude);
                      }
                    }
                  },
                  child: const Icon(Icons.my_location),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    var latLng = _markers.first.position;
                    Navigator.of(context).pop(latLng);
                  },
                  child: myLocation
                      ? const Text('Pakai Lokasi Saya')
                      : const Text('Pakai Lokasi Ini'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Material(
                    type: MaterialType.circle,
                    elevation: 5,
                    color: Colors.blue,
                    child: IconButton(
                      onPressed: () {
                        Navigation.back();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _addCustomMarker(LatLng latLng) {
    setState(() {
      myLocation = false;
    });
    _markers.add(
      Marker(
        markerId: const MarkerId('ReportCrime'),
        position: latLng,
        icon: customIcon,
        infoWindow: InfoWindow(
          title: latLng.toString(),
        ),
      ),
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
