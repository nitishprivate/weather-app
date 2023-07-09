part of 'internet_cubit.dart';

@immutable
abstract class InternetState {}

class InternetLoading extends InternetState {}

class NoInternet extends InternetState {}

class HasInternet extends InternetState {}
