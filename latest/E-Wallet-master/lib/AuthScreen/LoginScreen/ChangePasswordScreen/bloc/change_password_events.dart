
abstract class ChangePasswordEvents extends Object {
  const ChangePasswordEvents();
}

class LoadFirstStep extends ChangePasswordEvents {}
class LoadPage extends ChangePasswordEvents {}
class LoadSecondStep extends ChangePasswordEvents {}
class ReloadPage extends ChangePasswordEvents {}
class ResetPassword extends ChangePasswordEvents {}
class ChangePassword extends ChangePasswordEvents {}
