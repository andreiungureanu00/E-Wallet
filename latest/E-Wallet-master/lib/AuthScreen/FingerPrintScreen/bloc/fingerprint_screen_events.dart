
abstract class FingerPrintScreenEvents extends Object {
  const FingerPrintScreenEvents();
}

class TakeFingerPrint extends FingerPrintScreenEvents {}
class GetUser extends FingerPrintScreenEvents {}
class ReloadFingerPrintScreen extends FingerPrintScreenEvents {}
class LoadFingerPrintScreen extends FingerPrintScreenEvents {}