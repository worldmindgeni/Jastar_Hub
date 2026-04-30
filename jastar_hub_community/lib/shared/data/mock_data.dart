import 'package:jastar_hub_community/shared/models/event_model.dart';
import 'package:jastar_hub_community/features/auth/data/models/user_model.dart';

/// Realistic mock data for development.
/// Events based in Kazakhstan (Almaty, Astana, etc.)
class MockData {
  MockData._();

  // ─── Current User ───────────────────────────────────────────
  static final UserModel currentUser = UserModel(
    id: 'user_001',
    email: 'amir@jastar.kz',
    name: 'Амир Касымов',
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
    bio: 'Разработчик и организатор IT-мероприятий в Алматы 🚀',
    interests: ['technology', 'business', 'education', 'music'],
    eventsAttended: 42,
    eventsOrganized: 8,
    followers: 256,
    following: 128,
    points: 2450,
    rank: 'Explorer',
  );

  // ─── Mock Users ─────────────────────────────────────────────
  static final List<UserModel> users = [
    UserModel(
      id: 'user_002',
      email: 'dana@mail.kz',
      name: 'Дана Нурланова',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      bio: 'Фотограф и путешественница',
      interests: ['art', 'culture', 'wellness'],
      eventsAttended: 35,
      followers: 512,
      following: 89,
      points: 3100,
      rank: 'Adventurer',
    ),
    UserModel(
      id: 'user_003',
      email: 'nariman@dev.kz',
      name: 'Нариман Ахметов',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      bio: 'Full-stack developer, tech enthusiast',
      interests: ['technology', 'education'],
      eventsAttended: 28,
      followers: 195,
      following: 67,
      points: 1870,
      rank: 'Explorer',
    ),
    UserModel(
      id: 'user_004',
      email: 'aigerim@art.kz',
      name: 'Айгерім Сатыбалды',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      bio: 'Дизайнер, иллюстратор',
      interests: ['art', 'music', 'entertainment'],
      eventsAttended: 51,
      followers: 890,
      following: 234,
      points: 4200,
      rank: 'Champion',
    ),
  ];

