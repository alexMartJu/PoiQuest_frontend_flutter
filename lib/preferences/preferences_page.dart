import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool _darkMode = false;
  String _language = 'es';
  bool _notifications = true;

  static const _darkKey = 'darkMode';
  static const _langKey = 'language';
  static const _notifKey = 'notifications';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool(_darkKey) ?? false;
      _language = prefs.getString(_langKey) ?? 'es';
      _notifications = prefs.getBool(_notifKey) ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, _darkMode);
    await prefs.setString(_langKey, _language);
    await prefs.setBool(_notifKey, _notifications);
  }

  void _updateDarkMode(bool value) {
    setState(() => _darkMode = value);
    _savePreferences();
  }

  void _updateLanguage(String? value) {
    if (value == null) return;
    setState(() => _language = value);
    _savePreferences();
  }

  void _updateNotifications(bool value) {
    setState(() => _notifications = value);
    _savePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferencias'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Activa o desactiva el tema oscuro'),
            value: _darkMode,
            onChanged: _updateDarkMode,
          ),
          const Divider(),
          ListTile(
            title: const Text('Idioma'),
            subtitle: const Text('Selecciona el idioma de la aplicación'),
            trailing: DropdownButton<String>(
              value: _language,
              onChanged: _updateLanguage,
              items: const [
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'en', child: Text('Inglés')),
                DropdownMenuItem(value: 'fr', child: Text('Francés')),
              ],
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Notificaciones'),
            subtitle: const Text('Recibir notificaciones importantes'),
            value: _notifications,
            onChanged: _updateNotifications,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Resumen'),
            subtitle: Text(
              'Tema: ${_darkMode ? 'Oscuro' : 'Claro'}\n'
              'Idioma: $_language\n'
              'Notificaciones: ${_notifications ? 'Activadas' : 'Desactivadas'}',
            ),
          ),
        ],
      ),
    );
  }
}
