import 'package:intl/intl.dart';

class Report {
  final String id;
  final double latitude;
  final double longitude;
  final String description;
  final DateTime date;
  final DateTime time;
  final String classification;
  final String? formatAddress;

  Report({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.date,
    required this.time,
    required this.classification,
    required this.formatAddress,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      description: json['description'],
      date: DateFormat('yyyy-MM-dd').parse(json['date']),
      time: DateFormat.Hm().parse(json['time']),
      classification: json['classification'],
      formatAddress: json['format_address'],
    );
  }
}
