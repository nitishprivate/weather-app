import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1_bloc/cubit/internetcubit/internet_cubit.dart';
import 'package:flutter_application_1_bloc/cubit/weathercubit/weather_cubit.dart';
import 'package:flutter_application_1_bloc/screens/search_country_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/model/search_country_state_model.dart';

class WeatherScreen extends StatefulWidget {
  final SearchCountryStateModel model;
  const WeatherScreen(this.model, {super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late WeatherCubit weatherCubit;
  @override
  void didChangeDependencies() {
    weatherCubit = BlocProvider.of<WeatherCubit>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      weatherCubit.loadData(widget.model);
    });
  }

  @override
  Widget build(BuildContext homeContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchCountryStateScreen())),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: BlocListener<InternetCubit, InternetState>(
        bloc: BlocProvider.of<InternetCubit>(homeContext),
        listener: (context, state) {
          if (state is NoInternet) {
            homeContext.read<WeatherCubit>().noInternetConnected();
          } else if (state is HasInternet) {
            homeContext.read<WeatherCubit>().retry();
          }
        },
        child: Center(
          child: BlocBuilder<WeatherCubit, WeatherState>(
            bloc: weatherCubit,
            builder: (context, state) {
              Widget child;
              switch (state.runtimeType) {
                case WeatherLoading:
                  child = const CircularProgressIndicator();
                  break;
                case WeatherNoInternet:
                  child = Text((state as WeatherNoInternet).msg);
                  break;
                case WeatherFetchedFailed:
                  child = Text((state as WeatherFetchedFailed).errorMsg);
                  break;
                case WeatherFetchedSuccess:
                  state as WeatherFetchedSuccess;
                  child = ListView(
                    children: [
                      /// selected date UI
                      Text(
                        weatherCubit.selectedWeather?.main?.temp.toString() ?? "",
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        state.model.city?.name ?? "",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        DateFormat("dd, MMM").format(weatherCubit.selectedWeather?.dateTime ?? DateTime.now()),
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "${weatherCubit.model?.name}, ${weatherCubit.model?.state}, ${weatherCubit.model?.country}",
                          textAlign: TextAlign.center,
                        ),
                      ),

                      /// hourly report ui
                      SizedBox(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              (state.model.list?.length ?? 0),
                              (index) {
                                return Visibility(
                                  replacement: const SizedBox(),
                                  visible: (state.model.list?[index].dateTime?.day == weatherCubit.selectedWeather?.dateTime?.day),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(DateFormat("hh:mm a").format(state.model.list?[index].dateTime ?? DateTime.now())),
                                              const SizedBox(height: 10),
                                              Text(state.model.list?[index].main?.temp.toString() ?? ""),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      /// Next Date UI
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text("Other dates data"),
                      ),
                      Column(
                        children: List.generate(
                          (state.model.list?.length ?? 0),
                          (index) => Visibility(
                            replacement: const SizedBox(),
                            visible: ((state.model.list?[index].isFirstOne ?? false) && !(state.model.list?[index].isSelected ?? false)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: ListTile(
                                tileColor: Colors.amber,
                                textColor: Colors.white,
                                onTap: () => weatherCubit.changeSelectedDate(state.model.list?[index].dateTime, state.model),
                                title: Text(
                                    "Tempratur: ${state.model.list?[index].main?.temp} ${DateFormat("dd, MMM").format(state.model.list?[index].dateTime ?? DateTime.now())}"),
                                subtitle: Text(
                                  "Speed:${state.model.list?[index].wind?.speed} Gust:${state.model.list?[index].wind?.gust} DEG:${state.model.list?[index].wind?.deg}",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );

                  break;
                default:
                  child = const Text("Something went wrong in condition");
              }
              return child;
            },
          ),
        ),
      ),
    );
  }
}