  // ─── Mock Events ────────────────────────────────────────────
  static final List<EventModel> events = [
    EventModel(
      id: 'evt_001',
      title: 'Tech Meetup Almaty 2026',
      description:
          'Присоединяйтесь к крупнейшему IT-сообществу Алматы! Доклады о Flutter, AI и Cloud. Нетворкинг, розыгрыши и многое другое.',
      imageUrl: 'https://picsum.photos/seed/tech2026/400/250',
      category: 'technology',
      date: DateTime(2026, 5, 15, 18, 0),
      location: 'SmartPoint Hub, Достык 85',
      city: 'Алматы',
      latitude: 43.2567,
      longitude: 76.9286,
      organizerName: 'Tech Hub KZ',
      organizerAvatar: 'https://i.pravatar.cc/150?img=33',
      price: 0,
      attendees: 156,
      maxAttendees: 200,
      tags: ['flutter', 'ai', 'networking'],
    ),
    EventModel(
      id: 'evt_002',
      title: 'Startup Weekend Astana',
      description:
          '54 часа, чтобы запустить стартап! Собирайте команду, разрабатывайте MVP и презентуйте инвесторам.',
      imageUrl: 'https://picsum.photos/seed/startup26/400/250',
      category: 'business',
      date: DateTime(2026, 5, 22, 10, 0),
      location: 'Astana Hub, Мәңгілік Ел 55/8',
      city: 'Астана',
      latitude: 51.0891,
      longitude: 71.4178,
      organizerName: 'Astana Hub',
      organizerAvatar: 'https://i.pravatar.cc/150?img=15',
      price: 5000,
      attendees: 89,
      maxAttendees: 120,
      tags: ['startup', 'innovation', 'pitch'],
    ),
    EventModel(
      id: 'evt_003',
      title: 'Nauryz Music Festival',
      description:
          'Фестиваль живой музыки в честь Наурыза! Казахские народные инструменты, современная музыка и DJ-сеты.',
      imageUrl: 'https://picsum.photos/seed/nauryz/400/250',
      category: 'music',
      date: DateTime(2026, 6, 1, 16, 0),
      location: 'Центральный Парк Культуры',
      city: 'Алматы',
      latitude: 43.2389,
      longitude: 76.9458,
      organizerName: 'KZ Events',
      organizerAvatar: 'https://i.pravatar.cc/150?img=20',
      price: 3000,
      attendees: 420,
      maxAttendees: 500,
      tags: ['music', 'festival', 'nauryz'],
    ),
    EventModel(
      id: 'evt_004',
      title: 'Современное искусство Казахстана',
      description:
          'Выставка работ молодых казахстанских художников. Живопись, скульптура, инсталляции.',
      imageUrl: 'https://picsum.photos/seed/artexpo/400/250',
      category: 'art',
      date: DateTime(2026, 5, 18, 11, 0),
      location: 'Галерея Tengri Umay, Кабанбай Батыра 50',
      city: 'Алматы',
      latitude: 43.2380,
      longitude: 76.9458,
      organizerName: 'Tengri Umay',
      organizerAvatar: 'https://i.pravatar.cc/150?img=25',
      price: 1500,
      attendees: 78,
      maxAttendees: 150,
      tags: ['art', 'exhibition', 'contemporary'],
    ),
    EventModel(
      id: 'evt_005',
      title: 'Mountain Trail: Бутаковка',
      description:
          'Групповой поход по живописному ущелью Бутаковка. Маршрут средней сложности, 12 км.',
      imageUrl: 'https://picsum.photos/seed/mountain/400/250',
      category: 'sports',
      date: DateTime(2026, 5, 25, 8, 0),
      location: 'Ущелье Бутаковка',
      city: 'Алматы',
      latitude: 43.1683,
      longitude: 76.9750,
      organizerName: 'Hike KZ',
      organizerAvatar: 'https://i.pravatar.cc/150?img=41',
      price: 0,
      attendees: 34,
      maxAttendees: 40,
      tags: ['hiking', 'nature', 'mountains'],
    ),
    EventModel(
      id: 'evt_006',
      title: 'Hackathon: Green Tech',
      description:
          'Хакатон по разработке решений для экологических проблем Казахстана. Призовой фонд — 2 000 000 тг.',
      imageUrl: 'https://picsum.photos/seed/hackathon/400/250',
      category: 'technology',
      date: DateTime(2026, 6, 8, 9, 0),
      location: 'КБТУ, Толе Би 59',
      city: 'Алматы',
      latitude: 43.2551,
      longitude: 76.9426,
      organizerName: 'KBTU Innovations',
      organizerAvatar: 'https://i.pravatar.cc/150?img=30',
      price: 0,
      attendees: 112,
      maxAttendees: 150,
      isFavorite: true,
      tags: ['hackathon', 'ecology', 'greentech'],
    ),
    EventModel(
      id: 'evt_007',
      title: 'Йога в Парке',
      description:
          'Утренняя йога на свежем воздухе. Подходит для всех уровней. Коврики предоставляются.',
      imageUrl: 'https://picsum.photos/seed/yoga/400/250',
      category: 'wellness',
      date: DateTime(2026, 5, 20, 7, 0),
      location: 'Парк Первого Президента',
      city: 'Алматы',
      latitude: 43.2165,
      longitude: 76.9284,
      organizerName: 'Zen Space',
      organizerAvatar: 'https://i.pravatar.cc/150?img=44',
      price: 0,
      attendees: 25,
      maxAttendees: 50,
      tags: ['yoga', 'wellness', 'outdoor'],
    ),
    EventModel(
      id: 'evt_008',
      title: 'Food Festival: Silk Road Taste',
      description:
          'Гастрономический фестиваль кухонь Шёлкового пути. Более 30 ресторанов, мастер-классы от шеф-поваров.',
      imageUrl: 'https://picsum.photos/seed/foodfest/400/250',
      category: 'food',
      date: DateTime(2026, 6, 14, 12, 0),
      location: 'EXPO площадь',
      city: 'Астана',
      latitude: 51.0870,
      longitude: 71.4160,
      organizerName: 'Taste KZ',
      organizerAvatar: 'https://i.pravatar.cc/150?img=46',
      price: 2000,
      attendees: 340,
      maxAttendees: 500,
      tags: ['food', 'festival', 'gastronomy'],
    ),
    EventModel(
      id: 'evt_009',
      title: 'Flutter Workshop для начинающих',
      description:
          'Практический воркшоп по Flutter. Создадим полное приложение за 4 часа. Ноутбук обязателен.',
      imageUrl: 'https://picsum.photos/seed/flutter26/400/250',
      category: 'education',
      date: DateTime(2026, 5, 28, 14, 0),
      location: 'Коворкинг GRATA, Сатпаева 22',
      city: 'Алматы',
      latitude: 43.2318,
      longitude: 76.9254,
      organizerName: 'Flutter Almaty',
      organizerAvatar: 'https://i.pravatar.cc/150?img=50',
      price: 0,
      attendees: 28,
      maxAttendees: 30,
      isJoined: true,
      isFavorite: true,
      tags: ['flutter', 'workshop', 'beginner'],
    ),
    EventModel(
      id: 'evt_010',
      title: 'Ночь Кино под открытым небом',
      description:
          'Кинопоказ под звёздами! Казахстанские фильмы, попкорн, пледы. Вход свободный.',
      imageUrl: 'https://picsum.photos/seed/cinema/400/250',
      category: 'entertainment',
      date: DateTime(2026, 6, 5, 20, 0),
      location: 'Площадь Республики',
      city: 'Алматы',
      latitude: 43.2380,
      longitude: 76.9454,
      organizerName: 'Cinema KZ',
      organizerAvatar: 'https://i.pravatar.cc/150?img=52',
      price: 0,
      attendees: 198,
      maxAttendees: 300,
      tags: ['cinema', 'outdoor', 'free'],
    ),
    EventModel(
      id: 'evt_011',
      title: 'Networking Brunch: Women in Tech',
      description:
          'Бизнес-бранч для женщин в IT-индустрии. Обмен опытом, менторство, нетворкинг.',
      imageUrl: 'https://picsum.photos/seed/womenintech/400/250',
      category: 'business',
      date: DateTime(2026, 5, 30, 11, 0),
      location: 'The Ritz-Carlton, Алматы',
      city: 'Алматы',
      latitude: 43.2380,
      longitude: 76.9570,
      organizerName: 'WIT KZ',
      organizerAvatar: 'https://i.pravatar.cc/150?img=32',
      price: 8000,
      attendees: 45,
      maxAttendees: 60,
      tags: ['networking', 'women', 'tech'],
    ),
    EventModel(
      id: 'evt_012',
      title: 'Мастер-класс по керамике',
      description:
          'Создайте свою первую керамическую чашку! Все материалы включены. Подходит для новичков.',
      imageUrl: 'https://picsum.photos/seed/ceramics/400/250',
      category: 'culture',
      date: DateTime(2026, 6, 2, 15, 0),
      location: 'Арт-студия Clay & Play, Жамбыла 71',
      city: 'Алматы',
      latitude: 43.2610,
      longitude: 76.9380,
      organizerName: 'Clay & Play',
      organizerAvatar: 'https://i.pravatar.cc/150?img=29',
      price: 4500,
      attendees: 12,
      maxAttendees: 15,
      tags: ['ceramics', 'craft', 'workshop'],
    ),
  ];

