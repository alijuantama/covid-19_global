import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sayakaya_test/bloc/get_country_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';

class CountryDetail extends StatefulWidget {
  const CountryDetail({super.key, this.countryName});
  final String? countryName;

  @override
  State<CountryDetail> createState() => _CountryDetailState();
}

class _CountryDetailState extends State<CountryDetail> {
  List<_DeathCovid19> _deathByCovid19 = [];
  NumberFormat _numberFormat = NumberFormat.decimalPattern('en_us');

  GetCountryDetail _detailCountry = GetCountryDetail();

  @override
  void dispose() {
    _detailCountry.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _detailCountry.inputCountryDetail.add("detail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Covid Detail")),
      body: StreamBuilder(
          stream: _detailCountry.outputDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var accessedData = snapshot.data;

              for (var i = 0; i < accessedData.length; i++) {
                _deathByCovid19.add(_DeathCovid19(
                    i == 0 ? "Yesterday" : "${i + 1} days ago",
                    accessedData[i]["result"]["todayDeaths"].toDouble()));
              }
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          child: CachedNetworkImage(
                            imageUrl:
                                "${accessedData[0]["countryInfo"]["flag"]}",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            "${accessedData[0]["country"]} Detail",
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Text("Total Population"),
                        Spacer(),
                        Text(
                            "${_numberFormat.format(accessedData[0]["result"]["population"])} people")
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Case Historical Detail",
                      style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ExpansionTile(
                      title: Text(
                        "Death by Covid Graph",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      children: [
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(
                                text: 'Death by Covid 19',
                                textStyle: TextStyle(
                                    color: Colors.blue, fontSize: 13)),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <LineSeries<_DeathCovid19, String>>[
                              LineSeries<_DeathCovid19, String>(
                                  dataSource: _deathByCovid19,
                                  xValueMapper: (_DeathCovid19 e, _) =>
                                      e.timeFrame,
                                  yValueMapper: (_DeathCovid19 e, _) => e.death,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true))
                            ])
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class _DeathCovid19 {
  _DeathCovid19(this.timeFrame, this.death);

  final String timeFrame;
  final double death;
}
