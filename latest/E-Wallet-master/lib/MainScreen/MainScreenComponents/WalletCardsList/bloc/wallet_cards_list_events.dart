abstract class WalletCardsListEvents extends Object {
  const WalletCardsListEvents();
}

class LoadWallets extends WalletCardsListEvents {}
class ReloadWallets extends WalletCardsListEvents {}
class DeleteWallet extends WalletCardsListEvents {}
class AddNewWallet extends WalletCardsListEvents {}
class UpdateWalletBalance extends WalletCardsListEvents {}