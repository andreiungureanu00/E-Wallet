abstract class UserNotificationsStates extends Object {
  const UserNotificationsStates();
}

class InitialState extends UserNotificationsStates {}
class PageLoaded extends UserNotificationsStates {}
class PercentageDownSet extends UserNotificationsStates {}
class PercentageDownForecastSet extends UserNotificationsStates {}