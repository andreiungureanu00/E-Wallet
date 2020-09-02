abstract class UserNotificationsEvents extends Object {
  const UserNotificationsEvents();
}

class InitPage extends UserNotificationsEvents {}
class ReloadPage extends UserNotificationsEvents {}
class SetPercentageDown extends UserNotificationsEvents {}
class SetPercentageDownForecast extends UserNotificationsEvents {}