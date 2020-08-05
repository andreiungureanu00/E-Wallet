class ExceptionsSingleton {
  static final ExceptionsSingleton _singleton =
      new ExceptionsSingleton._internal();

  factory ExceptionsSingleton() {
    return _singleton;
  }

  ExceptionsSingleton._internal();

  int errorCode = 0;
  String errorMesage = " ";

  setErrorCode(int errorCode) {
    this.errorCode = errorCode;
  }

  getErrorCode() {
    return errorCode;
  }

  setErrorMessage(String errorMessage) {
    this.errorMesage = errorMesage;
  }

  getErrorMessage() {
    return errorMesage;
  }
}
