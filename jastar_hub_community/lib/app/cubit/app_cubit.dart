import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  final ThemeMode themeMode;
  final Locale locale;
  final bool pushNotificationsEnabled;

  const AppState({
    required this.themeMode,
    required this.locale,
    required this.pushNotificationsEnabled,
  });

  AppState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? pushNotificationsEnabled,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
    );
  }
}

class AppCubit extends Cubit<AppState> {
  static const _themeKey = 'active_theme';
  static const _langKey = 'active_lang';
  static const _notifKey = 'push_enabled';

  AppCubit()
      : super(const AppState(
          themeMode: ThemeMode.system,
          locale: Locale('ru'),
          pushNotificationsEnabled: true,
        ));

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Theme
    final themeIdx = prefs.getInt(_themeKey);
    final themeMode = themeIdx != null ? ThemeMode.values[themeIdx] : ThemeMode.system;
    
    // Load Locale
    final langCode = prefs.getString(_langKey) ?? 'ru';
    
    // Load Notifications
    final pushEnabled = prefs.getBool(_notifKey) ?? true;

    emit(state.copyWith(
      themeMode: themeMode,
      locale: Locale(langCode),
      pushNotificationsEnabled: pushEnabled,
    ));
  }

  Future<void> setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
    emit(state.copyWith(locale: Locale(langCode)));
  }

  Future<void> setPushEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifKey, enabled);
    emit(state.copyWith(pushNotificationsEnabled: enabled));
  }
}
