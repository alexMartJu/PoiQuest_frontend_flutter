import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_button.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';
class ButtonsDemo extends StatelessWidget {
  const ButtonsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: AppLocalizations.of(context)!.buttonsDemo,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(AppLocalizations.of(context)!.primaryButtonsTitle),
          const SizedBox(height: 8),
          AppButton(
            label: AppLocalizations.of(context)!.download,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          AppButton(
            label: AppLocalizations.of(context)!.share,
            onPressed: () {},
          ),

          const SizedBox(height: 24),

          Text(AppLocalizations.of(context)!.dangerButtonsTitle),
          const SizedBox(height: 8),
          AppButton(
            label: AppLocalizations.of(context)!.cancelTicket,
            onPressed: () {},
            variant: AppButtonVariant.danger,
          ),

          const SizedBox(height: 24),

          Text(AppLocalizations.of(context)!.disabled),
          const SizedBox(height: 8),
          AppButton(
            label: AppLocalizations.of(context)!.disabled,
            onPressed: () {},
            disabled: true,
          ),
        ],
      ),
    );
  }
}
