import 'package:flutter/material.dart';
import 'package:zonain/common/navigation.dart';
import 'package:zonain/ui/home_page.dart';
import 'package:zonain/ui/report_map_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zonain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.routeName,
      navigatorKey: navigatorKey,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ReportMapPage.routeName: (context) => const ReportMapPage(),
      },
    );
  }
}
