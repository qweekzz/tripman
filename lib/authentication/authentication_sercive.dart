import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripman/models/user_model.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _verificationId = '';

  Stream<Users> retrieveCurrentUser() {
    return auth.authStateChanges().map((User? user) {
      if (user != null) {
        return Users(uid: user.uid, email: user.email);
      } else {
        return Users(uid: '');
      }
    });
  }

  Future<UserCredential?> signUp(Users user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<UserCredential?> signIn(Users user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.email!, password: user.password!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<UserCredential?> verifyPhoneNumber(Users user) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: user.phone,
      // phoneNumber: '+79824453885',
      //нужно сделать отдельно приход смс и ввод кода
      //попробывать разделить част этой штуки
      // до зватра )
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('verificationCompleted');
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('verificationFailed');
        if (e.code == 'invalid-phone-number') {
          print('verificationFailed сработал!.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // String smsCode = 'xxxx';
        print('codeSentTest ${verificationId}');
        _verificationId = verificationId;
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: user.smsCode ?? '0');

        print('codeSent ${credential.smsCode}');
        print('codeSent1 ${_verificationId}');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    return null;
  }

  Future<UserCredential?> verifyPhoneNumber2(Users user, String test) async {
    try {
      print('!!!!!!!!! ${test}');
      print('!! $_verificationId');

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationId, smsCode: test));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
