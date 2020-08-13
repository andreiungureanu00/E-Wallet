import 'package:e_wallet/BankPageScreen/bank_page_screen.dart';
import 'package:e_wallet/BankPageScreen/bloc/bank_page_events.dart';
import 'package:e_wallet/BankPageScreen/bloc/bank_page_states.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/models/rate.dart';
import 'package:e_wallet/rest/bank_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BankPageBloc extends Bloc<BankPageEvents, BankPageStates> {

  List<Bank> banks = [];
  List<Rate> rates = [];
  List<String> bankNames;
  OnError _event;
  int bankID;

  BankPageBloc(this._event) : super (BankPageInit());

  @override
  Stream<BankPageStates> mapEventToState(BankPageEvents event) async* {
    if (event is LoadBankPage) {
      banks = await BankRepository().getBanks((error) {
        print(error.toString());
        _event.onError(error);
      });

      yield BankPageLoaded();
    }
    if (event is ReloadBankPage) {
      yield BankPageLoaded();
    }
    if (event is LoadBankInfo) {
      rates = await BankRepository().getAvailableRates(bankID, (error) {
        print(error.toString());
        _event.onError(error);
      });
      yield BankPageLoaded();
    }
    if (event is ReloadBankInfo) {
      yield BankPageLoaded();
    }
  }

  loadBanks() {
    add(LoadBankPage());
  }

  loadBankInfo() {
    add(LoadBankInfo());
  }
}
