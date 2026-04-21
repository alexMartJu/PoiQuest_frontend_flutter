import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/providers/profile_provider.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/widgets/profile_card.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/widgets/profile_account_card.dart';
import 'package:poiquest_frontend_flutter/features/profile/presentation/widgets/profile_session_card.dart';
import 'package:poiquest_frontend_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_dialog.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:poiquest_frontend_flutter/features/gamification/presentation/widgets/gamification_stats_card.dart';
import 'package:poiquest_frontend_flutter/features/gamification/presentation/widgets/achievements_card.dart';
import 'package:poiquest_frontend_flutter/features/gamification/presentation/widgets/level_info_card.dart';

/// Página principal del perfil del usuario autenticado.
///
/// Muestra la información del perfil (avatar, nombre, nivel, bio) y las opciones
/// de configuración de la cuenta y sesión.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Cargar el perfil al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadProfile();
      ref.read(gamificationProgressProvider.notifier).loadProgress();
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await AppDialog.showConfirm(
      context,
      title: t.logoutDialogTitle,
      content: t.logoutDialogContent,
      confirmLabel: t.logout,
      cancelLabel: t.cancel,
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(authProvider.notifier).signOut();
        ref.read(profileProvider.notifier).clear();
        ref.read(gamificationProgressProvider.notifier).clear();
        if (context.mounted) {
          context.go('/events');
        }
        } catch (e) {
        if (context.mounted) {
          final t = AppLocalizations.of(context)!;
          AppSnackBar.error(context, t.logoutError(e.toString()));
        }
      }
    }
  }

  Future<void> _handleLogoutAll(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await AppDialog.showConfirm(
      context,
      title: t.logoutAllDialogTitle,
      content: t.logoutAllDialogContent,
      confirmLabel: t.logoutAllButton,
      cancelLabel: t.cancel,
      isDanger: true,
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(authProvider.notifier).signOutAll();
        ref.read(profileProvider.notifier).clear();
        ref.read(gamificationProgressProvider.notifier).clear();
        if (context.mounted) {
          context.go('/events');
        }
      } catch (e) {
        if (context.mounted) {
          final t = AppLocalizations.of(context)!;
          AppSnackBar.error(context, t.logoutAllError(e.toString()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final gamificationState = ref.watch(gamificationProgressProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: profileState.when(
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Text(t.profileLoadError),
            );
          }

          final gamification = gamificationState.value;

          return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Page title
                Text(
                  t.profileTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                // Profile Card con nivel y progreso
                ProfileCard(profile: profile, gamification: gamification),
                const SizedBox(height: 12),

                // Stats Card
                if (gamification != null) ...[
                  GamificationStatsCard(progress: gamification),
                  const SizedBox(height: 12),

                  // Achievements Card
                  AchievementsCard(progress: gamification),
                  const SizedBox(height: 12),

                  // Level Info Card
                  LevelInfoCard(currentLevel: gamification.level, levels: gamification.levels),
                  const SizedBox(height: 24),
                ],

                // Account Card
                const ProfileAccountCard(),
                const SizedBox(height: 12),

                // Session Card
                ProfileSessionCard(
                  onLogout: () => _handleLogout(context),
                  onLogoutAll: () => _handleLogoutAll(context),
                ),
              ],
            );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                t.profileLoadErrorTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              AppFilledButton(
                label: t.retry,
                onPressed: () {
                  ref.read(profileProvider.notifier).loadProfile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
