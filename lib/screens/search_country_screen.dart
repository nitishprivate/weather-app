import 'package:flutter/material.dart';
import 'package:flutter_application_1_bloc/cubit/searchcountrycubit/search_country_cubit.dart';
import 'package:flutter_application_1_bloc/screens/weather_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/internetcubit/internet_cubit.dart';

class SearchCountryStateScreen extends StatefulWidget {
  const SearchCountryStateScreen({super.key});

  @override
  State<SearchCountryStateScreen> createState() => _SearchCountryStateScreenState();
}

class _SearchCountryStateScreenState extends State<SearchCountryStateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<InternetCubit>().hasInternet().then((hasInternet) {
        if (!hasInternet) {
          BlocProvider.of<SearchCountryCubit>(context).noInternetConnected();
        }
      });
    });
  }

  @override
  Widget build(BuildContext searchContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Country"),
      ),
      body: BlocListener<InternetCubit, InternetState>(
        bloc: BlocProvider.of<InternetCubit>(searchContext),
        listener: (context, state) {
          if (state is NoInternet) {
            searchContext.read<SearchCountryCubit>().noInternetConnected();
          } else if (state is HasInternet) {
            searchContext.read<SearchCountryCubit>().refresh();
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                autofocus: true,
                controller: searchContext.read<SearchCountryCubit>().controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "search country name",
                ),
                onChanged: (query) {
                  searchContext.read<SearchCountryCubit>().debounce(() {
                    searchContext.read<InternetCubit>().hasInternet().then((hasInternet) {
                      if (hasInternet && query.isNotEmpty) {
                        searchContext.read<SearchCountryCubit>().getCoutries(query);
                      }
                    });
                  });
                },
              ),
            ),
            Expanded(
              child: Center(
                child: BlocBuilder<SearchCountryCubit, SearchCountryState>(
                  bloc: BlocProvider.of<SearchCountryCubit>(searchContext),
                  builder: (context, state) {
                    if (state is SearchCountryLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is SearchCountryNoInternet) {
                      return Text(state.msg);
                    } else if (state is SearchCountryEmpty) {
                      return Text(state.msg);
                    } else if (state is SearchCountryHasError) {
                      return Text(state.errorMessage);
                    } else if (state is SearchCountrySuccess) {
                      return ListView.builder(
                        itemCount: state.list.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.list[index].name ?? ""),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                builder: (context) {
                                  return WeatherScreen(state.list[index]);
                                },
                              ), (route) => false);
                            },
                          );
                        },
                      );
                    } else {
                      return const Text("Something went wrong in condition");
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
