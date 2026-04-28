import 'package:fin_sage/core/errors/app_error_codes.dart';
import 'package:fin_sage/core/errors/app_exception.dart';
import 'package:fin_sage/data/repositories/auth_repository.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._googleSignIn);

  final GoogleSignIn _googleSignIn;

  @override
  Future<bool> isSignedIn() async {
    if (_googleSignIn.currentUser != null) {
      return true;
    }
    final account = await _googleSignIn.signInSilently();
    return account != null;
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      return account != null;
    } on PlatformException catch (error) {
      if (_isSignInCancelled(error)) {
        return false;
      }
      if (_isDeveloperError(error)) {
        throw const AppException(
          'Google Sign-In developer configuration is invalid',
          code: AppErrorCodes.googleSignInDeveloperError,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (_) {
      // Ignore disconnect errors and continue sign-out.
    }
    await _googleSignIn.signOut();
  }

  bool _isSignInCancelled(PlatformException error) {
    final code = error.code.toLowerCase();
    return code == 'sign_in_canceled' || code == 'sign_in_cancelled';
  }

  bool _isDeveloperError(PlatformException error) {
    if (error.code.toLowerCase() != 'sign_in_failed') {
      return false;
    }
    final message = '${error.message ?? ''} ${error.details ?? ''}';
    return message.contains(': 10') || message.contains('10:');
  }
}
