class SessionLogin {
  final String userId;
  final String logginAt;

  SessionLogin({
    required this.userId,
    required this.logginAt,
  });

  Map<String, String> toMap(){
    return {
      'userId':userId,
      'logginAt': logginAt
    };
  }
}