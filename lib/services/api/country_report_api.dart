import 'dart:convert';

import 'package:covid_19_tracker_app/modals/country_report.dart';
import 'package:covid_19_tracker_app/utils/constant.dart';
import 'package:http/http.dart' as http;

class CountryReportApi {
  final _uri =
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.countriesEndPoint}');

  Future<List<CountryReport>> fetchCountryReportApi() async {
    try {
      http.Response response = await http.get(_uri);
      if (response.statusCode == 200) {
        List decodeList = jsonDecode(response.body);
        List<CountryReport> countryList = decodeList
            .map((element) => CountryReport.fromMap(element))
            .toList();
        return countryList;
      } else {
        throw 'Somthing went wrong';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
