import 'package:equatable/equatable.dart';

class Preferences extends Equatable {
  static const darkModeConst = 'DARKMODE';
  static const languageConst = 'LANGUAGE';
  static const notificationsConst = 'NOTIFICATIONS';

  final bool darkmode;
  final String language;
  final bool notifications;

  const Preferences({
    required this.darkmode,
    required this.language,
    required this.notifications,
  });

  Preferences copyWith({
    bool? darkmode,
    String? language,
    bool? notifications,
  }) =>
      Preferences(
        darkmode: darkmode ?? this.darkmode,
        language: language ?? this.language,
        notifications: notifications ?? this.notifications,
      );

  @override
  List<Object?> get props => [darkmode, language, notifications];
}
