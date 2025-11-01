// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titleCatalog => 'Components Catalog';

  @override
  String get buttonsDemo => 'Buttons';

  @override
  String get buttonsSubtitle => 'Variants, states and sizes';

  @override
  String get badgesDemo => 'Badges';

  @override
  String get badgesSubtitle => 'Filters, states and categories';

  @override
  String get preferences => 'Preferences';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get badgesFilterTitle => 'Filter badges';

  @override
  String get filterAll => 'All';

  @override
  String get filterMusic => 'Music';

  @override
  String get filterArt => 'Art';

  @override
  String get filterSports => 'Sports';

  @override
  String get statusTitle => 'Status';

  @override
  String get rewardTitle => 'Reward';

  @override
  String get infoTitle => 'Info';

  @override
  String get categoryTitle => 'Category';

  @override
  String get active => 'Active';

  @override
  String get reviews => 'Reviews';

  @override
  String get primaryButtonsTitle => 'Primary (Download / Share)';

  @override
  String get download => 'Download';

  @override
  String get share => 'Share';

  @override
  String get dangerButtonsTitle => 'Danger (Cancel / Delete)';

  @override
  String get cancelTicket => 'Cancel ticket';

  @override
  String get disabled => 'Disabled';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String points(num value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value points',
      one: '1 point',
      zero: '0 points',
    );
    return '$_temp0';
  }

  @override
  String get filterChipsDemo => 'Filter Chips';

  @override
  String get filterChipsSubtitle => 'Selectable filter options';

  @override
  String get filterChipsTitle => 'Filter options';
}
