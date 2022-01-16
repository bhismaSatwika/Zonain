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
    required String classification,
  }) async {
    // final adrress = await _getAddress(latitude, longitude);
    var map = <String, dynamic>{};
    map['latitude'] = latitude.toString();
    map['longitude'] = longitude.toString();
    map['description'] = description;
    map['date'] = date.toString();
    map['time'] = time.hour.toString();
    map['classification'] = classification;
    map['format_address'] = '';

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

  Future<dynamic> getAddress(double latitude, double longitude) async {
    var mapApiKey = 'AIzaSyDmUNE5m-w70VmTIzclJAxgDqFSibYzszo';

    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$_host?key=$mapApiKey&language=en&latlng=$latitude,$longitude';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      String _formattedAddress = data["results"][0]["formatted_address"];
      print("response ==== $_formattedAddress");
      return _formattedAddress;
    } else {
      return null;
    }
  }

  Future<List<Report>> getReportByClassification(String cs) async {
    var map = <String, dynamic>{};
    map['classification'] = cs;
    const String baseUrl =
        'http://159.138.244.175/project/dataCrime/?data_crime';
    var url = Uri.parse('$baseUrl=filter');

    final response = await http.post(url, body: map);
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      var responseEncoded = json.decode(response.body);
      return (responseEncoded['hasil'] as List)
          .map((report) => Report.fromJson(report))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
