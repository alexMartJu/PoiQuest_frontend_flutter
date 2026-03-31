import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:poiquest_frontend_flutter/app/theme/app_theme.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/utils/date_utils.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_date_picker.dart';
import 'package:poiquest_frontend_flutter/features/events/domain/entities/event.dart';
import 'package:poiquest_frontend_flutter/features/tickets/presentation/providers/tickets_providers.dart';

/// Resultado que devuelve el bottom sheet al cerrarse.
/// Si [success] es `true`, la compra fue exitosa.
/// Si [success] es `false`, [errorMessage] contiene el motivo.
/// Si el usuario cerró sin comprar, devuelve `null`.
typedef PurchaseResult = ({bool success, String? errorMessage});

/// Bottom sheet para comprar entradas de un evento.
/// Permite seleccionar fecha, cantidad y pagar con Stripe o obtener tickets gratis.
/// Devuelve un [PurchaseResult] indicando el resultado de la operación.
Future<PurchaseResult?> showPurchaseBottomSheet(BuildContext context, Event event) {
  return showModalBottomSheet<PurchaseResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _PurchaseSheet(event: event),
  );
}

class _PurchaseSheet extends ConsumerStatefulWidget {
  final Event event;

  const _PurchaseSheet({required this.event});

  @override
  ConsumerState<_PurchaseSheet> createState() => _PurchaseSheetState();
}

class _PurchaseSheetState extends ConsumerState<_PurchaseSheet> {
  DateTime? _selectedDate;
  int _quantity = 1;
  bool _isProcessing = false;

  bool get _isFreeEvent =>
      widget.event.price == null || widget.event.price == 0;

  DateTime get _firstDate {
    final start = DateTime.parse(widget.event.startDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return start.isAfter(today) ? start : today;
  }

  DateTime get _lastDate {
    if (widget.event.endDate != null) {
      return DateTime.parse(widget.event.endDate!);
    }
    return _firstDate;
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Availability provider
    final availabilityAsync = _selectedDate != null
        ? ref.watch(eventAvailabilityProvider((
            eventUuid: widget.event.uuid,
            visitDate: _formatDate(_selectedDate!),
          )))
        : null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Text(
              l10n.buyTickets,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.event.name,
              style: theme.textTheme.bodyMedium?.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: 20),

            // Date picker
            Text(
              l10n.selectDate,
              style: theme.textTheme.labelLarge?.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  _selectedDate != null
                      ? formatDateLongWithContext(context, _selectedDate!)
                      : l10n.chooseDate,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: c.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Availability info
            if (availabilityAsync != null)
              availabilityAsync.when(
                loading: () => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: c.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.checkingAvailability,
                        style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: c.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, size: 18, color: c.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            error.toString().replaceFirst('Exception: ', ''),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: c.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (availability) {
                  final isAvailable = availability.isAvailable;
                  final availableText = availability.hasCapacity
                      ? '${availability.available} ${l10n.availableEntries}'
                      : l10n.availableEntries;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? c.success.withValues(alpha: 0.08)
                            : c.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isAvailable
                                ? Icons.check_circle_outline
                                : Icons.block_outlined,
                            size: 18,
                            color: isAvailable ? c.success : c.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isAvailable
                                  ? availableText
                                  : l10n.noAvailableEntries,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isAvailable ? c.success : c.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            // Quantity selector
            Text(
              l10n.quantity,
              style: theme.textTheme.labelLarge?.copyWith(color: c.textPrimary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _QuantityButton(
                  icon: Icons.remove,
                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$_quantity',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                ),
                _QuantityButton(
                  icon: Icons.add,
                  onPressed: _quantity < 4 ? () => setState(() => _quantity++) : null,
                ),
                const Spacer(),
                if (!_isFreeEvent)
                  Text(
                    '${(widget.event.price! * _quantity).toStringAsFixed(2)} €',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: c.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.maxTicketsPerPurchase,
              style: theme.textTheme.bodySmall?.copyWith(color: c.textSecondary),
            ),
            const SizedBox(height: 20),

            // Non-refundable warning
            if (!_isFreeEvent)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: c.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: c.warning.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: c.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.nonRefundableWarning,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Buy button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _canPurchase(availabilityAsync)
                    ? _onPurchase
                    : null,
                icon: _isProcessing
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: c.onPrimary,
                        ),
                      )
                    : Icon(_isFreeEvent ? Icons.check : Icons.payment),
                label: Text(
                  _isFreeEvent ? l10n.getTickets : l10n.payNow,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Determina si se puede comprar: fecha seleccionada, no procesando, y disponibilidad OK.
  bool _canPurchase(AsyncValue<dynamic>? availabilityAsync) {
    if (_selectedDate == null || _isProcessing) return false;
    if (availabilityAsync == null) return false;
    return availabilityAsync.whenOrNull(
      data: (availability) => availability.isAvailable,
    ) ?? false;
  }

  Future<void> _pickDate() async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await AppDatePicker.show(
      context: context,
      initialDate: _selectedDate ?? _firstDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
      helpText: l10n.selectDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      // Invalidate availability for new date
      ref.invalidate(eventAvailabilityProvider);
    }
  }

  Future<void> _onPurchase() async {
    if (_selectedDate == null) return;

    setState(() => _isProcessing = true);

    final visitDate = _formatDate(_selectedDate!);

    try {
      if (_isFreeEvent) {
        await _purchaseFreeTickets(visitDate);
      } else {
        await _purchasePaidTickets(visitDate);
      }

      // Invalidate ticket lists to refresh
      ref.invalidate(activeTicketsProvider);
      ref.invalidate(usedTicketsProvider);

      if (mounted) {
        Navigator.of(context).pop<PurchaseResult>(
          (success: true, errorMessage: null),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop<PurchaseResult>(
          (success: false, errorMessage: e.toString().replaceFirst('Exception: ', '')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _purchaseFreeTickets(String visitDate) async {
    final usecase = ref.read(purchaseTicketsUseCaseProvider);
    await usecase.createFreeTickets(
      eventUuid: widget.event.uuid,
      visitDate: visitDate,
      quantity: _quantity,
    );
  }

  Future<void> _purchasePaidTickets(String visitDate) async {
    final usecase = ref.read(purchaseTicketsUseCaseProvider);
    final brightness = Theme.of(context).brightness;

    // 1. Create PaymentIntent
    final result = await usecase.createPaymentIntent(
      eventUuid: widget.event.uuid,
      visitDate: visitDate,
      quantity: _quantity,
    );

    // 2. Show Stripe Payment Sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: result.clientSecret,
        merchantDisplayName: 'PoiQuest',
        style: brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    // 3. Confirm on backend
    await usecase.confirmPayment(result.paymentIntentId);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }


}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        padding: EdgeInsets.zero,
        color: onPressed != null ? c.textPrimary : c.textSecondary.withValues(alpha: 0.4),
      ),
    );
  }
}
