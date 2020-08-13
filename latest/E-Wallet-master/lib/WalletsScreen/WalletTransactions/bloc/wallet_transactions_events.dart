
abstract class WalletTransactionsEvents extends Object {
  const WalletTransactionsEvents();
}

class LoadWalletTransactions extends WalletTransactionsEvents {}
class ReloadWalletTransactions extends WalletTransactionsEvents {}
class AddTransaction extends WalletTransactionsEvents {}
class UpdateWallet extends WalletTransactionsEvents {}
class ClearHistory extends WalletTransactionsEvents {}