
abstract class WalletCreateEvents extends Object {
  const WalletCreateEvents();
}

class CreateWallet extends WalletCreateEvents {}
class RefreshWalletPage extends WalletCreateEvents {}
class LoadAvailableBanks extends WalletCreateEvents {}
class LoadAvailableCurrencies extends WalletCreateEvents {}
class GetBankID extends WalletCreateEvents {}
class GetCurrencyID extends WalletCreateEvents {}