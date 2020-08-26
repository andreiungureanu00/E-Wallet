
abstract class ChangePasswordEvents extends Object {
  const ChangePasswordEvents();
}

class LoadFirstStep extends ChangePasswordEvents {}
class LoadPage extends ChangePasswordEvents {}
class LoadSecondStep extends ChangePasswordEvents {}
class Reload extends ChangePasswordEvents {}
