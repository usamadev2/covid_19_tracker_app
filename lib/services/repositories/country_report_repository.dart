import 'package:covid_19_tracker_app/modals/country_report.dart';
import 'package:covid_19_tracker_app/services/api/country_report_api.dart';
import 'package:flutter/cupertino.dart';

class CountryReportRepositry with ChangeNotifier {
  final CountryReportApi _reportRepositry = CountryReportApi();
  List<CountryReport>? listCountryReport;
  Future<void> getCountryReport() async {
    listCountryReport = await _reportRepositry.fetchCountryReportApi();
    notifyListeners();
  }

  @override
  String toString() {
    return listCountryReport.toString();
  }
}
