/// Application-wide constants for Jastar Hub Community.
class AppConstants {
  AppConstants._();

  // ─── App Info ───────────────────────────────────────────────
  static const String appName = 'Jastar Hub';
  static const String appTagline = 'Your Event Community';
  static const String appVersion = '1.0.0';

  // ─── API ────────────────────────────────────────────────────
  static const String baseUrl = 'http://localhost:3000/api';
  static const String aiServiceUrl = 'http://localhost:8000/api';
  static const String wsUrl = 'http://localhost:3000';

  // ─── Storage Keys ───────────────────────────────────────────
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String onboardingSeenKey = 'onboarding_seen';
  static const String themeKey = 'app_theme';
  static const String localeKey = 'app_locale';

  // ─── Pagination ─────────────────────────────────────────────
  static const int pageSize = 20;

  // ─── Animation Durations ────────────────────────────────────
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(milliseconds: 2500);

  // ─── Dimensions ─────────────────────────────────────────────
  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 24.0;
  static const double borderRadiusFull = 100.0;

  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;

  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 48.0;
  static const double avatarSizeLg = 64.0;
  static const double avatarSizeXl = 96.0;

  static const double eventCardHeight = 220.0;
  static const double eventCardWidth = 280.0;

  // ─── Categories ─────────────────────────────────────────────
  static const List<String> categories = [
    'technology',
    'sports',
    'music',
    'art',
    'food',
    'education',
    'business',
    'culture',
    'wellness',
    'entertainment',
  ];
}
