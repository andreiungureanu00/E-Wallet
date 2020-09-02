import 'package:dio/dio.dart';
import 'package:e_wallet/BankInfoScreen/RatePredictions/bloc/rate_prediction_events.dart';
import 'package:e_wallet/BankInfoScreen/RatePredictions/bloc/rate_prediction_states.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:e_wallet/rest/bank_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatePredictionBloc
    extends Bloc<RatePredictionEvents, RatePredictionStates> {
  final int coinID;
  String dropdownValue;
  var rate_sell;
  bool visible = false;
  List<String> dates = [];

  getDates(int coin) async {
    var response;
    Dio dio = new Dio();

    response = await dio.get(
        "${StringConfigs.baseApiUrl}/exchange/prediction/?currency=$coinID");

    for (var element in response.data) {
      String date = element["date"];
      if (!dates.contains(date)) dates.add(date);
    }

    if (dropdownValue == null) dropdownValue = dates[0];
  }

  RatePredictionBloc(this.coinID) : super(PageLoaded());

  @override
  Stream<RatePredictionStates> mapEventToState(
      RatePredictionEvents event) async* {
    if (event is GetRateSellPrediction) {
      await getDates(coinID);
      for (int i = 0; i < dates.length; i++)
        print(dates[i]);
      rate_sell = await BankRepository().getRatePrediction(coinID, dropdownValue);
      yield PageLoaded();
    }

    if (event is GetDates) {
      getDates(coinID);
      yield PageLoaded();
    }

    if (event is ReloadPage) {
      yield PageLoaded();
    }
  }

  getRatePrediction() {
    add(GetRateSellPrediction());
  }

  reloadPage() {
    add(ReloadPage());
  }

  getdates() {
    add(GetDates());
  }
}
