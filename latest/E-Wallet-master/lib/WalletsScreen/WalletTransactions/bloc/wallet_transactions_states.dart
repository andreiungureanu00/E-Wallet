abstract class WalletTransactionsStates extends Object {
  const WalletTransactionsStates();
}

class WalletTransactionsInit extends WalletTransactionsStates {}
class WalletTransactionsLoaded extends WalletTransactionsStates {}
class WalletTransactionsReloaded extends WalletTransactionsStates {}