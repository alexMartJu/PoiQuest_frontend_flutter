import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/catalog/widgets/showcase_scaffold.dart';
import 'package:poiquest_frontend_flutter/core/widgets/app_text_field.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

class TextFieldsDemo extends StatefulWidget {
  const TextFieldsDemo({super.key});

  @override
  State<TextFieldsDemo> createState() => _TextFieldsDemoState();
}

class _TextFieldsDemoState extends State<TextFieldsDemo> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return ShowcaseScaffold(
      title: l.textFieldsDemo,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.textFieldsTextVariantTitle),
          const SizedBox(height: 8),
          AppTextField(
            labelText: l.textFieldsNameLabel,
            hintText: l.textFieldsNameHint,
            prefixIcon: Icons.person_outline,
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          AppTextField(
            labelText: l.textFieldsNameLabel,
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
          ),

          const SizedBox(height: 24),

          Text(l.textFieldsEmailVariantTitle),
          const SizedBox(height: 8),
          AppTextField(
            labelText: l.textFieldsEmailLabel,
            hintText: l.textFieldsEmailHint,
            prefixIcon: Icons.email_outlined,
            variant: AppTextFieldVariant.email,
            controller: _emailCtrl,
          ),
          const SizedBox(height: 12),
          AppTextField(
            labelText: l.textFieldsEmailLabel,
            variant: AppTextFieldVariant.email,
            controller: _emailCtrl,
          ),

          const SizedBox(height: 24),

          Text(l.textFieldsPasswordVariantTitle),
          const SizedBox(height: 8),
          AppTextField(
            labelText: l.textFieldsPasswordLabel,
            prefixIcon: Icons.lock_outline,
            variant: AppTextFieldVariant.password,
            controller: _passwordCtrl,
          ),
          const SizedBox(height: 12),
          AppTextField(
            labelText: l.textFieldsPasswordLabel,
            variant: AppTextFieldVariant.password,
            controller: _passwordCtrl,
          ),

          const SizedBox(height: 24),

          Text(l.textFieldsDisabledTitle),
          const SizedBox(height: 8),
          AppTextField(
            labelText: l.textFieldsNameLabel,
            prefixIcon: Icons.person_outline,
            enabled: false,
          ),
        ],
      ),
    );
  }
}
