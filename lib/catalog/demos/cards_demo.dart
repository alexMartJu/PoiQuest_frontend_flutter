import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
import 'package:poiquest_frontend_flutter/core/utils/date_utils.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_event_card.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_snackbar.dart';

class CardsDemo extends StatelessWidget {
  const CardsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ShowcaseScaffold(
      title: l10n.cardsDemo,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.cardsDemoTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          
          AppEventCard(
            imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30',
            title: l10n.sampleEventTitle,
            startDate: formatDateLongFromIsoWithContext(context, '2024-07-15'),
            endDate: formatDateLongFromIsoWithContext(context, '2024-07-17'),
            location: l10n.sampleEventLocation,
            onTap: () {
              AppSnackBar.info(context, l10n.eventTapped);
            },
          ),
        ],
      ),
    );
  }
}
