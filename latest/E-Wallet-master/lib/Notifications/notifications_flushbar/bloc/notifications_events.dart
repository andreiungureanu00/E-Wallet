
abstract class NotificationEvents extends Object {
  const NotificationEvents();
}

class GetNotification extends NotificationEvents {}
class ShowNotification extends NotificationEvents {}
class HideNotification extends NotificationEvents {}
class SendFCMToken extends NotificationEvents {}
class RefreshNotification extends NotificationEvents {}
