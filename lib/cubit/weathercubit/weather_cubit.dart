import 'package:flutter/material.dart';
import 'package:flutter_application_1_bloc/data/repositories/weather_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/search_country_state_model.dart';
import '../../data/model/weather_model.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherRepositories _repo;
  WeatherCubit(this._repo) : super(WeatherLoading());
  SearchCountryStateModel? model;
  WeatherList? selectedWeather;

  noInternetConnected() {
    emit(WeatherNoInternet("Wifi or Mobile Data is not connected."));
  }

  retry() {
    if (model != null) {
      loadData(model!);
    }
  }

  loadData(SearchCountryStateModel model) {
    this.model = model;
    if (state is! WeatherLoading) {
      emit(WeatherLoading());
    }
    _repo.getWeather(
      (weatherModel) {
        var tempSelectedWeather = weatherModel.list?.firstWhere((element) => ((element.isSelected ?? false)));
        if (tempSelectedWeather != null) {
          selectedWeather = tempSelectedWeather;
        }
        emit(WeatherFetchedSuccess(weatherModel));
      },
      (errorMessage) {
        emit(WeatherFetchedFailed(errorMessage));
      },
      model,
    );
  }

  changeSelectedDate(DateTime? selectedDate, WeatherDataModel tempModel) {
    try {
      tempModel = WeatherDataModel.fromJson(tempModel.toJson(), selectedDate);
      var tempSelectedWeather = tempModel.list?.firstWhere((element) => ((element.isSelected ?? false)));
      if (tempSelectedWeather != null) {
        selectedWeather = tempSelectedWeather;
        print(tempModel.list?.where((element) => element.dateTime?.day == selectedWeather?.dateTime?.day).length);
      }
    } catch (error) {
      print(error);
    }

    emit(WeatherFetchedSuccess(tempModel));
  }
}
