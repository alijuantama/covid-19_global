import 'dart:async';
import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetCountryDetail {
  List _countryDetail = [];

  StreamController _inputControllerDetail = StreamController();
  StreamSink get inputCountryDetail => _inputControllerDetail.sink;

  StreamController _inputControllerSelectedCountry = StreamController();
  StreamSink get inputSelectedCountry => _inputControllerSelectedCountry.sink;

  StreamController _outputControllerDetail = StreamController();
  StreamSink get outputCountryDetail => _outputControllerDetail.sink;

  Stream get outputDetail => _outputControllerDetail.stream;

  GetCountryDetail() {
    _inputControllerDetail.stream.listen((event) async {
      if (event == "detail") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? _selectedCountry = prefs.getString('_selectedCountry');
        HttpLink httpLink = HttpLink("https://covid19-graphql.netlify.app/");
        GraphQLClient qlClient = GraphQLClient(
          link: httpLink,
          cache: GraphQLCache(
            store: HiveStore(),
          ),
        );

        QueryResult queryResultYesterday = await qlClient.query(
          QueryOptions(
            document: gql(
              """query country {
    country(name: "${_selectedCountry}", filterBy: yesterday) {
        country
        countryInfo {
            _id
            lat
            long
            flag
            iso2
            iso3
        }
        continent
        result {
            population
            tests
            cases
            todayCases
            deaths
            todayDeaths
            recovered
            active
            critical
            casesPerOneMillion
            deathsPerOneMillion
            testsPerOneMillion
            activePerOneMillion
            recoveredPerOneMillion
            criticalPerOneMillion
            updated
        }
    }
}""",
            ),
          ),
        );
        _countryDetail.add(queryResultYesterday.data!["country"]);
        outputCountryDetail.add(_countryDetail);

        QueryResult queryResultTwoDaysAgo = await qlClient.query(
          QueryOptions(
            document: gql(
              """query country {
    country(name: "${_selectedCountry}", filterBy: twoDaysAgo) {
        country
        countryInfo {
            _id
            lat
            long
            flag
            iso2
            iso3
        }
        continent
        result {
            population
            tests
            cases
            todayCases
            deaths
            todayDeaths
            recovered
            active
            critical
            casesPerOneMillion
            deathsPerOneMillion
            testsPerOneMillion
            activePerOneMillion
            recoveredPerOneMillion
            criticalPerOneMillion
            updated
        }
    }
}""",
            ),
          ),
        );
        _countryDetail.add(queryResultTwoDaysAgo.data!["country"]);
        outputCountryDetail.add(_countryDetail);
      }
    });
  }

  void dispose() {
    _inputControllerDetail.close();
    _outputControllerDetail.close();
    _inputControllerSelectedCountry.close();
  }
}
