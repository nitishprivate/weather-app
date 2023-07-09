part of 'search_country_cubit.dart';

@immutable
abstract class SearchCountryState {}

class SearchCountryLoading extends SearchCountryState {}

class SearchCountryNoInternet extends SearchCountryState {
  final String msg;
  SearchCountryNoInternet(this.msg);
}

class SearchCountryEmpty extends SearchCountryState {
  final String msg;
  SearchCountryEmpty(this.msg);
}

class SearchCountryHasError extends SearchCountryState {
  final String errorMessage;
  SearchCountryHasError(this.errorMessage);
}

class SearchCountrySuccess extends SearchCountryState {
  final List<SearchCountryStateModel> list;
  SearchCountrySuccess(this.list);
}
