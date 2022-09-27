import 'package:covid_19_tracker_app/modals/world_report.dart';
import 'package:covid_19_tracker_app/utils/constant.dart';
import 'package:http/http.dart' as http;

class WorldReportApi {
  final _uri = Uri.parse(ApiConstants.allEndPoint);

  Future<WorldReport> fetchWorldReportApi() async {
    try {
      http.Response response = await http.get(_uri);

      if (response.statusCode == 200) {
        WorldReport worldReport = WorldReport.fromJson(response.body);
        return worldReport;
      } else {
        throw 'Somthing went wrong';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
