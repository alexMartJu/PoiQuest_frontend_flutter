import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/level_info.dart';

/// Card que lista todos los niveles de gamificación y sus recompensas.
///
/// Cada nivel aparece como una fila que muestra:
/// - Icono de estado: `check_circle` si el usuario ya lo alcanzó, círculo vacío si no.
/// - Nombre del nivel, título y puntos mínimos requeridos.
/// - Recompensa especial o porcentaje de descuento en eventos premium.
///
/// El nivel actual (`currentLevel == lvl.level`) se resalta con borde primario
/// y fondo `primaryContainer`. Los niveles ya superados aparecen en
/// `surfaceContainerHighest`; los futuros sin relleno (transparente).
///
/// Se usa en la pantalla de perfil (`ProfilePage`).
class LevelInfoCard extends StatelessWidget {
  final int currentLevel;
  final List<LevelInfo> levels;

  const LevelInfoCard({
    super.key,
    required this.currentLevel,
    required this.levels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.military_tech, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  l10n.gamificationLevelsAndRewards,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...levels.map((lvl) {
              // isActive: nivel ya alcanzado o superado. isCurrent: nivel exacto del usuario.
              final isActive = currentLevel >= lvl.level;
              final isCurrent = currentLevel == lvl.level;
              // Prioridad del texto de recompensa: texto personalizado > descuento calculado > guión vacío.
              final rewardText = lvl.reward ?? (lvl.discount > 0 ? l10n.gamificationDiscount(lvl.discount) : '—');

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? colorScheme.primaryContainer
                      : isActive
                          ? colorScheme.surfaceContainerHighest
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isCurrent
                      ? Border.all(color: colorScheme.primary, width: 1.5)
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      isActive ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 20,
                      color: isActive
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${l10n.gamificationLevelPrefix} ${lvl.level} — ${lvl.title}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                                  color: isActive
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${lvl.minPoints} pts',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rewardText,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
