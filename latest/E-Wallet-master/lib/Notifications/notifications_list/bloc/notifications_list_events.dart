abstract class NotificationsListEvents extends Object {
  const NotificationsListEvents();
}

class LoadNotifications extends NotificationsListEvents {}
class ClearNotificationsList extends NotificationsListEvents {}
class ReloadNotifications extends NotificationsListEvents {}
