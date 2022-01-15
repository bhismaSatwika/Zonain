import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zonain/model/report.dart';

class DatabaseService {
  //create connection
  Future<List<Report>> getReports() async {
    const String baseUrl =
        'http://159.138.244.175/project/dataCrime/?data_crime';
    var url = Uri.parse('$baseUrl=get');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseEncoded = json.decode(response.body);
      return (responseEncoded['hasil'] as List)
          .map((report) => Report.fromJson(report))
          .toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<bool> createReport({
    required double latitude,
    required double longitude,
    required String description,
    required DateTime date,
    required TimeOfDay time,
  }) async {
    var map = Map<String, dynamic>();
    map['latitude'] = latitude.toString();
    map['longitude'] = longitude.toString();
    map['description'] = description;
    map['date'] = date.toString();
    map['time'] = time.hour.toString();

    const String baseUrl =
        'http://159.138.244.175/project/dataCrime/?data_crime';
    var url = Uri.parse('$baseUrl=post');
    {
      final response = await http.post(
        url,
        body: map,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  }
}
