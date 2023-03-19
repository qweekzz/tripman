import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripman/authentication/authentication_sercive.dart';
import 'package:tripman/models/user_model.dart';

class AuthenticationRepository {
  AuthService service = AuthService();

  Stream<Users> getCurrentUser() {
    return service.retrieveCurrentUser();
  }

  Future<UserCredential?> signUp(Users user) {
    try {
      return service.signUp(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<UserCredential?> signIn(Users user) {
    try {
      return service.signIn(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<UserCredential?> verifyPhoneNumber(Users user) {
    try {
      return service.verifyPhoneNumber(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<UserCredential?> verifyPhoneNumber2(Users user, String test) {
    try {
      return service.verifyPhoneNumber2(user, test);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> signOut() {
    return service.signOut();
  }
}
