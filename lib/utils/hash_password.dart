import 'package:bcrypt/bcrypt.dart';

class HashPassword {
  static String hash(String password){
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }
  static bool checkHash(String password, String hashPassword){
    return BCrypt.checkpw(password, hashPassword);
  }

}