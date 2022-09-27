import 'package:covid_19_tracker_app/screen/effected_country_screen.dart';
import 'package:covid_19_tracker_app/services/repositories/country_report_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController controller;
  late CountryReportRepositry crRepositry;
  final formmat = intl.NumberFormat.decimalPattern();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    crRepositry = Provider.of<CountryReportRepositry>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Track Country',
          style: TextStyle(color: Colors.black, fontSize: 24.0),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: size.height * 0.03,
          right: size.height * 0.03,
          top: size.height * 0.01,
        ),
        child: Column(
          children: [
            _buildTextField(),
            const SizedBox(height: 10.0),
            _buildItem(size),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(Size size, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return EffectedCountryScreen(
              countryName: crRepositry.listCountryReport![index].country!,
            );
          },
        ));
        FocusManager.instance.primaryFocus?.unfocus();
        controller.clear();
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                  color: const Color.fromARGB(255, 208, 204, 204), width: 2)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: size.height * 0.03,
                  child: ClipOval(
                    child: Image.network(
                      crRepositry.listCountryReport![index].countryFlag!,
                      width: size.height * 0.06,
                      height: size.height * 0.06,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      crRepositry.listCountryReport![index].country!,
                      style: TextStyle(
                          color: Colors.black, fontSize: size.width * 0.05),
                    ),
                    Text(
                      'Effected: ${formmat.format(crRepositry.listCountryReport![index].critical)}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 163, 161, 161),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.arrow_forward_ios_outlined),
              ),
            ],
          )),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller,
      onChanged: (String? value) {
        setState(() {});
      },
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.search),
        hintText: 'Search With Country Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Size size) {
    return Expanded(
      child: ListView.builder(
        itemCount: crRepositry.listCountryReport!.length,
        itemBuilder: (context, index) {
          final String countryName =
              crRepositry.listCountryReport![index].country!;
          if (controller.text.isEmpty) {
            return _buildContainer(size, index);
          } else if (countryName
              .toLowerCase()
              .contains(controller.text.toLowerCase())) {
            return _buildContainer(size, index);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
