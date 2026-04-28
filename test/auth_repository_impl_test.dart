import 'package:fin_sage/core/errors/app_error_codes.dart';
import 'package:fin_sage/core/errors/app_exception.dart';
import 'package:fin_sage/data/repositories/impl/auth_repository_impl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  late MockGoogleSignIn googleSignIn;
  late AuthRepositoryImpl repository;

  setUp(() {
    googleSignIn = MockGoogleSignIn();
    repository = AuthRepositoryImpl(googleSignIn);
  });

  test('returns false when user cancels Google Sign-In', () async {
    when(
      () => googleSignIn.signIn(),
    ).thenThrow(const PlatformException(code: 'sign_in_canceled', message: 'User canceled'));

    final result = await repository.signInWithGoogle();

    expect(result, isFalse);
  });

  test('maps sign_in_failed code 10 into developer error app exception', () async {
    when(() => googleSignIn.signIn()).thenThrow(
      const PlatformException(
        code: 'sign_in_failed',
        message: 'I2.b: 10:',
      ),
    );

    expect(
      repository.signInWithGoogle,
      throwsA(
        isA<AppException>().having(
          (error) => error.code,
          'code',
          AppErrorCodes.googleSignInDeveloperError,
        ),
      ),
    );
  });
}
