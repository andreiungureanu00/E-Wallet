
abstract class MainScreenEvent extends Object {
  const MainScreenEvent();
}

class LoadWallets extends MainScreenEvent {}
class ReloadWallets extends MainScreenEvent {}
class DeleteWallet extends MainScreenEvent {}