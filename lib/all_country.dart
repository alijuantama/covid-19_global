import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get/get.dart';
import 'package:sayakaya_test/bloc/get_all_country.dart';
import 'package:sayakaya_test/coutry_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class getAllCountry extends StatefulWidget {
  const getAllCountry({super.key});

  @override
  State<getAllCountry> createState() => _getAllCountryState();
}

class _getAllCountryState extends State<getAllCountry> {
  AllCountry _allCountryList = AllCountry();
  NumberFormat _numberFormat = NumberFormat.decimalPattern('en_us');

  addSelectedCountry(country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("_selectedCountry");
    prefs.setString('_selectedCountry', "${country}");
  }

  @override
  void initState() {
    var bloc = BlocProvider.of<AllCountry>(context);
    bloc.eventController.add(SelectedCountryList.allCountry);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<AllCountry>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("All Country"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                    width: 140,
                    child: ElevatedButton(
                        onPressed: () {
                          bloc.eventController
                              .add(SelectedCountryList.sortedCountry);
                        },
                        child: Text(
                          "Sort by Lowest Case",
                          style: TextStyle(fontSize: 11),
                        )),
                  ),
                  SizedBox(width: 30),
                  SizedBox(
                    height: 30,
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          bloc.eventController
                              .add(SelectedCountryList.allCountry);
                        },
                        child: Text("Sort by Alphabet Order",
                            style: TextStyle(fontSize: 11))),
                  ),
                ],
              ),
              SizedBox(height: 20),
              StreamBuilder(
                  stream: bloc.stateStream,
                  // initialData: bloc.tesmasuk,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var accessedData = snapshot.data;
                      return Expanded(
                        child: ListView.builder(
                            itemCount: accessedData.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: (() {
                                  addSelectedCountry(
                                      accessedData[index]['country']);
                                  Get.to(CountryDetail(
                                    countryName:
                                        "${accessedData[index]['country']}",
                                  ));
                                }),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                "${accessedData[index]['country']}",
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Spacer(),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${accessedData[index]["countryInfo"]["flag"]}",
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Container(
                                              width: 200,
                                              child: Text("Total Cases",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style:
                                                      TextStyle(fontSize: 13)),
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                AutoSizeText(
                                                  "${_numberFormat.format(accessedData[index]["result"]["cases"])} Cases",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  minFontSize: 9,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Container(
                                              width: 200,
                                              child: Text("Total Deaths",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style:
                                                      TextStyle(fontSize: 13)),
                                            ),
                                            Spacer(),
                                            AutoSizeText(
                                                "${_numberFormat.format(accessedData[index]["result"]["deaths"])} Deaths",
                                                maxLines: 1,
                                                style: TextStyle(fontSize: 11)),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1,
                                        ),
                                        Text(
                                          "${accessedData[index]["continent"]}",
                                          maxLines: 1,
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        ));
  }
}
