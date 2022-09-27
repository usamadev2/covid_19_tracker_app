import 'package:covid_19_tracker_app/modals/country_report.dart';
import 'package:covid_19_tracker_app/services/repositories/country_report_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class EffectedCountryScreen extends StatefulWidget {
  const EffectedCountryScreen({key, required this.countryName})
      : super(key: key);
  final String countryName;
  @override
  State<EffectedCountryScreen> createState() => _EffectedCountryScreenState();
}

class _EffectedCountryScreenState extends State<EffectedCountryScreen> {
  late CountryReport countryReport;
  final formmat = intl.NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var crRepositry =
        Provider.of<CountryReportRepositry>(context, listen: false);
    countryReport = crRepositry.listCountryReport!
        .firstWhere((element) => element.country == widget.countryName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(size),
      body: Column(
        children: [
          Expanded(flex: 15, child: _bildImage(size)),
          const Expanded(flex: 5, child: SizedBox()),
          _buildListItem(size),
          const Expanded(flex: 10, child: SizedBox())
        ],
      ),
    );
  }

  AppBar _buildAppBar(Size size) {
    return AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          countryReport.country.toString(),
          style: TextStyle(color: Colors.black, fontSize: size.height * 0.03),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent);
  }

  Widget _bildImage(Size size) {
    return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: size.height * 0.08,
        child: ClipOval(
            child: Image.network(
          fit: BoxFit.cover,
          height: size.height * 0.1,
          width: size.height * 0.1,
          countryReport.countryFlag.toString(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )));
  }

  Widget _buildListItem(Size size) {
    return Expanded(
      flex: 70,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.03),
        child: Container(
          padding: EdgeInsets.only(
            left: size.height * 0.01,
            right: size.height * 0.01,
            bottom: size.height * 0.01,
            top: size.height * 0.01,
          ),
          decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromARGB(255, 200, 197, 197),
                width: 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(28.0),
          ),
          child: _buildColumn(size),
        ),
      ),
    );
  }

  Widget _buildItem(Size size, String text, String title) {
    return Expanded(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(text,
            style:
                TextStyle(color: Colors.black, fontSize: size.height * 0.02)),
        Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: size.height * 0.02),
        ),
      ]),
    );
  }

  Widget _buildDivider(Size size) {
    return Divider(
        color: const Color.fromARGB(255, 170, 169, 169),
        endIndent: size.height * 0.08,
        indent: size.height * 0.08);
  }

  Widget _buildColumn(Size size) {
    return Padding(
      padding: EdgeInsets.only(
        left: size.height * 0.02,
        right: size.height * 0.02,
        bottom: size.height * 0.02,
        top: size.height * 0.02,
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildItem(
            size, 'Total Cases', formmat.format(countryReport.totalCases)),
        _buildDivider(size),
        _buildItem(size, 'Deaths', formmat.format(countryReport.deaths)),
        _buildDivider(size),
        _buildItem(size, 'Recovered', formmat.format(countryReport.recovered)),
        _buildDivider(size),
        _buildItem(size, 'Active', formmat.format(countryReport.active)),
        _buildDivider(size),
        _buildItem(size, 'critical', formmat.format(countryReport.critical)),
        _buildDivider(size),
        _buildItem(
            size, 'Today Deaths', formmat.format(countryReport.todayDeaths)),
        _buildDivider(size),
        _buildItem(size, 'Today Recovered',
            formmat.format(countryReport.todayRecovered)),
        _buildDivider(size),
      ]),
    );
  }
}
