import 'package:fin_sage/core/constants/lottie_placeholders.dart';
import 'package:fin_sage/core/constants/google_auth_config.dart';
import 'package:fin_sage/core/errors/app_error_codes.dart';
import 'package:fin_sage/core/errors/error_boundary.dart';
import 'package:fin_sage/core/errors/error_localizer.dart';
import 'package:fin_sage/core/widgets/haptic_button.dart';
import 'package:fin_sage/core/widgets/loading_skeleton.dart';
import 'package:fin_sage/l10n/generated/app_localizations.dart';
import 'package:fin_sage/logic/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ErrorBoundary(
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final canSignIn = GoogleAuthConfig.hasServerClientId;
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.appTitle, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    Lottie.asset(
                      LottiePlaceholders.successAnimation,
                      height: 160,
                      repeat: true,
                    ),
                    const SizedBox(height: 24),
                    if (state.status == AuthStatus.loading) ...[
                      const LoadingSkeleton(height: 50),
                    ] else ...[
                      HapticButton(
                        label: l10n.signInGoogle,
                        icon: Icons.login,
                        onPressed: canSignIn ? () => context.read<AuthCubit>().signIn() : null,
                      ),
                    ],
                    if (!canSignIn) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.googleSignInConfigMissing,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    if (state.status == AuthStatus.error && state.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        localizeErrorMessage(l10n, state.errorMessage!),
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    if (state.errorMessage == AppErrorCodes.googleSignInDeveloperError) ...[
                      const SizedBox(height: 16),
                      _GoogleSignInDiagnostics(
                        packageName: GoogleAuthConfig.androidApplicationIdOrNull ?? '-',
                        hasServerClientId: GoogleAuthConfig.hasServerClientId,
                        hasClientId: GoogleAuthConfig.hasClientId,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInDiagnostics extends StatelessWidget {
  const _GoogleSignInDiagnostics({
    required this.packageName,
    required this.hasServerClientId,
    required this.hasClientId,
  });

  final String packageName;
  final bool hasServerClientId;
  final bool hasClientId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final yesNo = (bool value) => value ? l10n.configuredYes : l10n.configuredNo;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.googleSignInTroubleshootTitle, style: textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              l10n.googleSignInTroubleshootHint,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text('${l10n.androidApplicationIdLabel}: $packageName', style: textTheme.bodySmall),
            Text(
              '${l10n.serverClientIdConfiguredLabel}: ${yesNo(hasServerClientId)}',
              style: textTheme.bodySmall,
            ),
            Text(
              '${l10n.clientIdConfiguredLabel}: ${yesNo(hasClientId)}',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
