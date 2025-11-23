import 'package:flutter/material.dart';
import 'package:poiquest_frontend_flutter/core/l10n/app_localizations.dart';

/// Validadores reutilizables para formularios.
class Validators {
  Validators._();

  /// Valida que un campo no esté vacío.
  static String? Function(String?) required(BuildContext context, {String? fieldName}) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.isEmpty) {
        return fieldName != null ? t.validatorRequired(fieldName) : t.validatorRequiredDefault;
      }
      return null;
    };
  }

  /// Valida que un email tenga formato válido.
  static String? Function(String?) email(BuildContext context) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.isEmpty) {
        return t.validatorEmailRequired;
      }
      if (!value.contains('@')) {
        return t.validatorEmailInvalid;
      }
      return null;
    };
  }

  /// Valida que un email tenga formato válido y una longitud máxima.
  static String? Function(String?) emailWithMaxLength(BuildContext context, {int maxLength = 255}) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.isEmpty) {
        return t.validatorEmailRequired;
      }
      if (!value.contains('@')) {
        return t.validatorEmailInvalid;
      }
      if (value.length > maxLength) {
        return t.validatorEmailMaxLength(maxLength);
      }
      return null;
    };
  }

  /// Valida que una contraseña cumpla con requisitos mínimos.
  static String? Function(String?) password(BuildContext context, {int minLength = 12}) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.isEmpty) {
        return t.validatorPasswordRequired;
      }
      if (value.length < minLength) {
        return t.validatorPasswordMinLength(minLength);
      }
      return null;
    };
  }

  /// Valida que una contraseña cumpla con requisitos de seguridad.
  static String? Function(String?) strongPassword(BuildContext context, {int minLength = 12}) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.isEmpty) {
        return t.validatorPasswordRequired;
      }
      if (value.length < minLength) {
        return t.validatorPasswordMinLength(minLength);
      }
      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{12,}$').hasMatch(value)) {
        return t.validatorPasswordStrong;
      }
      return null;
    };
  }

  /// Valida que dos contraseñas coincidan.
  static String? Function(String?) confirmPassword(BuildContext context, String? originalPassword) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.isEmpty) {
        return t.validatorConfirmPasswordRequired;
      }
      if (value != originalPassword) {
        return t.validatorPasswordMismatch;
      }
      return null;
    };
  }

  /// Valida que un campo de texto tenga una longitud máxima.
  static String? Function(String?) maxLength(BuildContext context, int maxLength, {String? fieldName}) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.isEmpty) return null;
      
      if (value.length > maxLength) {
        return fieldName != null 
          ? t.validatorMaxLength(fieldName, maxLength)
          : t.validatorMaxLengthDefault(maxLength);
      }
      return null;
    };
  }

  /// Valida que el campo sea una URL válida, no esté vacío y cumpla longitud máxima.
  static String? Function(String?) url(BuildContext context, {int maxLength = 255}) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.trim().isEmpty) {
        return t.validatorRequired('URL');
      }

      final uri = Uri.tryParse(value);
      if (uri == null || !uri.hasAbsolutePath) {
        return t.validatorEmailInvalid;
      }

      if (value.length > maxLength) {
        return t.validatorMaxLength('URL', maxLength);
      }

      return null;
    };
  }

  /// Valida un nombre (requerido + longitud máxima).
  static String? Function(String?) name(BuildContext context, {int maxLength = 100}) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.isEmpty) {
        return t.validatorRequired(t.validatorNameRequired);
      }
      if (value.length > maxLength) {
        return t.validatorNameMaxLength(maxLength);
      }
      return null;
    };
  }

  /// Valida apellidos (requerido + longitud máxima).
  static String? Function(String?) lastname(BuildContext context, {int maxLength = 150}) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.isEmpty) {
        return t.validatorRequired(t.validatorLastnameRequired);
      }
      if (value.length > maxLength) {
        return t.validatorLastnameMaxLength(maxLength);
      }
      return null;
    };
  }
}
