import 'package:covid_19_tracker_app/screen/home_screen.dart';
import 'package:covid_19_tracker_app/services/repositories/country_report_repository.dart';
import 'package:covid_19_tracker_app/services/repositories/world_report_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CountryReportRepositry>(
        create: (context) {
          return CountryReportRepositry();
        },
      ),
      ChangeNotifierProvider<WorldReportRepositry>(
        create: (context) {
          return WorldReportRepositry();
        },
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
