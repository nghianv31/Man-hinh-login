// import 'package:flutter_test/flutter_test.dart';
// import 'package:bt1/utils/hash_password.dart';

// void main() {
//   test('Hash a password and print the result', () {
//     String inputPassword = "123456";
    
//     // Hash the password
//     String hashedPassword = HashPassword.hash(inputPassword);
    
//     // Print the result so you can see it
//     print("--------------------------------------------------");
//     print("Input Password: $inputPassword");
//     print("Hashed Output: $hashedPassword");
//     print("--------------------------------------------------");

//     // Verify the hash works correctly
//     bool isMatch = HashPassword.checkHash(inputPassword, hashedPassword);
//     expect(isMatch, isTrue, reason: "The checked hash should match the original password");
    
//     // Verify that a wrong password does not match
//     bool isMatchWrong = HashPassword.checkHash("wrongPassword", hashedPassword);
//     expect(isMatchWrong, isFalse, reason: "A different password should not match the hash");
//   });
// }
