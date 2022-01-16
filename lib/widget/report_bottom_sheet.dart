import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zonain/Screens/Signup/signup_screen.dart';
import 'package:zonain/common/navigation.dart';
import 'package:zonain/provider/map_provider.dart';
import 'package:zonain/services/database_services.dart';
import 'package:zonain/ui/report_map_page.dart';
import 'package:zonain/widget/dialogs.dart';

class ReportBottomSheet extends StatefulWidget {
  const ReportBottomSheet({Key? key}) : super(key: key);

  @override
  _ReportBottomSheetState createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  final Completer<GoogleMapController> _controller = Completer();
  var _selectedDate = DateTime.now();
  var _selectedTime = TimeOfDay.now();
  LatLng location = const LatLng(-8.409518, 115.275915);
  final Set<Marker> _markers = {};
  late BitmapDescriptor customIcon;

  final List<String> _clasifications = [
    'Kejahatan Terhadap Nyawa',
    'Kejahatan Terhadap Fisik/Nyawa',
    'Kejahatan Terhadap Kesusilaan',
    'Kejahatan Terhadap Kemerdekaan Orang',
    'Kejahatan Terhadap Hak Milik/Barang Dengan Penggunaan Kekerasan',
    'Kejahatan Terhadap Hak Milik Tanpa Kekerasan'
  ];
  String _currentCs = 'Kejahatan Terhadap Nyawa';

  final _textController = TextEditingController();

  @override
  void initState() {
    createCustomMarker();
    super.initState();
  }

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

  void _datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(
          () {
            _selectedDate = pickedDate;
          },
        );
        _timePicker();
      },
    );
  }

  void _timePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (pickedTime) {
        if (pickedTime == null) {
          return;
        }
        setState(
          () {
            _selectedTime = pickedTime;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: height - 10,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Detail Kejadian'),
              const SizedBox(height: 20),
              TextField(
                maxLines: 5,
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Terjadi Begal',
                  hintStyle: TextStyle(color: Colors.grey[200]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Tanggal Kejadian'),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.date_range_outlined),
                    onPressed: _datePicker,
                  )
                ],
              ),
              Row(
                children: [
                  Text('${_selectedTime.format(context)},'),
                  const SizedBox(width: 5),
                  Text(DateFormat.yMMMMEEEEd().format(_selectedDate)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(context, ReportMapPage.routeName)
                      .then((dynamic value) {
                    _addMarkerLocation(value);
                    _goToLocation(value);
                    setState(() {
                      location = value;
                    });
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black45, Colors.black45],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.darken,
                          child: GoogleMap(
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(-8.409518, 115.275915),
                              zoom: 12,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                              _addMarkerLocation(
                                  const LatLng(-8.409518, 115.275915));
                            },
                            markers: _markers,
                          ),
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Sentuh Untuk Menentukan Daerah",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                height: 60.0,
                child: DropdownButtonFormField(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  value: _currentCs,
                  items: _clasifications.map((cs) {
                    return DropdownMenuItem(
                      value: cs,
                      child: Text(
                        cs,
                        overflow: TextOverflow.visible,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _currentCs = val as String;
                      Provider.of<MapProvider>(context)
                          .getReportsByClassification(_currentCs);
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChangeNotifierProvider<MapProvider>(
                      create: (_) => MapProvider(),
                      builder: (ctx, _) {
                        return ElevatedButton(
                          onPressed: () async {
                            final dialogs = await Dialogs.yesAbortDialog(
                                context,
                                'Tambahkan Report',
                                'Apakah Anda Yakin Ingin Menambahkan Report ?');
                            if (dialogs == DialogAction.yes) {
                              await Provider.of<MapProvider>(ctx, listen: false)
                                  .addReport(
                                latitude: location.latitude,
                                longitude: location.longitude,
                                description: _textController.text,
                                date: _selectedDate,
                                time: _selectedTime,
                                classification: _currentCs,
                              );
                              Navigation.back();
                              // print(
                              //     '${location.latitude}, ${location.longitude}');
                              // final _db = DatabaseService();
                              // await _db.getAddress(
                              //     location.latitude, location.longitude);
                            }
                          },
                          child: const Text('Tambah Report'),
                        );
                      }),
                  ElevatedButton(
                    onPressed: () {
                      Navigation.back();
                    },
                    child: const Text('Batal'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addMarkerLocation(LatLng latLng) {
    var marker = Marker(
      markerId: const MarkerId('ThisId'),
      position: latLng,
      icon: customIcon,
    );
    _markers.clear();
    setState(() {
      _markers.add(marker);
    });
  }

  Future<void> _goToLocation(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15),
      ),
    );
  }
}