  // ─── Convenience getters ────────────────────────────────────
  static List<EventModel> get recommendedEvents =>
      events.where((e) => e.category == 'technology' || e.category == 'education').toList();

  static List<EventModel> get trendingEvents {
    final sorted = List<EventModel>.from(events)
      ..sort((a, b) => b.attendees.compareTo(a.attendees));
    return sorted.take(5).toList();
  }

  static List<EventModel> get nearbyEvents =>
      events.where((e) => e.city == 'Алматы').toList();

  static List<EventModel> get freeEvents =>
      events.where((e) => e.isFree).toList();

  static List<EventModel> get favoriteEvents =>
      events.where((e) => e.isFavorite).toList();

  // ─── Categories with icons and colors ───────────────────────
  static const List<Map<String, dynamic>> categoriesData = [
    {'key': 'technology', 'icon': 0xe556, 'color': 0xFF6C5CE7},
    {'key': 'sports', 'icon': 0xe5e7, 'color': 0xFF00B894},
    {'key': 'music', 'icon': 0xe405, 'color': 0xFFFD79A8},
    {'key': 'art', 'icon': 0xe40a, 'color': 0xFFE17055},
    {'key': 'food', 'icon': 0xe56c, 'color': 0xFFFDCB6E},
    {'key': 'education', 'icon': 0xe80c, 'color': 0xFF74B9FF},
    {'key': 'business', 'icon': 0xe0af, 'color': 0xFF636E72},
    {'key': 'culture', 'icon': 0xef57, 'color': 0xFFA29BFE},
    {'key': 'wellness', 'icon': 0xe88e, 'color': 0xFF55EFC4},
    {'key': 'entertainment', 'icon': 0xe87d, 'color': 0xFFFF7675},
  ];
}
