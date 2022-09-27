import 'package:covid_19_tracker_app/modals/world_report.dart';
import 'package:covid_19_tracker_app/services/api/world_report_api.dart';
import 'package:flutter/cupertino.dart';

class WorldReportRepositry with ChangeNotifier {
  final WorldReportApi _reportApi = WorldReportApi();
  WorldReport? worldReport;
  Future<void> getWorldReport() async {
    worldReport = await _reportApi.fetchWorldReportApi();
    notifyListeners();
  }
}
