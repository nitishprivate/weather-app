import 'dart:convert';

import 'package:flutter_application_1_bloc/data/dataprovider/api_connector.dart';
import 'package:flutter_application_1_bloc/data/dataprovider/api_urls.dart';
import 'package:flutter_application_1_bloc/data/model/weather_model.dart';

import '../model/search_country_state_model.dart';

class WeatherRepositories {
  Future<void> getWeather(
    void Function(WeatherDataModel weatherModel) onsuccess,
    void Function(String errorMessage) onfailure,
    SearchCountryStateModel model,
  ) async {
    var object = await APIConnector.getMethodCall(url: ApiFactory.getWeatherURL(model.lat.toString(), model.lon.toString()));
    try {
      if (object is APISuccess) {
        var jsnDecoded = await jsonDecode(object.object as String);
        if (jsnDecoded != null) {
          onsuccess(WeatherDataModel.fromJson(jsnDecoded));
        } else {
          onfailure(object.object.toString());
        }
      }
      if (object is APIFailure) {
        onfailure(object.object.toString());
      }
    } catch (e) {
      onfailure(e.toString());
    }
  }
}
