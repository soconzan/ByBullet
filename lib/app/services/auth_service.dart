import 'package:bybullet/app/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  static User? _currentUser;

  static User? get currentUser {
    _currentUser ??= _auth.currentUser;
    return _currentUser;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
  }

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.message;
    }
  }

  static Future<String?> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirestoreService.saveUser(credential.user!.uid, {
        'name': name,
        'uid': credential.user!.uid,
      });

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return e.message;
    } catch (e) {
      print(e);
    }
  }
}
