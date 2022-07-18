class CustomException implements Exception {
  String msg;
  CustomException(this.msg);

  @override
  String toString() {
    // TODO: implement toString
    return msg;
  }
}
