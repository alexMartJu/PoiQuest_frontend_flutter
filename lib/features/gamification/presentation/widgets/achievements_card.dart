import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_progress_bar.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/gamification_progress.dart';
import 'package:poiquest_frontend_flutter/features/gamification/domain/entities/achievement.dart';

/// Mapa de clave de logro a icono Material.
/// Permite mostrar un icono representativo en cada chip sin necesidad de
/// persistir el dato visual en el backend. Si la clave no existe se usa [Icons.star_rounded].
const _achievementIcons = <String, IconData>{
  'scan_1': Icons.search_rounded,
  'scan_5': Icons.explore_outlined,
  'scan_15': Icons.terrain_rounded,
  'scan_30': Icons.auto_awesome_rounded,
  'route_1': Icons.map_outlined,
  'route_5': Icons.hiking_rounded,
  'route_10': Icons.emoji_events_rounded,
  'premium_1': Icons.diamond_outlined,
  'premium_attend_1': Icons.confirmation_number_outlined,
  'premium_5': Icons.workspace_premium_rounded,
  'premium_10': Icons.military_tech_rounded,
};

/// Card que muestra los logros del usuario agrupados por categoría.
///
/// Cada categoría (exploración, rutas, eventos premium) tiene su propia
/// sección [_CategorySection] con barra de progreso y fila de chips de logros.
/// El contador global `desbloqueados/total` aparece en la cabecera derecha.
///
/// Se usa en la pantalla de perfil (`ProfilePage`) dentro de la lista
/// de widgets de gamificación.
class AchievementsCard extends StatelessWidget {
  final GamificationProgress progress;

  const AchievementsCard({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final categories = _groupByCategory(progress.achievements);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.gamificationAchievements,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${progress.unlockedAchievements.length}/${progress.achievements.length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...categories.entries.map((entry) {
              return _CategorySection(
                category: entry.key,
                achievements: entry.value,
                theme: theme,
                colorScheme: colorScheme,
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Agrupa los logros por [Achievement.category] manteniendo el orden de inserción.
  /// El resultado alimenta la lista de secciones [_CategorySection] del widget.
  Map<String, List<Achievement>> _groupByCategory(List<Achievement> achievements) {
    final map = <String, List<Achievement>>{};
    for (final a in achievements) {
      map.putIfAbsent(a.category, () => []).add(a);
    }
    return map;
  }
}

/// Sección de una categoría de logros dentro de [AchievementsCard].
///
/// Estructura vertical:
/// 1. Cabecera con icono, nombre localizado de categoría y contador `desbloqueados/total`.
/// 2. Barra de progreso proporcional a logros desbloqueados ([AppProgressBar]).
/// 3. Fila de chips — uno por logro: icono + nombre + puntos otorgados.
///    Chip desbloqueado: fondo y color de categoría activos.
///    Chip bloqueado: fondo `surfaceContainerHighest`, icono y texto en `onSurfaceVariant`.
class _CategorySection extends StatelessWidget {
  final String category;
  final List<Achievement> achievements;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _CategorySection({
    required this.category,
    required this.achievements,
    required this.theme,
    required this.colorScheme,
  });

  /// Devuelve el nombre localizado de la categoría a partir de su clave de backend.
  String _categoryTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'exploration':
        return l10n.gamificationCategoryExploration;
      case 'routes':
        return l10n.gamificationCategoryRoutes;
      case 'premium_events':
        return l10n.gamificationCategoryPremiumEvents;
      default:
        return category;
    }
  }

  /// Devuelve el icono representativo de la categoría.
  IconData get _categoryIcon {
    switch (category) {
      case 'exploration':
        return Icons.explore;
      case 'routes':
        return Icons.route;
      case 'premium_events':
        return Icons.diamond;
      default:
        return Icons.star;
    }
  }

  /// Devuelve el color temático de la categoría:
  /// `exploration` → primary, `routes` → secondary, `premium_events` → tertiary.
  Color get _categoryColor {
    switch (category) {
      case 'exploration':
        return colorScheme.primary;
      case 'routes':
        return colorScheme.secondary;
      case 'premium_events':
        return colorScheme.tertiary;
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcular fracción de logros desbloqueados para la barra y el contador de cabecera.
    final unlocked = achievements.where((a) => a.unlocked).length;
    final total = achievements.length;
    final progress = total > 0 ? unlocked / total : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_categoryIcon, size: 16, color: _categoryColor),
              const SizedBox(width: 6),
              Text(
                _categoryTitle(context),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$unlocked/$total',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AppProgressBar(
            value: progress,
            minHeight: 6,
            color: _categoryColor,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: 8),
          // Chips de logros: desbloqueados con color de categoría, bloqueados en gris.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: achievements.map((a) {
              final icon = _achievementIcons[a.key] ?? Icons.star_rounded;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: a.unlocked
                      ? _categoryColor.withValues(alpha: 0.12)
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: a.unlocked
                          ? _categoryColor
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            a.name,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: a.unlocked
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (a.description != null && a.description!.isNotEmpty)
                            Text(
                              a.description!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '+${a.points}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: a.unlocked
                            ? _categoryColor
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
