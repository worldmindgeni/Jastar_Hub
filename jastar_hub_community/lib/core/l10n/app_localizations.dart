import 'package:flutter/material.dart';

/// Custom localization system supporting EN, RU, KK (Kazakh).
/// Auto-detects device locale and falls back to English.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('kk'),
  ];

  // ─── Translations Map ───────────────────────────────────────
  static final Map<String, Map<String, String>> _translations = {
    'en': {
      // General
      'app_name': 'Jastar Hub',
      'app_tagline': 'Your Event Community',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'confirm': 'Confirm',
      'search': 'Search...',
      'see_all': 'See All',
      'no_data': 'No data available',

      // Auth
      'welcome_back': 'Welcome Back!',
      'sign_in_subtitle': 'Sign in to continue your journey',
      'create_account': 'Create Account',
      'register_subtitle': 'Join our vibrant community',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': "Don't have an account? ",
      'already_have_account': 'Already have an account? ',
      'sign_up_link': 'Sign Up',
      'sign_in_link': 'Sign In',
      'forgot_password_title': 'Reset Password',
      'forgot_password_subtitle':
          'Enter your email and we\'ll send you a reset link',
      'send_reset_link': 'Send Reset Link',
      'back_to_login': 'Back to Login',
      'reset_link_sent': 'Reset link sent! Check your email.',
      'logout': 'Logout',

      // Validation
      'email_required': 'Email is required',
      'email_invalid': 'Enter a valid email',
      'password_required': 'Password is required',
      'password_too_short': 'Password must be at least 6 characters',
      'passwords_dont_match': 'Passwords don\'t match',
      'name_required': 'Name is required',

      // Onboarding
      'onboarding_title_1': 'Discover Events',
      'onboarding_desc_1':
          'Find exciting events happening near you. From tech meetups to cultural festivals.',
      'onboarding_title_2': 'Connect & Share',
      'onboarding_desc_2':
          'Meet like-minded people, chat in real-time, and build your community.',
      'onboarding_title_3': 'Smart Recommendations',
      'onboarding_desc_3':
          'AI-powered suggestions tailored to your interests. Never miss an event you\'d love.',
      'skip': 'Skip',
      'next': 'Next',
      'get_started': 'Get Started',

      // Home
      'home_greeting': 'Hello',
      'recommended_for_you': 'Recommended for You',
      'trending_now': 'Trending Now',
      'nearby_events': 'Nearby Events',
      'categories': 'Categories',
      'popular_events': 'Popular Events',

      // Events
      'events': 'Events',
      'event_details': 'Event Details',
      'join_event': 'Join Event',
      'leave_event': 'Leave Event',
      'add_to_favorites': 'Add to Favorites',
      'share_event': 'Share Event',
      'free': 'Free',
      'paid': 'Paid',
      'attendees': 'attendees',
      'organizer': 'Organizer',
      'date_and_time': 'Date & Time',
      'location': 'Location',

      // Categories
      'technology': 'Technology',
      'sports': 'Sports',
      'music': 'Music',
      'art': 'Art',
      'food': 'Food',
      'education': 'Education',
      'business': 'Business',
      'culture': 'Culture',
      'wellness': 'Wellness',
      'entertainment': 'Entertainment',

      // Navigation
      'nav_home': 'Home',
      'nav_events': 'Events',
      'nav_map': 'Map',
      'nav_chat': 'Chat',
      'nav_profile': 'Profile',

      // Profile
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'my_events': 'My Events',
      'favorites': 'Favorites',
      'settings': 'Settings',
      'interests': 'Interests',

      // Chat
      'chat': 'Chat',
      'type_message': 'Type a message...',
      'no_messages': 'No messages yet',

      // Map
      'map': 'Map',
      'events_nearby': 'Events Nearby',

      // Notifications
      'notifications': 'Notifications',
      'notifications_title': 'Notifications',
      'no_notifications': 'No notifications yet',
      'mark_all_read': 'Read all',
    },
    'ru': {
      // General
      'app_name': 'Jastar Hub',
      'app_tagline': 'Ваше сообщество мероприятий',
      'loading': 'Загрузка...',
      'error': 'Ошибка',
      'retry': 'Повторить',
      'cancel': 'Отмена',
      'save': 'Сохранить',
      'delete': 'Удалить',
      'confirm': 'Подтвердить',
      'search': 'Поиск...',
      'see_all': 'Все',
      'no_data': 'Нет данных',

      // Auth
      'welcome_back': 'С возвращением!',
      'sign_in_subtitle': 'Войдите, чтобы продолжить',
      'create_account': 'Создать аккаунт',
      'register_subtitle': 'Присоединяйтесь к нашему сообществу',
      'email': 'Электронная почта',
      'password': 'Пароль',
      'confirm_password': 'Подтвердите пароль',
      'full_name': 'Полное имя',
      'sign_in': 'Войти',
      'sign_up': 'Регистрация',
      'forgot_password': 'Забыли пароль?',
      'dont_have_account': 'Нет аккаунта? ',
      'already_have_account': 'Уже есть аккаунт? ',
      'sign_up_link': 'Регистрация',
      'sign_in_link': 'Войти',
      'forgot_password_title': 'Сброс пароля',
      'forgot_password_subtitle':
          'Введите email и мы отправим ссылку для сброса',
      'send_reset_link': 'Отправить ссылку',
      'back_to_login': 'Назад к входу',
      'reset_link_sent': 'Ссылка отправлена! Проверьте почту.',
      'logout': 'Выйти',

      // Validation
      'email_required': 'Введите email',
      'email_invalid': 'Введите корректный email',
      'password_required': 'Введите пароль',
      'password_too_short': 'Пароль должен быть не менее 6 символов',
      'passwords_dont_match': 'Пароли не совпадают',
      'name_required': 'Введите имя',

      // Onboarding
      'onboarding_title_1': 'Открывайте события',
      'onboarding_desc_1':
          'Находите интересные мероприятия рядом с вами. От IT-митапов до культурных фестивалей.',
      'onboarding_title_2': 'Общайтесь и делитесь',
      'onboarding_desc_2':
          'Знакомьтесь с единомышленниками, общайтесь в реальном времени.',
      'onboarding_title_3': 'Умные рекомендации',
      'onboarding_desc_3':
          'ИИ-рекомендации на основе ваших интересов. Не пропустите ни одного события.',
      'skip': 'Пропустить',
      'next': 'Далее',
      'get_started': 'Начать',

      // Home
      'home_greeting': 'Привет',
      'recommended_for_you': 'Рекомендации для вас',
      'trending_now': 'Популярное сейчас',
      'nearby_events': 'Рядом с вами',
      'categories': 'Категории',
      'popular_events': 'Популярные события',

      // Events
      'events': 'События',
      'event_details': 'Подробности события',
      'join_event': 'Участвовать',
      'leave_event': 'Отменить участие',
      'add_to_favorites': 'В избранное',
      'share_event': 'Поделиться',
      'free': 'Бесплатно',
      'paid': 'Платно',
      'attendees': 'участников',
      'organizer': 'Организатор',
      'date_and_time': 'Дата и время',
      'location': 'Место',

      // Categories
      'technology': 'Технологии',
      'sports': 'Спорт',
      'music': 'Музыка',
      'art': 'Искусство',
      'food': 'Еда',
      'education': 'Образование',
      'business': 'Бизнес',
      'culture': 'Культура',
      'wellness': 'Здоровье',
      'entertainment': 'Развлечения',

      // Navigation
      'nav_home': 'Главная',
      'nav_events': 'События',
      'nav_map': 'Карта',
      'nav_chat': 'Чат',
      'nav_profile': 'Профиль',

      // Profile
      'profile': 'Профиль',
      'edit_profile': 'Редактировать',
      'my_events': 'Мои события',
      'favorites': 'Избранное',
      'settings': 'Настройки',
      'interests': 'Интересы',

      // Chat
      'chat': 'Чат',
      'type_message': 'Напишите сообщение...',
      'no_messages': 'Нет сообщений',

      // Map
      'map': 'Карта',
      'events_nearby': 'События рядом',

      // Notifications
      'notifications': 'Уведомления',
      'notifications_title': 'Уведомления',
      'no_notifications': 'Уведомлений пока нет',
      'mark_all_read': 'Прочитать все',
    },
    'kk': {
      // General
      'app_name': 'Jastar Hub',
      'app_tagline': 'Сіздің іс-шаралар қоғамдастығыңыз',
      'loading': 'Жүктелуде...',
      'error': 'Қате',
      'retry': 'Қайталау',
      'cancel': 'Бас тарту',
      'save': 'Сақтау',
      'delete': 'Жою',
      'confirm': 'Растау',
      'search': 'Іздеу...',
      'see_all': 'Барлығы',
      'no_data': 'Деректер жоқ',

      // Auth
      'welcome_back': 'Қайта келуіңізбен!',
      'sign_in_subtitle': 'Жалғастыру үшін кіріңіз',
      'create_account': 'Аккаунт құру',
      'register_subtitle': 'Біздің қоғамдастыққа қосылыңыз',
      'email': 'Электрондық пошта',
      'password': 'Құпия сөз',
      'confirm_password': 'Құпия сөзді растаңыз',
      'full_name': 'Толық аты',
      'sign_in': 'Кіру',
      'sign_up': 'Тіркелу',
      'forgot_password': 'Құпия сөзді ұмыттыңыз ба?',
      'dont_have_account': 'Аккаунтыңыз жоқ па? ',
      'already_have_account': 'Аккаунтыңыз бар ма? ',
      'sign_up_link': 'Тіркелу',
      'sign_in_link': 'Кіру',
      'forgot_password_title': 'Құпия сөзді қалпына келтіру',
      'forgot_password_subtitle':
          'Email енгізіңіз, біз қалпына келтіру сілтемесін жібереміз',
      'send_reset_link': 'Сілтеме жіберу',
      'back_to_login': 'Кіруге оралу',
      'reset_link_sent': 'Сілтеме жіберілді! Поштаңызды тексеріңіз.',
      'logout': 'Шығу',

      // Validation
      'email_required': 'Email енгізіңіз',
      'email_invalid': 'Дұрыс email енгізіңіз',
      'password_required': 'Құпия сөзді енгізіңіз',
      'password_too_short': 'Құпия сөз кемінде 6 таңба болуы керек',
      'passwords_dont_match': 'Құпия сөздер сәйкес келмейді',
      'name_required': 'Атыңызды енгізіңіз',

      // Onboarding
      'onboarding_title_1': 'Іс-шараларды ашыңыз',
      'onboarding_desc_1':
          'Жаныңыздағы қызықты оқиғаларды табыңыз. IT-кездесулерден мәдени фестивальдерге дейін.',
      'onboarding_title_2': 'Қарым-қатынас жасаңыз',
      'onboarding_desc_2':
          'Пікірлес адамдармен танысыңыз, нақты уақытта сөйлесіңіз.',
      'onboarding_title_3': 'Ақылды ұсыныстар',
      'onboarding_desc_3':
          'Сіздің қызығушылықтарыңызға негізделген AI ұсыныстары. Ешнәрсені жіберіп алмаңыз.',
      'skip': 'Өткізу',
      'next': 'Келесі',
      'get_started': 'Бастау',

      // Home
      'home_greeting': 'Сәлем',
      'recommended_for_you': 'Сізге ұсынылады',
      'trending_now': 'Қазір танымал',
      'nearby_events': 'Жақын жердегі',
      'categories': 'Санаттар',
      'popular_events': 'Танымал іс-шаралар',

      // Events
      'events': 'Іс-шаралар',
      'event_details': 'Іс-шара туралы',
      'join_event': 'Қатысу',
      'leave_event': 'Бас тарту',
      'add_to_favorites': 'Таңдаулыларға',
      'share_event': 'Бөлісу',
      'free': 'Тегін',
      'paid': 'Ақылы',
      'attendees': 'қатысушы',
      'organizer': 'Ұйымдастырушы',
      'date_and_time': 'Күні мен уақыты',
      'location': 'Орын',

      // Categories
      'technology': 'Технология',
      'sports': 'Спорт',
      'music': 'Музыка',
      'art': 'Өнер',
      'food': 'Тамақ',
      'education': 'Білім',
      'business': 'Бизнес',
      'culture': 'Мәдениет',
      'wellness': 'Денсаулық',
      'entertainment': 'Ойын-сауық',

      // Navigation
      'nav_home': 'Басты',
      'nav_events': 'Оқиғалар',
      'nav_map': 'Карта',
      'nav_chat': 'Чат',
      'nav_profile': 'Профиль',

      // Profile
      'profile': 'Профиль',
      'edit_profile': 'Өзгерту',
      'my_events': 'Менің оқиғаларым',
      'favorites': 'Таңдаулылар',
      'settings': 'Баптаулар',
      'interests': 'Қызығушылықтар',

      // Chat
      'chat': 'Чат',
      'type_message': 'Хабарлама жазыңыз...',
      'no_messages': 'Хабарламалар жоқ',

      // Map
      'map': 'Карта',
      'events_nearby': 'Жақын іс-шаралар',

      // Notifications
      'notifications': 'Хабарландырулар',
      'notifications_title': 'Хабарландырулар',
      'no_notifications': 'Хабарландырулар жоқ',
      'mark_all_read': 'Барлығын оқу',
    },
  };

  String translate(String key) {
    final langCode = locale.languageCode;
    return _translations[langCode]?[key] ??
        _translations['en']?[key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'kk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Extension for convenient access throughout the widget tree.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String tr(String key) => AppLocalizations.of(this).translate(key);
}
