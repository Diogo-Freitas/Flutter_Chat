import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> getCurrentUser() async => _auth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      // Realiza login com o Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Caso o login seja cancelado pelo usuário
      if (googleUser == null) return null;

      // Autenticação com Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Cria credenciais para o Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login no Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Erro no login: $e');
    }
  }
}
