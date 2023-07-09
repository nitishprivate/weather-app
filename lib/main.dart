import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1_bloc/cubit/internetcubit/internet_cubit.dart';
import 'package:flutter_application_1_bloc/cubit/searchcountrycubit/search_country_cubit.dart';
import 'package:flutter_application_1_bloc/cubit/weathercubit/weather_cubit.dart';
import 'package:flutter_application_1_bloc/screens/search_country_screen.dart';
import 'package:flutter_application_1_bloc/utils/app_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/country_state_repo.dart';
import 'data/repositories/weather_repo.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  runApp(
    MultiRepositoryProvider(
      /// global repo
      providers: [
        RepositoryProvider(create: (_) => CountryStateSearchRepositories(), lazy: false),
        RepositoryProvider(create: (_) => WeatherRepositories(), lazy: false),
      ],
      child: MultiBlocProvider(
        /// global provider
        providers: [
          BlocProvider(create: (_) => InternetCubit(Connectivity())),
          BlocProvider(create: (searchContext) => SearchCountryCubit(searchContext.read<CountryStateSearchRepositories>())),
          BlocProvider(create: (weatherContext) => WeatherCubit(weatherContext.read<WeatherRepositories>())),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SearchCountryStateScreen(),
        ),
      ),
    ),
  );
}
