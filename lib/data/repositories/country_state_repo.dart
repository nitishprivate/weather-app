import 'dart:convert';

import 'package:flutter_application_1_bloc/data/dataprovider/api_urls.dart';

import '../dataprovider/api_connector.dart';
import '../model/search_country_state_model.dart';

class CountryStateSearchRepositories {
  Future<void> getSearchCountry(
    String query,
    void Function(List<SearchCountryStateModel> list) onsuccess,
    void Function(String errorMessage) onfailure,
    void Function(String datanotfound) onNotFound,
  ) async {
    var object = await APIConnector.getMethodCall(url: ApiFactory.getSearchCountryURL(query));
    try {
      if (object is APISuccess) {
        var jsnDecoded = await jsonDecode(((object).object as String));
        if (jsnDecoded is List<dynamic>) {
          List<SearchCountryStateModel> tempList = [];
          for (var element in jsnDecoded) {
            tempList.add(SearchCountryStateModel.fromJson(element));
          }
          if (tempList.isEmpty) {
            onNotFound("No Data Found");
          } else {
            onsuccess(tempList);
          }
        } else {
          onfailure(object.object.toString());
        }
      }
      if (object is APIFailure) {
        if (object.statusCode != null && object.statusCode == 400) {
          var jsnDecoded = jsonDecode(object.object as String);
          if (jsnDecoded is Map<String, dynamic> && jsnDecoded["cod"].toString() == "400") {
            onfailure(jsnDecoded["message"].toString());
          }
        } else if (object.statusCode != null && object.statusCode == 100) {
          onfailure(object.object.toString());
        } else {
          onfailure(object.object.toString());
        }
      }
    } catch (e) {
      onfailure(e.toString());
    }
  }
}
