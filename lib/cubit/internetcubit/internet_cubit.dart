import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  StreamSubscription? connectivityStreamSubscription;
  InternetCubit(this.connectivity) : super(InternetLoading()) {
    monitorInternetConnection();
  }

  StreamSubscription<ConnectivityResult> monitorInternetConnection() {
    return connectivityStreamSubscription = connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile) {
        emit(HasInternet());
      } else if (connectivityResult == ConnectivityResult.none) {
        emit(NoInternet());
      }
    });
  }

  Future<bool> hasInternet() async {
    var result = await connectivity.checkConnectivity();
    var has = (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile);
    if (!has) {
      emit(NoInternet());
    }
    return has;
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription?.cancel();
    return super.close();
  }
}
