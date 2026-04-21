import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_badge.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_progress_bar.dart';
import 'package:poiquest_frontend_flutter/features/profile/domain/entities/profile.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_progress.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Card que muestra la información del perfil del usuario.
class ProfileCard extends StatelessWidget {
  final Profile profile;
  final GamificationProgress? gamification;

  const ProfileCard({
    super.key,
    required this.profile,
    this.gamification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.primary,
                  backgroundImage: profile.avatarUrl != null
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Text(
                          profile.initials,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),

                // Información del perfil
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre
                      Text(
                        profile.fullName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Bio (si existe, se muestra como subtítulo)
                      if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                        Text(
                          profile.bio!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Badge de Level con título
                      Row(
                        children: [
                          Builder(
                            builder: (context) {
                              final t = AppLocalizations.of(context)!;
                              return AppBadge(
                                label: t.level(profile.level),
                                variant: AppBadgeVariant.status,
                              );
                            },
                          ),
                          if (gamification != null && gamification!.level >= 2) ...[
                            const SizedBox(width: 8),
                            AppBadge(
                              label: gamification!.levelTitle,
                              variant: AppBadgeVariant.primary,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Barra de progreso de nivel
            if (gamification != null && gamification!.nextLevelMinPoints != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppProgressBar(
                      value: gamification!.levelProgress,
                      minHeight: 8,
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${gamification!.totalPoints}/${gamification!.nextLevelMinPoints} pts',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
