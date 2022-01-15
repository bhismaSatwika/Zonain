import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zonain/common/result_state.dart';
import 'package:zonain/model/report.dart';
import 'package:zonain/services/database_services.dart';

class MapProvider extends ChangeNotifier {
  MapProvider() {
    getReports();
  }

  final DatabaseService _databaseService = DatabaseService();
  late List<Report> _report;
  late ResultState _state;

  List<Report> get reports => _report;
  ResultState get state => _state;

  Future<dynamic> getReports() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final reportsData = await _databaseService.getReports();

      if (reportsData.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
      } else if (reportsData.isNotEmpty) {
        _state = ResultState.hasData;
        notifyListeners();
        return _report = reportsData;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
    }
  }

  Future<void> addReport({
    required double latitude,
    required double longitude,
    required String description,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      await _databaseService.createReport(
          latitude: latitude,
          longitude: longitude,
          description: description,
          date: date,
          time: time);
      _state = ResultState.done;
      notifyListeners();
    } catch (e) {
      print(e);
      _state = ResultState.error;
      notifyListeners();
    }
  }
}
