import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final User? user;
  final String? errorMessage;

  const AuthResult({this.user, this.errorMessage});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in
  Future<AuthResult> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return AuthResult(user: user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(errorMessage: _getErrorMessage(e.code));
    } catch (e) {
      return const AuthResult(
        errorMessage: 'Ocorreu um erro. Tente novamente.',
      );
    }
  }

  // Sign up
  Future<AuthResult> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return AuthResult(user: user);
    } on FirebaseAuthException catch (e) {
      return AuthResult(errorMessage: _getErrorMessage(e.code));
    } catch (e) {
      return const AuthResult(
        errorMessage: 'Ocorreu um erro. Tente novamente.',
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este email já está registado. Tente iniciar sessão.';
      case 'invalid-email':
        return 'Email inválido. Verifique o formato do email.';
      case 'weak-password':
        return 'Password fraca. Use pelo menos 6 caracteres.';
      case 'user-not-found':
        return 'Utilizador não encontrado. Verifique o email.';
      case 'wrong-password':
        return 'Password incorreta. Tente novamente.';
      case 'user-disabled':
        return 'Conta desativada. Contacte o suporte.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde e tente mais tarde.';
      case 'invalid-credential':
        return 'Credenciais inválidas. Verifique os dados.';
      case 'operation-not-allowed':
        return 'Método de autenticação não permitido.';
      case 'network-request-failed':
        return 'Sem ligação à internet. Verifique a sua rede.';
      case 'internal-error':
        return 'Erro interno. Tente novamente mais tarde.';
      case 'api-key-not-valid':
        return 'Configuração inválida da API. Verifique o projeto.';
      default:
        return 'Ocorreu um erro. Tente novamente.';
    }
  }
}