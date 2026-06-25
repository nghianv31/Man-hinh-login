enum AuthErrorType {
  accountNotExist,
  wrongPassword,
  locked,
  serverError,
}

class AuthException implements Exception {
  final AuthErrorType type;
  final String? message;

  AuthException(this.type, {this.message});

  @override
  String toString() {
    if (message != null) return message!;
    return type.toString();
  }
}
