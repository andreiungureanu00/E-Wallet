import 'package:e_wallet/BankPageScreen/bloc/bank_page_events.dart';
import 'package:e_wallet/BankPageScreen/bloc/bank_page_states.dart';
import 'package:e_wallet/models/bank.dart';
import 'package:e_wallet/rest/bank_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BankPageBloc extends Bloc<BankPageEvents, BankPageStates> {

  @override
  BankPageStates get initialState => BankPageInit();
  List<Bank> banks = [];

  @override
  Stream<BankPageStates> mapEventToState(BankPageEvents event) async* {
    if (event is LoadBankPage) {
      banks = await BankRepository().getBanks();
      yield BankPageLoaded();
    }
    if (event is ReloadBankPage) {
      yield BankPageLoaded();
    }
  }

  loadBanks() {
    add(LoadBankPage());
  }
}
