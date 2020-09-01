
abstract class MainScreenEvent extends Object {
  const MainScreenEvent();
}

class LoadWallets extends MainScreenEvent {}
class LoadUser extends MainScreenEvent {}
class ReloadWallets extends MainScreenEvent {}
class DeleteWallet extends MainScreenEvent {}
class AddNewWallet extends MainScreenEvent {}
class UpdateWalletBalance extends MainScreenEvent {}