import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_button.dart';

class ButtonsDemo extends StatelessWidget {
  const ButtonsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: 'Botones',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Primary (Download / Share)'),
          const SizedBox(height: 8),
          AppButton(
            label: 'Download', 
            onPressed: () {}
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Share', 
            onPressed: () {}
          ),

          const SizedBox(height: 24),
          const Text('Danger (Cancel / Delete)'),
          const SizedBox(height: 8),
          AppButton(
            label: 'Cancel Ticket',
            onPressed: () {},
            variant: AppButtonVariant.danger,
          ),

          const SizedBox(height: 24),
          const Text('Disabled'),
          const SizedBox(height: 8),
          AppButton(
            label: 'Disabled',
            onPressed: () {},
            disabled: true,
          ),
        ],
      ),
    );
  }
}

