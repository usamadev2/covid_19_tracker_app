import 'package:covid_19_tracker_app/services/repositories/country_report_repository.dart';
import 'package:covid_19_tracker_app/services/repositories/world_report_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorldReportRepositry>(context, listen: false).getWorldReport();
    Provider.of<CountryReportRepositry>(context, listen: false)
        .getCountryReport();
  }

  final _colorList = <Color>[
    Colors.red,
    Colors.green,
    Colors.amber,
  ];

  Size? _size;
  late WorldReportRepositry wrRepositry;
  late CountryReportRepositry crRepositry;
  final formmat = intl.NumberFormat.decimalPattern();
  String selectCountry = 'Pakistan';
  double? infectedPercentage;
  double? deathsPercentage;
  double? recoveredPercentage;

  @override
  Widget build(BuildContext context) {
    _size = const Size(400, 700);
    wrRepositry = Provider.of<WorldReportRepositry>(context, listen: true);
    crRepositry = Provider.of<CountryReportRepositry>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: (wrRepositry.worldReport == null ||
                crRepositry.listCountryReport == null)
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : _buildBody(),

        /// floatingActionButton
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 108, 107, 107),
          onPressed: () async {
            selectCountry = await _buildDialog();
            setState(() {});
          },
          child: ClipOval(
            child: crRepositry.listCountryReport != null
                ? Image.network(
                    fit: BoxFit.cover,
                    height: _size!.height * 0.1,
                    width: _size!.height * 0.1,
                    crRepositry.listCountryReport!
                        .firstWhere(
                            (element) => element.country == selectCountry)
                        .countryFlag!,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  )
                : const Icon(Icons.download),
          ),
        ),

        /// BottomNavigatorBar
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 89, 86, 86),
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.home,
                        color: Colors.blue,
                      )),
                  const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const SearchScreen();
                        },
                      ));
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Search',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Covid-19 Tracker',
        style: TextStyle(
            fontSize: _size!.height * 0.04,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildColmn() {
    return Column(children: [
      _buildItems(
          'Total Cases', wrRepositry.worldReport!.totalCases.toString()),
      _buildDevider(),
      _buildItems('Deaths', wrRepositry.worldReport!.deaths.toString()),
      _buildDevider(),
      _buildItems('Recovered', wrRepositry.worldReport!.recovered.toString()),
      _buildDevider(),
      _buildItems('Active', wrRepositry.worldReport!.active.toString()),
      _buildDevider(),
      _buildItems('critical', wrRepositry.worldReport!.critical.toString()),
      _buildDevider(),
      _buildItems(
          'Today Deaths', wrRepositry.worldReport!.todayDeaths.toString()),
      _buildDevider(),
      _buildItems('Today Recovered',
          wrRepositry.worldReport!.todayRecovered.toString()),
      _buildDevider(),
    ]);
  }

  Widget _buildItems(String text, String title) {
    return Expanded(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildItemsText(text),
        _buildItemsText(title),
      ]),
    );
  }

  Widget _buildDevider() {
    return Divider(
        color: const Color.fromARGB(255, 170, 169, 169),
        endIndent: _size!.height * 0.08,
        indent: _size!.height * 0.08);
  }

  Widget firstRow() {
    if (wrRepositry.worldReport != null) {
      return Expanded(
        flex: 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// world Report text
            Text('World Reports',
                style: TextStyle(
                  fontSize: _size!.height * 0.03,
                  fontWeight: FontWeight.bold,
                )),

            /// CircularIndicator
            PieChart(
              chartRadius: _size!.height * 0.3,
              centerText: formmat.format(wrRepositry.worldReport!.totalCases),
              centerTextStyle: TextStyle(
                  fontSize: _size!.height * 0.02, color: Colors.black),
              degreeOptions: const DegreeOptions(initialAngle: 90),
              chartLegendSpacing: 8.0,
              chartValuesOptions:
                  const ChartValuesOptions(showChartValues: false),
              dataMap: {
                'Death': deathsPercentage!,
                'Recover': recoveredPercentage!,
                'infected': infectedPercentage!
              },
              ringStrokeWidth: 16.0,
              animationDuration: const Duration(microseconds: 500),
              chartType: ChartType.ring,
              colorList: _colorList,
            ),
          ],
        ),
      );
    } else {
      return const Text('Loading');
    }
  }

  Widget secondRow() {
    if (wrRepositry.worldReport != null) {
      return Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTopText('Death', Colors.red, deathsPercentage!),
              buildTopText('Recovered', Colors.green, recoveredPercentage!),
              buildTopText('Infected', Colors.amber, infectedPercentage!),
            ],
          ));
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget buildTopText(String text, Color color, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLinearIndicator(color, value),
        Text(text, style: TextStyle(fontSize: _size!.height * 0.02))
      ],
    );
  }

  Widget buildLinearIndicator(Color color, double value) {
    return LinearProgressIndicator(
      backgroundColor: const Color.fromARGB(255, 169, 166, 166),
      value: value,
      color: color,
    );
  }

  Widget thirdRow() {
    return Expanded(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildDetail(wrRepositry.worldReport!.deaths.toString()),
            buildDetail(wrRepositry.worldReport!.recovered.toString()),
            buildDetail(wrRepositry.worldReport!.critical.toString()),
          ],
        ));
  }

  Widget buildDetail(String detail) {
    return Text(detail,
        style: TextStyle(
            fontSize: _size!.width * 0.035, fontWeight: FontWeight.bold));
  }

  Widget _buildContainer() {
    return Container(
      margin: EdgeInsets.all(_size!.height * 0.02),
      padding: EdgeInsets.symmetric(
          horizontal: _size!.height * 0.025, vertical: _size!.height * 0.01),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 200, 197, 197),
            width: 1,
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: _buildColmn(),
    );
  }

  Widget _buildItemsText(String text) {
    return Text(text,
        style: TextStyle(color: Colors.black, fontSize: _size!.height * 0.02));
  }

  Future<String> _buildDialog() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Country'),
          content: SizedBox(
            height: _size!.height * 0.6,
            width: _size!.width * 0.6,
            child: ListView.builder(
              itemCount: crRepositry.listCountryReport!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        width: _size!.height * 0.07,
                        height: _size!.height * 0.07,
                        fit: BoxFit.cover,
                        crRepositry.listCountryReport![index].countryFlag!,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const CircularProgressIndicator(
                              color: Colors.black,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  title: Text(crRepositry.listCountryReport![index].country!),
                  onTap: () {
                    Navigator.pop(
                      context,
                      crRepositry.listCountryReport![index].country,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    double deaths = wrRepositry.worldReport!.deaths!.toDouble();
    double recovered = wrRepositry.worldReport!.recovered!.toDouble();
    double infected = wrRepositry.worldReport!.critical!.toDouble();

    infectedPercentage = (infected / (deaths + recovered + infected));
    deathsPercentage = (deaths / (deaths + recovered + infected));
    recoveredPercentage = (recovered / (deaths + recovered + infected));
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              firstRow(),
              secondRow(),
              thirdRow(),
            ],
          ),
        ),
        Expanded(
          child: _buildContainer(),
        ),
      ],
    );
  }
}
