import 'package:firebase_auth/firebase_auth.dart';
import 'logger.dart';

class AuthService {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static signUp(String email, String password, String name) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    final User user = result.user!;
    await user.updateDisplayName(name);
    logger.i("user created");
    return user;
  }

  static Future resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      throw Exception(getExceptionMessage(e));
    } catch (e) {
      throw Exception(e);
    }
  }

  static signIn(String email, String password) async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? user = result.user;

      if (user == null) {
        throw Exception("User not found");
      } else {
        logger.i('User found');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(getExceptionMessage(e));
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }
}

String getExceptionMessage(FirebaseAuthException e) {
  logger.e(e.code);
  switch (e.code) {
    case 'user-not-found':
      return 'User not found';
    case 'wrong-password':
      return 'Password is incorrect';
    case 'requires-recent-signin':
      return 'Log in again before retrying this request';
    default:
      return e.message ?? 'Error';
  }
}
