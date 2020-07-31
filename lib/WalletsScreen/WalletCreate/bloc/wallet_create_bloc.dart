
import 'package:e_wallet/WalletsScreen/WalletCreate/bloc/wallet_create_events.dart';
import 'package:e_wallet/WalletsScreen/WalletCreate/bloc/wallet_create_states.dart';
import 'package:e_wallet/rest/wallets_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletCreateBloc extends Bloc<WalletCreateEvents, WalletCreateStates> {
  String currencyName;
  int currencyID;

  @override
  WalletCreateStates get initialState => WalletInit();

  @override
  Stream<WalletCreateStates> mapEventToState(WalletCreateEvents event) async* {
    if (event is CreateWallet) {
      WalletsRepository().createWallet(currencyID);
      yield WalletCreated();
    }
    if (event is ReloadWallet) {
      yield WalletCreated();
    }
  }

  createWallet() {
    add(CreateWallet());
  }
}
