part of 'weather_cubit.dart';

@immutable
abstract class WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherFetchedSuccess extends WeatherState {
  final WeatherDataModel model;
  WeatherFetchedSuccess(this.model);
}

class WeatherFetchedFailed extends WeatherState {
  final String errorMsg;
  WeatherFetchedFailed(this.errorMsg);
}

class WeatherNoInternet extends WeatherState {
  final String msg;
  WeatherNoInternet(this.msg);
}
