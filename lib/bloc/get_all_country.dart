import 'dart:async';
import 'dart:developer';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SelectedCountryList { allCountry, sortedCountry }

class AllCountry extends Bloc {
  List allCountry = [];

//TUTOR
  StreamController<SelectedCountryList> eventController =
      StreamController<SelectedCountryList>();
  StreamSink<SelectedCountryList> get inputTes1 => eventController.sink;

  StreamController<dynamic> stateController = StreamController<dynamic>();
  StreamSink<dynamic> get stateTes2 => stateController.sink;
  Stream<dynamic> get stateStream => stateController.stream;

  @override
  void mapEventToState(SelectedCountryList pickList) async {
    if (pickList == SelectedCountryList.allCountry) {
      print("msk fungsi");
      allCountry = [];
      HttpLink httpLink = HttpLink("https://covid19-graphql.netlify.app/");
      GraphQLClient qlClient = GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(
          store: HiveStore(),
        ),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? _sortFlag = prefs.getBool('_sortFlag');
      print("cccc ${_sortFlag}");

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

      // outputCountry.add(allCountry);
    } else {
      // tesmasuk = "pilih sorted country";
      allCountry.sort((a, b) => a["result"]["cases"] - b["result"]["cases"]);
    }

    stateTes2.add(allCountry);
  }

  AllCountry() : super({}) {
    eventController.stream.listen(mapEventToState);
  }

//   AllCountry() : super({}) {
//     _inputController.stream.listen((event) async {
//       if (event == "invoke") {
//         print("msk fungsi");
//         HttpLink httpLink = HttpLink("https://covid19-graphql.netlify.app/");
//         GraphQLClient qlClient = GraphQLClient(
//           link: httpLink,
//           cache: GraphQLCache(
//             store: HiveStore(),
//           ),
//         );
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         bool? _sortFlag = prefs.getBool('_sortFlag');
//         print("cccc ${_sortFlag}");

//         QueryResult queryResult = await qlClient.query(
//           QueryOptions(
//             document: gql(
//               """query countries {
//     countries {
//         country
//         countryInfo {
//             _id
//             lat
//             long
//             flag
//             iso3
//             iso2
//         }
//         continent
//         result {
//             population
//             tests
//             cases
//             todayCases
//             deaths
//             todayDeaths
//             recovered
//             active
//             critical
//             casesPerOneMillion
//             deathsPerOneMillion
//             testsPerOneMillion
//             activePerOneMillion
//             recoveredPerOneMillion
//             criticalPerOneMillion
//             updated
//         }
//     }
// }""",
//             ),
//           ),
//         );
//         allCountry = queryResult.data!["countries"];

//         outputCountry.add(allCountry);
//       }
//     });
//   }

  // void dispose() {
  //   _inputController.close();
  //   _outputController.close();
  //   eventController.close();
  //   stateController.close();
  // }
}
