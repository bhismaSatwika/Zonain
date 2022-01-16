import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zonain/common/result_state.dart';
import 'package:zonain/common/style.dart';
import 'package:zonain/provider/map_provider.dart';

class SeeReportsPage extends StatefulWidget {
  static const routeName = '/see_reports_page';
  const SeeReportsPage({Key? key}) : super(key: key);

  @override
  State<SeeReportsPage> createState() => _SeeReportsPageState();
}

class _SeeReportsPageState extends State<SeeReportsPage> {
  bool _isSearching = false;
  final List<String> _clasifications = [
    'All',
    'Kejahatan Terhadap Nyawa',
    'Kejahatan Terhadap Fisik/Nyawa',
    'Kejahatan Terhadap Kesusilaan',
    'Kejahatan Terhadap Kemerdekaan Orang',
    'Kejahatan Terhadap Hak Milik/Barang Dengan Penggunaan Kekerasan',
    'Kejahatan Terhadap Hak Milik Tanpa Kekerasan'
  ];
  String _currentCs = 'Kejahatan Terhadap Nyawa';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapProvider(),
      builder: (ctx, _) {
        return Scaffold(
          backgroundColor: seeReportBg,
          appBar: AppBar(
            backgroundColor: appBackground,
            title: _isSearching
                ? const TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Search Area...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white30),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  )
                : const Text('Reports'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButtonFormField(
                    dropdownColor: seeReportBg,
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
                          style: const TextStyle(fontSize: 16, color: text),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _currentCs = val as String;
                      });
                      if (_currentCs == 'All') {
                        Provider.of<MapProvider>(ctx, listen: false)
                            .getReports();
                      } else {
                        Provider.of<MapProvider>(ctx, listen: false)
                            .getReportsByClassification(_currentCs);
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Consumer<MapProvider>(
                    builder: (context, provider, _) {
                      if (provider.state == ResultState.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (provider.state == ResultState.error) {
                        return const Center(
                          child: Text(
                            'Terjadi Error',
                            style: TextStyle(fontSize: 18, color: text),
                          ),
                        );
                      } else if (provider.state == ResultState.noData) {
                        return const Center(
                          child: Text(
                            'Tidak ada data',
                            style: TextStyle(fontSize: 18, color: text),
                          ),
                        );
                      } else {
                        final length = provider.reports.length;
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: length,
                                itemBuilder: (context, index) {
                                  var report = provider.reports[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'latitude : ${report.latitude}',
                                            style: const TextStyle(
                                                fontSize: 16, color: text),
                                          ),
                                          Text(
                                            'longitude : ${report.longitude}',
                                            style: const TextStyle(
                                                fontSize: 16, color: text),
                                          ),
                                          Text(
                                            'Deskripsi : ${report.description}',
                                            style: const TextStyle(
                                                fontSize: 16, color: text),
                                          ),
                                          Text(
                                            'Jenis Kejahatan : ${report.classification}',
                                            style: const TextStyle(
                                                fontSize: 16, color: text),
                                          ),
                                          const Divider(
                                            thickness: 1.5,
                                            color: line,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
