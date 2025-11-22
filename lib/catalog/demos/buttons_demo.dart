import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_button.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_filled_button.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class ButtonsDemo extends StatefulWidget {
  const ButtonsDemo({super.key});

  @override
  State<ButtonsDemo> createState() => _ButtonsDemoState();
}

class _ButtonsDemoState extends State<ButtonsDemo> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return ShowcaseScaffold(
      title: l.buttonsDemo,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === AppButton (Outlined buttons) ===
          Text(
            l.primaryButtonsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: l.download,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          AppButton(
            label: l.share,
            onPressed: () {},
          ),

          const SizedBox(height: 24),

          Text(
            l.dangerButtonsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: l.cancelTicket,
            onPressed: () {},
            variant: AppButtonVariant.danger,
          ),

          const SizedBox(height: 24),

          Text(
            l.disabled,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          AppButton(
            label: l.disabled,
            onPressed: () {},
            disabled: true,
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          // === AppFilledButton ===
          Text(
            l.filledButtonsSmall,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l.withoutIcon, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppFilledButton(
              label: l.smallButton,
              onPressed: () {},
              size: AppFilledButtonSize.small,
            ),
          ),
          const SizedBox(height: 12),
          Text(l.withIcon, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppFilledButton(
              label: l.smallButton,
              icon: Icons.add,
              onPressed: () {},
              size: AppFilledButtonSize.small,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            l.filledButtonsMedium,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l.withoutIcon, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppFilledButton(
              label: l.mediumButton,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 12),
          Text(l.withIcon, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppFilledButton(
              label: l.mediumButton,
              icon: Icons.login,
              onPressed: () {},
            ),
          ),

          const SizedBox(height: 24),

          Text(
            l.filledButtonsLarge,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l.withoutIcon, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppFilledButton(
              label: l.largeButton,
              onPressed: () {},
              size: AppFilledButtonSize.large,
            ),
          ),
          const SizedBox(height: 12),
          Text(l.withIcon, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppFilledButton(
              label: l.largeButton,
              icon: Icons.download,
              onPressed: () {},
              size: AppFilledButtonSize.large,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            l.loadingState,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: AppFilledButton(
              label: l.toggleLoading,
              icon: Icons.refresh,
              onPressed: () {
                setState(() => _loading = !_loading);
              },
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: AppFilledButton(
              label: l.processing,
              onPressed: () {},
              loading: _loading,
            ),
          ),

          // (Disabled state removed for filled buttons per request)
        ],
      ),
    );
  }
}
