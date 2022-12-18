import 'dart:async';
import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SelectedCountryList { allCountry, sortedCountry }

class AllCountry extends Bloc {
  List allCountry = [];
  StreamController<SelectedCountryList> eventController =
      StreamController<SelectedCountryList>();
  StreamSink<SelectedCountryList> get eventControllerInput =>
      eventController.sink;

  StreamController<dynamic> stateController = StreamController<dynamic>();
  StreamSink<dynamic> get stateOutput => stateController.sink;
  Stream<dynamic> get stateStream => stateController.stream;

  @override
  void mapEventToState(SelectedCountryList event) async {
    if (event == SelectedCountryList.allCountry) {
      allCountry = [];
      HttpLink httpLink = HttpLink("https://covid19-graphql.netlify.app/");
      GraphQLClient qlClient = GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(
          store: HiveStore(),
        ),
      );

      QueryResult queryResult = await qlClient.query(
        QueryOptions(
          document: gql(
            """query countries {
    countries {
        country
        countryInfo {
            _id
            lat
            long
            flag
            iso3
            iso2
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
      allCountry = queryResult.data!["countries"];
    } else {
      allCountry.sort((a, b) => a["result"]["cases"] - b["result"]["cases"]);
    }

    stateOutput.add(allCountry);
  }

  AllCountry() : super({}) {
    eventController.stream.listen(mapEventToState);
  }
}
