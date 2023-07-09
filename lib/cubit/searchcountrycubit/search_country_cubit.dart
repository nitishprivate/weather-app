import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1_bloc/data/repositories/country_state_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/search_country_state_model.dart';
import '../../utils/de_bouncer.dart';

part 'search_country_state.dart';

class SearchCountryCubit extends Cubit<SearchCountryState> {
  final CountryStateSearchRepositories _repo;
  SearchCountryCubit(this._repo) : super(SearchCountryEmpty(""));

  final TextEditingController controller = TextEditingController();
  final Debounce debounce = Debounce(const Duration(milliseconds: 400));

  getCoutries(String query) {
    if (state is! SearchCountryLoading) {
      emit(SearchCountryLoading());
    }
    _repo.getSearchCountry(
      query,
      (querySearch) {
        emit(SearchCountrySuccess(querySearch));
      },
      (errorMessage) {
        emit(SearchCountryHasError(errorMessage));
      },
      (notFound) {
        emit(SearchCountryEmpty("No Data Found"));
      },
    );
  }

  void noInternetConnected() {
    emit(SearchCountryNoInternet("Wifi or Mobile Data is not connected."));
  }

  void refresh() {
    emit(SearchCountryEmpty("Please enter country name"));
  }

  @override
  Future<void> close() {
    controller.dispose();
    debounce.dispose();
    return super.close();
  }
}
