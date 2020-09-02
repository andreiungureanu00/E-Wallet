import 'package:dio/dio.dart';
import 'package:e_wallet/BankInfoScreen/RatePredictions/bloc/rate_prediction_events.dart';
import 'package:e_wallet/BankInfoScreen/RatePredictions/bloc/rate_prediction_states.dart';
import 'package:e_wallet/rest/StringConfigs.dart';
import 'package:e_wallet/rest/bank_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../rate_prediction.dart';

class RatePredictionBloc
    extends Bloc<RatePredictionEvents, RatePredictionStates> {
  final int coinID;
  String dropdownValue;
  var rate_sell;
  bool visible = false;
  List<String> dates = [];
  RatePredictionScreenEvents _event;

  getDates(int coin, Function onError) async {
    var response;
    Dio dio = new Dio();

    try {
      response = await dio.get(
          "${StringConfigs.baseApiUrl}/exchange/prediction/?currency=$coinID");

      for (var element in response.data) {
        String date = element["date"];
        if (!dates.contains(date)) dates.add(date);
      }
    }
    catch(exception) {
      if (exception is DioError)
        onError(exception.error);
    }

    if (dropdownValue == null) dropdownValue = dates[0];
  }

  RatePredictionBloc(this.coinID, this._event) : super(PageLoaded());

  @override
  Stream<RatePredictionStates> mapEventToState(
      RatePredictionEvents event) async* {
    if (event is GetRateSellPrediction) {
      await getDates(coinID, (error) {
        print(error.toString());
        _event.onError(error);
      });
      for (int i = 0; i < dates.length; i++)
        print(dates[i]);
      rate_sell = await BankRepository().getRatePrediction(coinID, dropdownValue, (error) {
        print(error.toString());
        _event.onError(error);
      });
      yield PageLoaded();
    }

    if (event is GetDates) {
      await getDates(coinID, (error) {
        print(error.toString());
        _event.onError(error);
      });
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
