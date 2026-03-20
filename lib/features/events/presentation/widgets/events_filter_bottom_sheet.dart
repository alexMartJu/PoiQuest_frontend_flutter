import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_date_picker.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_slider.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filter_chip.dart';
import 'package:poiquest_frontend_flutter/features/events/presentation/providers/events_providers.dart';

/// Bottom sheet draggable con filtros de eventos: fechas, ciudades y rango de precios.
///
/// Se muestra como un `DraggableScrollableSheet` para una experiencia
/// fluida y "impresionante" en dispositivos móviles.
/// Los filtros se aplican a través del `eventFiltersProvider`.
class EventsFilterBottomSheet extends ConsumerStatefulWidget {
  const EventsFilterBottomSheet({super.key});

  /// Muestra el bottom sheet de filtros
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EventsFilterBottomSheet(),
    );
  }

  @override
  ConsumerState<EventsFilterBottomSheet> createState() =>
      _EventsFilterBottomSheetState();
}

class _EventsFilterBottomSheetState
    extends ConsumerState<EventsFilterBottomSheet> {
  // Estado local de los filtros (se aplican al pulsar "Aplicar")
  String? _cityUuid;
  String? _cityName;
  double? _minPrice;
  double? _maxPrice;
  String? _startDate;
  String? _endDate;

  @override
  void initState() {
    super.initState();
    // Inicializar con los filtros actuales
    final filters = ref.read(eventFiltersProvider);
    _cityUuid = filters.cityUuid;
    _cityName = filters.cityName;
    _minPrice = filters.minPrice;
    _maxPrice = filters.maxPrice;
    _startDate = filters.startDate;
    _endDate = filters.endDate;
  }

  bool get _hasLocalFilters =>
      _cityUuid != null ||
      _minPrice != null ||
      _maxPrice != null ||
      _startDate != null ||
      _endDate != null;

  void _clearLocalFilters() {
    setState(() {
      _cityUuid = null;
      _cityName = null;
      _minPrice = null;
      _maxPrice = null;
      _startDate = null;
      _endDate = null;
    });
  }

  void _applyFilters() {
    final notifier = ref.read(eventFiltersProvider.notifier);
    notifier.setCity(_cityUuid, _cityName);
    notifier.setPriceRange(_minPrice, _maxPrice);
    notifier.setDateRange(_startDate, _endDate);

    // Recargar eventos con los nuevos filtros
    final selectedCategory = ref.read(selectedCategoryProvider);
    ref.read(eventsNotifierProvider.notifier).loadEvents(selectedCategory?.uuid);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle de arrastre
              _buildDragHandle(colorScheme),

              // Header con título y botón limpiar
              _buildHeader(theme, colorScheme, l10n),

              const Divider(height: 1),

              // Contenido scrollable con los filtros
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  children: [
                    // Sección de rango de fechas
                    _buildDateSection(theme, colorScheme, l10n),

                    const SizedBox(height: 28),

                    // Sección de rango de precios
                    _buildPriceSection(theme, colorScheme, l10n),

                    const SizedBox(height: 28),

                    // Sección de ciudades
                    _buildCitySection(theme, colorScheme, l10n),

                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Botón aplicar fijo en la parte inferior
              _buildApplyButton(colorScheme, l10n),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 8, 12),
      child: Row(
        children: [
          Icon(
            Icons.tune_rounded,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            l10n.filters,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          if (_hasLocalFilters)
            TextButton.icon(
              onPressed: _clearLocalFilters,
              icon: const Icon(Icons.clear_all_rounded, size: 18),
              label: Text(l10n.clearFilters),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.error,
                textStyle: theme.textTheme.labelMedium,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Sección de Fechas ───

  Widget _buildDateSection(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, colorScheme, Icons.date_range_rounded, l10n.dateRange),
        Row(
          children: [
            Expanded(
              child: _buildDateChip(
                context: context,
                label: _startDate != null
                    ? _formatDateShort(_startDate!)
                    : l10n.fromDate,
                isActive: _startDate != null,
                colorScheme: colorScheme,
                theme: theme,
                onTap: () async {
                  final date = await AppDatePicker.show(
                    context: context,
                    helpText: l10n.fromDate,
                    firstDate: DateTime(2024),
                    initialDate: _startDate != null
                        ? DateTime.tryParse(_startDate!)
                        : null,
                  );
                  if (date != null) {
                    setState(() => _startDate = date.toIso8601String());
                  }
                },
                onClear: _startDate != null
                    ? () => setState(() => _startDate = null)
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: _buildDateChip(
                context: context,
                label: _endDate != null
                    ? _formatDateShort(_endDate!)
                    : l10n.toDate,
                isActive: _endDate != null,
                colorScheme: colorScheme,
                theme: theme,
                onTap: () async {
                  final date = await AppDatePicker.show(
                    context: context,
                    helpText: l10n.toDate,
                    firstDate: _startDate != null
                        ? DateTime.tryParse(_startDate!)
                        : DateTime(2024),
                    initialDate: _endDate != null
                        ? DateTime.tryParse(_endDate!)
                        : null,
                  );
                  if (date != null) {
                    setState(() => _endDate = date.toIso8601String());
                  }
                },
                onClear: _endDate != null
                    ? () => setState(() => _endDate = null)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateChip({
    required BuildContext context,
    required String label,
    required bool isActive,
    required ColorScheme colorScheme,
    required ThemeData theme,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return Material(
      color: isActive
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: isActive
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isActive
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Sección de Precios ───

  Widget _buildPriceSection(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final priceRangeAsync = ref.watch(priceRangeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          theme,
          colorScheme,
          Icons.euro_rounded,
          l10n.priceRange,
        ),
        priceRangeAsync.when(
          data: (range) {
            // Si min == max no tiene sentido el slider
            if (range.min >= range.max) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.noPriceRange,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            final effectiveMin = _minPrice ?? range.min;
            final effectiveMax = _maxPrice ?? range.max;

            return Column(
              children: [
                // Etiquetas de precio actuales
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriceLabel(
                        theme,
                        colorScheme,
                        '${effectiveMin.toStringAsFixed(0)}€',
                        isActive: _minPrice != null,
                      ),
                      _buildPriceLabel(
                        theme,
                        colorScheme,
                        '${effectiveMax.toStringAsFixed(0)}€',
                        isActive: _maxPrice != null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                AppRangeSlider(
                  min: range.min,
                  max: range.max,
                  currentMin: effectiveMin.clamp(range.min, range.max),
                  currentMax: effectiveMax.clamp(range.min, range.max),
                  onChanged: (values) {
                    setState(() {
                      // Solo setear si difiere del rango completo
                      _minPrice = values.start > range.min ? values.start : null;
                      _maxPrice = values.end < range.max ? values.end : null;
                    });
                  },
                  formatLabel: (v) => '${v.toStringAsFixed(0)}€',
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.errorLoadingPriceRange,
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceLabel(
    ThemeData theme,
    ColorScheme colorScheme,
    String text, {
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: isActive
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  // ─── Sección de Ciudades ───

  Widget _buildCitySection(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final citiesAsync = ref.watch(citiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          theme,
          colorScheme,
          Icons.location_city_rounded,
          l10n.selectCity,
        ),
        citiesAsync.when(
          data: (cities) {
            if (cities.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.noCitiesAvailable,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: cities.map((city) {
                final isSelected = _cityUuid == city.uuid;
                return AppFilterChip(
                  label: city.name,
                  selected: isSelected,
                  onSelected: () {
                    setState(() {
                      if (isSelected) {
                        _cityUuid = null;
                        _cityName = null;
                      } else {
                        _cityUuid = city.uuid;
                        _cityName = city.name;
                      }
                    });
                  },
                );
              }).toList(),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.noCitiesAvailable,
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Botón Aplicar ───

  Widget _buildApplyButton(ColorScheme colorScheme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: AppFilledButton(
          label: l10n.applyFilters,
          onPressed: _applyFilters,
          icon: Icons.check_rounded,
          size: AppFilledButtonSize.large,
        ),
      ),
    );
  }

  // ─── Utilidades ───

  String _formatDateShort(String isoDate) {
    final date = DateTime.tryParse(isoDate);
    if (date == null) return isoDate;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
