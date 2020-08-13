abstract class WalletCreateStates extends Object {
  const WalletCreateStates();
}

class WalletInit extends WalletCreateStates {}
class WalletCreated extends WalletCreateStates {}
class WalletReloaded extends WalletCreateStates {}