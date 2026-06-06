import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import * as bcrypt from 'bcrypt';
import 'dotenv/config';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

// Unsplash — чёткие картинки без пикселей, каждый URL уникален
const IMAGES = {
  technology: [
    'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80',
    'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=800&q=80',
    'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800&q=80',
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800&q=80',
    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&q=80',
    'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&q=80',
  ],
  sports: [
    'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=800&q=80',
    'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800&q=80',
    'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=800&q=80',
    'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=800&q=80',
    'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=800&q=80',
  ],
  music: [
    'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&q=80',
    'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=800&q=80',
    'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=80',
    'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&q=80',
  ],
  art: [
    'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800&q=80',
    'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=800&q=80',
    'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80',
  ],
  food: [
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800&q=80',
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&q=80',
  ],
  education: [
    'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&q=80',
    'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=800&q=80',
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&q=80',
  ],
  business: [
    'https://images.unsplash.com/photo-1556761175-4b46a572b786?w=800&q=80',
    'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=800&q=80',
    'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=800&q=80',
    'https://images.unsplash.com/photo-1553877522-43269d4ea984?w=800&q=80',
  ],
  culture: [
    'https://images.unsplash.com/photo-1533929736458-ca588d08c8be?w=800&q=80',
    'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&q=80',
    'https://images.unsplash.com/photo-1559827291-72ee739d0d9a?w=800&q=80',
  ],
  wellness: [
    'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&q=80',
    'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80',
    'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=800&q=80',
  ],
  entertainment: [
    'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800&q=80',
    'https://images.unsplash.com/photo-1560109947-543149eceb16?w=800&q=80',
    'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=800&q=80',
  ],
};

function img(category: keyof typeof IMAGES, index = 0): string {
  const arr = IMAGES[category];
  return arr[index % arr.length];
}

async function main() {
  console.log('🌱 Seeding database...');

  const hash = await bcrypt.hash('12345678', 10);

  // ── Пользователи ────────────────────────────────────────────────────────

  const amir = await prisma.user.upsert({
    where: { email: 'amir@jastar.kz' },
    update: {},
    create: {
      email: 'amir@jastar.kz', password: hash,
      name: 'Амир Касымов',
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      bio: 'Разработчик и организатор IT-мероприятий в Алматы 🚀',
      rank: 'Explorer', points: 2450,
      eventsAttended: 42, eventsOrganized: 8,
      followers: 256, following: 128,
      interests: ['technology', 'education', 'business'],
      role: 'ADMIN',
    },
  });

  const dana = await prisma.user.upsert({
    where: { email: 'dana@mail.kz' },
    update: {},
    create: {
      email: 'dana@mail.kz', password: hash,
      name: 'Дана Нурланова',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      bio: 'Фотограф и путешественница 📸',
      rank: 'Adventurer', points: 3100,
      eventsAttended: 35, eventsOrganized: 5,
      followers: 189, following: 97,
      interests: ['art', 'culture', 'entertainment'],
    },
  });

  const timur = await prisma.user.upsert({
    where: { email: 'timur@mail.kz' },
    update: {},
    create: {
      email: 'timur@mail.kz', password: hash,
      name: 'Тимур Ахметов',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      bio: 'Спортсмен и фитнес-тренер 💪',
      rank: 'Champion', points: 4200,
      eventsAttended: 58, eventsOrganized: 12,
      followers: 445, following: 210,
      interests: ['sports', 'wellness', 'food'],
    },
  });

  const aigerim = await prisma.user.upsert({
    where: { email: 'aigerim@mail.kz' },
    update: {},
    create: {
      email: 'aigerim@mail.kz', password: hash,
      name: 'Айгерим Сериккызы',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      bio: 'Дизайнер и иллюстратор из Астаны 🎨',
      rank: 'Creator', points: 1800,
      eventsAttended: 22, eventsOrganized: 3,
      followers: 312, following: 156,
      interests: ['art', 'culture', 'education'],
    },
  });

  const arman = await prisma.user.upsert({
    where: { email: 'arman@mail.kz' },
    update: {},
    create: {
      email: 'arman@mail.kz', password: hash,
      name: 'Арман Болатов',
      avatarUrl: 'https://i.pravatar.cc/150?img=14',
      bio: 'Предприниматель и инвестор 📈',
      rank: 'Visionary', points: 5600,
      eventsAttended: 75, eventsOrganized: 20,
      followers: 890, following: 340,
      interests: ['business', 'technology', 'music'],
    },
  });

  // ── Мероприятия ─────────────────────────────────────────────────────────

  const events = [
    // TECHNOLOGY (8)
    {
      title: 'Tech Meetup Almaty 2026',
      description: 'Крупнейшее IT-сообщество Алматы. Доклады о Flutter, AI, Cloud. Нетворкинг и розыгрыши призов от партнёров.',
      imageUrl: img('technology', 0),
      category: 'technology', city: 'Алматы',
      location: 'SmartPoint Hub, Достык 85',
      latitude: 43.2567, longitude: 76.9286,
      date: new Date('2026-07-15T18:00:00Z'),
      price: 0, attendeesCount: 156, maxAttendees: 200,
      organizerId: amir.id,
    },
    {
      title: 'AI Hackathon Astana 2026',
      description: '48-часовой хакатон по искусственному интеллекту. Призовой фонд 5 000 000 тг. Команды 2–5 человек.',
      imageUrl: img('technology', 1),
      category: 'technology', city: 'Астана',
      location: 'Назарбаев Университет, Кабанбай Батыра 53',
      latitude: 51.0906, longitude: 71.3964,
      date: new Date('2026-08-15T09:00:00Z'),
      price: 0, attendeesCount: 200, maxAttendees: 300,
      organizerId: amir.id,
    },
    {
      title: 'Flutter DevFest Шымкент',
      description: 'Однодневная конференция для Flutter-разработчиков. Мастер-классы, live-coding, networking с командами из разных городов.',
      imageUrl: img('technology', 2),
      category: 'technology', city: 'Шымкент',
      location: 'IT Park Shymkent, Тауке хан 12',
      latitude: 42.3417, longitude: 69.5901,
      date: new Date('2026-06-08T10:00:00Z'),
      price: 2000, attendeesCount: 78, maxAttendees: 150,
      organizerId: amir.id,
    },
    {
      title: 'Cybersecurity Conf KZ',
      description: 'Конференция по кибербезопасности. Эксперты из ведущих компаний расскажут о защите данных и последних угрозах.',
      imageUrl: img('technology', 3),
      category: 'technology', city: 'Алматы',
      location: 'Almaty Tower, Аль-Фараби 17',
      latitude: 43.2220, longitude: 76.9258,
      date: new Date('2026-09-20T10:00:00Z'),
      price: 5000, attendeesCount: 90, maxAttendees: 200,
      organizerId: amir.id,
    },
    {
      title: 'Web3 & Blockchain Meetup',
      description: 'Разбираем blockchain, DeFi и Web3 на практике. Подходит как для новичков, так и для опытных разработчиков.',
      imageUrl: img('technology', 4),
      category: 'technology', city: 'Астана',
      location: 'Impact Hub, Сыганак 48',
      latitude: 51.1282, longitude: 71.4306,
      date: new Date('2026-07-28T17:00:00Z'),
      price: 0, attendeesCount: 55, maxAttendees: 100,
      organizerId: arman.id,
    },
    {
      title: 'Data Science Workshop',
      description: 'Практический воркшоп по анализу данных с Python. Работаем с реальными датасетами, строим модели машинного обучения.',
      imageUrl: img('technology', 5),
      category: 'technology', city: 'Алматы',
      location: 'КБТУ, Толе Би 59',
      latitude: 43.2551, longitude: 76.9426,
      date: new Date('2026-06-22T14:00:00Z'),
      price: 3000, attendeesCount: 40, maxAttendees: 60,
      organizerId: amir.id,
    },
    {
      title: 'Product Management Bootcamp',
      description: '3-дневный интенсив по продакт-менеджменту. Научись создавать продукты, которые нужны людям.',
      imageUrl: img('technology', 0),
      category: 'technology', city: 'Алматы',
      location: 'Инновационный хаб, Панфилова 98',
      latitude: 43.2580, longitude: 76.9410,
      date: new Date('2026-10-10T09:00:00Z'),
      price: 25000, attendeesCount: 30, maxAttendees: 40,
      organizerId: arman.id,
    },
    {
      title: 'Open Source Day Pavlodar',
      description: 'День открытого кода. Вклад в open source проекты, код-ревью в живую, знакомство с мейнтейнерами.',
      imageUrl: img('technology', 1),
      category: 'technology', city: 'Павлодар',
      location: 'ПГУ им. Торайгырова, Ломова 64',
      latitude: 52.2872, longitude: 76.9674,
      date: new Date('2026-08-01T10:00:00Z'),
      price: 0, attendeesCount: 45, maxAttendees: 80,
      organizerId: amir.id,
    },

    // SPORTS (6)
    {
      title: 'Almaty Marathon 2026',
      description: 'Ежегодный благотворительный марафон. Дистанции 5км, 10км, 21км и 42км. Медали всем финишерам!',
      imageUrl: img('sports', 0),
      category: 'sports', city: 'Алматы',
      location: 'Парк Первого Президента',
      latitude: 43.1974, longitude: 76.8920,
      date: new Date('2026-09-12T07:00:00Z'),
      price: 8000, attendeesCount: 890, maxAttendees: 1500,
      organizerId: timur.id,
    },
    {
      title: 'Beach Volleyball Cup Актау',
      description: 'Турнир по пляжному волейболу на Каспии. Категории: любители и про. Живая музыка, барбекю.',
      imageUrl: img('sports', 1),
      category: 'sports', city: 'Актау',
      location: 'Городской пляж, набережная',
      latitude: 43.6350, longitude: 51.1580,
      date: new Date('2026-07-20T08:00:00Z'),
      price: 5000, attendeesCount: 64, maxAttendees: 128,
      organizerId: timur.id,
    },
    {
      title: 'CrossFit Open KZ 2026',
      description: 'Открытый чемпионат по CrossFit. Соревнования в нескольких категориях. Призы от спонсоров.',
      imageUrl: img('sports', 2),
      category: 'sports', city: 'Астана',
      location: 'Olympic Sports Complex',
      latitude: 51.1282, longitude: 71.4580,
      date: new Date('2026-06-05T09:00:00Z'),
      price: 6000, attendeesCount: 120, maxAttendees: 200,
      organizerId: timur.id,
    },
    {
      title: 'Горный трейл: Бутаковка',
      description: 'Групповой трейлраннинг по ущелью Бутаковка. Маршрут 15км, средняя сложность. Инструктор включён.',
      imageUrl: img('sports', 3),
      category: 'sports', city: 'Алматы',
      location: 'Вход в ущелье Бутаковка',
      latitude: 43.1683, longitude: 76.9750,
      date: new Date('2026-07-04T07:00:00Z'),
      price: 2500, attendeesCount: 28, maxAttendees: 40,
      organizerId: timur.id,
    },
    {
      title: 'Astana Basketball 3x3',
      description: 'Уличный баскетбольный турнир 3 на 3. Регистрация команд до 3 человек. Призовой фонд 300 000 тг.',
      imageUrl: img('sports', 4),
      category: 'sports', city: 'Астана',
      location: 'Площадь Республики',
      latitude: 51.1801, longitude: 71.4460,
      date: new Date('2026-08-10T10:00:00Z'),
      price: 4000, attendeesCount: 72, maxAttendees: 96,
      organizerId: timur.id,
    },
    {
      title: 'Велопробег «Зелёный Алматы»',
      description: 'Городской велопробег 30км по набережным и паркам Алматы. Для всех, у кого есть велосипед!',
      imageUrl: img('sports', 0),
      category: 'sports', city: 'Алматы',
      location: 'Старт: пл. Республики',
      latitude: 43.2389, longitude: 76.9458,
      date: new Date('2026-06-01T08:00:00Z'),
      price: 0, attendeesCount: 340, maxAttendees: 500,
      organizerId: timur.id,
    },

    // MUSIC (5)
    {
      title: 'Nauryz Music Festival 2026',
      description: 'Фестиваль живой музыки. Казахские народные инструменты, современная музыка и DJ-сеты под открытым небом.',
      imageUrl: img('music', 0),
      category: 'music', city: 'Алматы',
      location: 'Центральный Парк Культуры',
      latitude: 43.2389, longitude: 76.9458,
      date: new Date('2026-06-21T16:00:00Z'),
      price: 4000, attendeesCount: 420, maxAttendees: 800,
      organizerId: dana.id,
    },
    {
      title: 'Jazz Night Almaty',
      description: 'Вечер джаза с живым оркестром. Спикс-бэнд и квартет из 8 музыкантов. Ужин за отдельную плату.',
      imageUrl: img('music', 1),
      category: 'music', city: 'Алматы',
      location: 'Ресторан «Шокан», Гоголя 40',
      latitude: 43.2570, longitude: 76.9430,
      date: new Date('2026-07-11T19:00:00Z'),
      price: 6000, attendeesCount: 85, maxAttendees: 120,
      organizerId: dana.id,
    },
    {
      title: 'Electronic Music Open Air',
      description: 'Open air вечеринка с лучшими электронными DJ Казахстана. 8 часов музыки, фудкорт, арт-зоны.',
      imageUrl: img('music', 2),
      category: 'music', city: 'Астана',
      location: 'EXPO Plaza',
      latitude: 51.0870, longitude: 71.4160,
      date: new Date('2026-08-22T18:00:00Z'),
      price: 5000, attendeesCount: 600, maxAttendees: 1000,
      organizerId: arman.id,
    },
    {
      title: 'Акустический вечер: Инди-музыка',
      description: 'Камерный концерт инди-групп из Казахстана. Уютная атмосфера, живой звук, авторские тексты.',
      imageUrl: img('music', 3),
      category: 'music', city: 'Алматы',
      location: 'Кофейня Rum, Зенкова 22',
      latitude: 43.2604, longitude: 76.9361,
      date: new Date('2026-06-27T19:00:00Z'),
      price: 2000, attendeesCount: 40, maxAttendees: 60,
      organizerId: dana.id,
    },
    {
      title: 'Хоровой фестиваль «Жаңғырық»',
      description: 'Ежегодный хоровой фестиваль. 12 коллективов из разных городов. Вход свободный для всех.',
      imageUrl: img('music', 0),
      category: 'music', city: 'Шымкент',
      location: 'Дворец культуры «Достык»',
      latitude: 42.3200, longitude: 69.5860,
      date: new Date('2026-09-05T17:00:00Z'),
      price: 0, attendeesCount: 250, maxAttendees: 500,
      organizerId: aigerim.id,
    },

    // ART (4)
    {
      title: 'Арт-выставка «Степь и горизонт»',
      description: 'Выставка 20 молодых казахстанских художников. Живопись, графика, цифровое искусство.',
      imageUrl: img('art', 0),
      category: 'art', city: 'Алматы',
      location: 'Центр современного искусства, Фурманова 128',
      latitude: 43.2496, longitude: 76.9355,
      date: new Date('2026-07-01T11:00:00Z'),
      price: 1500, attendeesCount: 88, maxAttendees: 200,
      organizerId: aigerim.id,
    },
    {
      title: 'Мастер-класс по керамике',
      description: 'Создайте свою первую керамическую чашку! Все материалы включены. Подходит для начинающих от 16 лет.',
      imageUrl: img('art', 1),
      category: 'art', city: 'Алматы',
      location: 'Арт-студия Clay & Play, Жамбыла 71',
      latitude: 43.2610, longitude: 76.9380,
      date: new Date('2026-06-15T15:00:00Z'),
      price: 5000, attendeesCount: 12, maxAttendees: 15,
      organizerId: aigerim.id,
    },
    {
      title: 'Стрит-арт фестиваль Астана',
      description: 'Уличные художники со всего Казахстана украшают город. Воркшопы по граффити, выставка скетчей.',
      imageUrl: img('art', 2),
      category: 'art', city: 'Астана',
      location: 'Квартал «Арт-баян», Алматы 12',
      latitude: 51.1780, longitude: 71.4450,
      date: new Date('2026-08-05T10:00:00Z'),
      price: 0, attendeesCount: 180, maxAttendees: 500,
      organizerId: aigerim.id,
    },
    {
      title: 'Фотовыставка «Казахстан сверху»',
      description: 'Аэрофотосъёмка пейзажей Казахстана. 80 работ в огромном формате. Автор — Дана Нурланова.',
      imageUrl: img('art', 3),
      category: 'art', city: 'Алматы',
      location: 'Галерея «Tengri», Кабанбай Батыра 50',
      latitude: 43.2380, longitude: 76.9458,
      date: new Date('2026-07-20T11:00:00Z'),
      price: 2000, attendeesCount: 120, maxAttendees: 300,
      organizerId: dana.id,
    },

    // FOOD (4)
    {
      title: 'Фудфест: Вкусы Казахстана',
      description: 'Гастрофестиваль с блюдами всех регионов. 30+ ресторанов, мастер-классы шеф-поваров, конкурсы.',
      imageUrl: img('food', 0),
      category: 'food', city: 'Астана',
      location: 'EXPO Площадь',
      latitude: 51.0870, longitude: 71.4160,
      date: new Date('2026-06-28T12:00:00Z'),
      price: 2500, attendeesCount: 450, maxAttendees: 1000,
      organizerId: dana.id,
    },
    {
      title: 'Воркшоп: Казахская выпечка',
      description: 'Учимся готовить баурсаки, самсу и боорсок. Уходите домой со своей выпечкой и рецептами.',
      imageUrl: img('food', 1),
      category: 'food', city: 'Алматы',
      location: 'Кулинарная студия «Дастархан»',
      latitude: 43.2480, longitude: 76.9390,
      date: new Date('2026-07-12T11:00:00Z'),
      price: 7000, attendeesCount: 16, maxAttendees: 20,
      organizerId: dana.id,
    },
    {
      title: 'Wine & Cheese Evening',
      description: 'Дегустация 10 сортов вина с сырной тарелкой. Сомелье расскажет о каждом вине. Только 18+.',
      imageUrl: img('food', 2),
      category: 'food', city: 'Алматы',
      location: 'Ресторан «Виноградник», Достык 200',
      latitude: 43.2200, longitude: 76.9540,
      date: new Date('2026-08-07T19:00:00Z'),
      price: 12000, attendeesCount: 24, maxAttendees: 30,
      organizerId: arman.id,
    },
    {
      title: 'Street Food Karaganda',
      description: 'Уличный фестиваль еды — 50 точек, от бургеров до карагандинского плова. Живая музыка весь день.',
      imageUrl: img('food', 3),
      category: 'food', city: 'Караганда',
      location: 'Парк культуры и отдыха',
      latitude: 49.8180, longitude: 73.1025,
      date: new Date('2026-07-19T12:00:00Z'),
      price: 0, attendeesCount: 380, maxAttendees: 800,
      organizerId: timur.id,
    },

    // EDUCATION (4)
    {
      title: 'Flutter Workshop для начинающих',
      description: 'Создаём полное мобильное приложение за 4 часа. Ноутбук обязателен. Уровень: с нуля.',
      imageUrl: img('education', 0),
      category: 'education', city: 'Алматы',
      location: 'Коворкинг GRATA, Сатпаева 22',
      latitude: 43.2318, longitude: 76.9254,
      date: new Date('2026-06-28T14:00:00Z'),
      price: 0, attendeesCount: 28, maxAttendees: 30,
      organizerId: amir.id,
    },
    {
      title: 'English Speaking Club',
      description: 'Еженедельный разговорный клуб английского языка. Темы: путешествия, технологии, кино. Уровень B1+.',
      imageUrl: img('education', 1),
      category: 'education', city: 'Алматы',
      location: 'Кофейня «Fabrika», Панфилова 112',
      latitude: 43.2607, longitude: 76.9372,
      date: new Date('2026-06-21T10:00:00Z'),
      price: 1000, attendeesCount: 22, maxAttendees: 30,
      organizerId: aigerim.id,
    },
    {
      title: 'SMM и контент для бизнеса',
      description: 'Как вести Instagram и TikTok для бизнеса: контент-план, съёмка, монтаж, продвижение без бюджета.',
      imageUrl: img('education', 2),
      category: 'education', city: 'Астана',
      location: 'Онлайн + запись',
      latitude: 51.1801, longitude: 71.4460,
      date: new Date('2026-07-08T18:00:00Z'),
      price: 4000, attendeesCount: 65, maxAttendees: 100,
      organizerId: aigerim.id,
    },
    {
      title: 'Казахский язык для начинающих',
      description: 'Интенсив по разговорному казахскому языку. За 2 дня вы освоите базовые фразы и произношение.',
      imageUrl: img('education', 0),
      category: 'education', city: 'Шымкент',
      location: 'Языковой центр «Тіл»',
      latitude: 42.3154, longitude: 69.5967,
      date: new Date('2026-08-15T09:00:00Z'),
      price: 6000, attendeesCount: 18, maxAttendees: 25,
      organizerId: aigerim.id,
    },

    // BUSINESS (4)
    {
      title: 'Startup Weekend Astana',
      description: '54 часа чтобы запустить стартап. Команды, MVP, питч перед инвесторами. Призы от акселераторов.',
      imageUrl: img('business', 0),
      category: 'business', city: 'Астана',
      location: 'Astana Hub, Мәңгілік Ел 55/8',
      latitude: 51.0891, longitude: 71.4178,
      date: new Date('2026-09-18T10:00:00Z'),
      price: 5000, attendeesCount: 90, maxAttendees: 150,
      organizerId: arman.id,
    },
    {
      title: 'Бизнес-форум «Болашак 2026»',
      description: 'Ежегодный форум молодых предпринимателей. Спикеры из Forbes KZ, инвесторы, менторские сессии.',
      imageUrl: img('business', 1),
      category: 'business', city: 'Шымкент',
      location: 'Rixos Khadisha Shymkent',
      latitude: 42.3154, longitude: 69.5967,
      date: new Date('2026-10-05T09:00:00Z'),
      price: 15000, attendeesCount: 120, maxAttendees: 250,
      organizerId: arman.id,
    },
    {
      title: 'Women in Business Brunch',
      description: 'Нетворкинг-бранч для женщин в бизнесе. Менторство, обмен опытом, поддержка женского предпринимательства.',
      imageUrl: img('business', 2),
      category: 'business', city: 'Алматы',
      location: 'The Ritz-Carlton Almaty',
      latitude: 43.2388, longitude: 76.9570,
      date: new Date('2026-07-25T11:00:00Z'),
      price: 8000, attendeesCount: 45, maxAttendees: 60,
      organizerId: aigerim.id,
    },
    {
      title: 'Инвестиции для начинающих',
      description: 'Семинар о том, как начать инвестировать с 50 000 тг. Акции, ETF, облигации, недвижимость.',
      imageUrl: img('business', 3),
      category: 'business', city: 'Алматы',
      location: 'Бизнес-центр «Нурлы Тау», Аль-Фараби 19',
      latitude: 43.2218, longitude: 76.9246,
      date: new Date('2026-06-30T18:30:00Z'),
      price: 3000, attendeesCount: 85, maxAttendees: 120,
      organizerId: arman.id,
    },

    // CULTURE (3)
    {
      title: 'Ночь музеев Алматы',
      description: 'Все музеи города открыты всю ночь. Специальные экскурсии, интерактивные инсталляции, мастер-классы.',
      imageUrl: img('culture', 0),
      category: 'culture', city: 'Алматы',
      location: 'Государственный музей, Самал-2',
      latitude: 43.2320, longitude: 76.9160,
      date: new Date('2026-05-18T20:00:00Z'),
      price: 1500, attendeesCount: 230, maxAttendees: 500,
      organizerId: dana.id,
    },
    {
      title: 'Казахский театр под открытым небом',
      description: 'Показ пьесы Мухтара Ауэзова «Абай». Современная постановка. Зрители сидят на траве с пледами.',
      imageUrl: img('culture', 1),
      category: 'culture', city: 'Алматы',
      location: 'Парк «Горный гигант»',
      latitude: 43.1810, longitude: 76.9020,
      date: new Date('2026-07-17T20:00:00Z'),
      price: 3500, attendeesCount: 180, maxAttendees: 300,
      organizerId: aigerim.id,
    },
    {
      title: 'Этнофестиваль «Жер-Ана»',
      description: 'Фестиваль традиционной культуры. Юрты, национальная одежда, игры и казахская кухня.',
      imageUrl: img('culture', 2),
      category: 'culture', city: 'Астана',
      location: 'Парк «Атамекен»',
      latitude: 51.1040, longitude: 71.4050,
      date: new Date('2026-08-30T11:00:00Z'),
      price: 0, attendeesCount: 560, maxAttendees: 2000,
      organizerId: aigerim.id,
    },

    // WELLNESS (3)
    {
      title: 'Yoga Sunrise: Кок-Тобе',
      description: 'Утренняя йога с видом на горы. Дыхательные практики, медитация. Все уровни. Коврики предоставляются.',
      imageUrl: img('wellness', 0),
      category: 'wellness', city: 'Алматы',
      location: 'Кок-Тобе, верхняя площадка',
      latitude: 43.2282, longitude: 76.9830,
      date: new Date('2026-07-05T06:00:00Z'),
      price: 3000, attendeesCount: 35, maxAttendees: 50,
      organizerId: timur.id,
    },
    {
      title: 'Медитация и осознанность',
      description: 'Двухчасовая сессия mindfulness-медитации. Техники управления стрессом и тревогой от сертифицированного инструктора.',
      imageUrl: img('wellness', 1),
      category: 'wellness', city: 'Алматы',
      location: 'Студия «Спокойствие», Гоголя 55',
      latitude: 43.2555, longitude: 76.9415,
      date: new Date('2026-06-14T10:00:00Z'),
      price: 4000, attendeesCount: 18, maxAttendees: 25,
      organizerId: timur.id,
    },
    {
      title: 'Детокс-weekend в горах',
      description: 'Выходные без телефона. Йога, медитация, прогулки в горах, здоровое питание. Трансфер включён.',
      imageUrl: img('wellness', 2),
      category: 'wellness', city: 'Алматы',
      location: 'Горный лагерь, Медеу',
      latitude: 43.1654, longitude: 76.9890,
      date: new Date('2026-08-22T08:00:00Z'),
      price: 35000, attendeesCount: 14, maxAttendees: 20,
      organizerId: timur.id,
    },

    // ENTERTAINMENT (3)
    {
      title: 'Ночь кино под звёздами',
      description: 'Кинопоказ на свежем воздухе. Казахстанские фильмы 2025–2026, попкорн, пледы, уютная атмосфера.',
      imageUrl: img('entertainment', 0),
      category: 'entertainment', city: 'Алматы',
      location: 'Площадь Республики',
      latitude: 43.2380, longitude: 76.9454,
      date: new Date('2026-07-30T21:00:00Z'),
      price: 0, attendeesCount: 198, maxAttendees: 400,
      organizerId: dana.id,
    },
    {
      title: 'Stand-up Comedy Night',
      description: 'Вечер стендап-комедии с 5 известными казахстанскими комиками. Билеты разлетаются быстро!',
      imageUrl: img('entertainment', 1),
      category: 'entertainment', city: 'Астана',
      location: 'Congress Hall, Орынбор 2',
      latitude: 51.1299, longitude: 71.4580,
      date: new Date('2026-08-14T19:00:00Z'),
      price: 7000, attendeesCount: 280, maxAttendees: 350,
      organizerId: arman.id,
    },
    {
      title: 'Квест «Тайны Алматы»',
      description: 'Городской квест по историческим местам Алматы. Команды 3–6 человек. Призы победителям!',
      imageUrl: img('entertainment', 2),
      category: 'entertainment', city: 'Алматы',
      location: 'Старт: пл. Астана',
      latitude: 43.2389, longitude: 76.8817,
      date: new Date('2026-06-06T14:00:00Z'),
      price: 2000, attendeesCount: 60, maxAttendees: 100,
      organizerId: dana.id,
    },
  ];

  // Создаём события с защитой от дубликатов
  let created = 0;
  let skipped = 0;

  for (const ev of events) {
    const { organizerId, ...data } = ev;

    const existing = await prisma.event.findFirst({
      where: { title: data.title, organizerId },
      select: { id: true },
    });

    if (existing) {
      skipped++;
      continue;
    }

    await prisma.event.create({
      data: { ...data, status: 'APPROVED', organizer: { connect: { id: organizerId } } },
    });
    created++;
  }

  // Уведомления для admin-пользователя
  const existingNotifs = await prisma.notification.count({ where: { userId: amir.id } });
  if (existingNotifs === 0) {
    await prisma.notification.createMany({
      data: [
        {
          userId: amir.id, type: 'NEW_RECOMMENDATION',
          title: 'Новые рекомендации',
          message: 'У нас есть события которые могут вам понравиться!',
        },
        {
          userId: amir.id, type: 'EVENT_REMINDER',
          title: 'Напоминание о событии',
          message: 'Tech Meetup Almaty 2026 начнётся скоро!',
        },
        {
          userId: amir.id, type: 'NEW_FOLLOWER',
          title: 'Новый подписчик',
          message: 'Дана Нурланова подписалась на вас',
        },
        {
          userId: amir.id, type: 'SYSTEM',
          title: 'Добро пожаловать!',
          message: 'Добро пожаловать в Jastar Hub Community!',
          isRead: true,
        },
      ],
    });
  }

  console.log(`✅ Готово! Создано: ${created} событий, пропущено (дубликаты): ${skipped}`);
  console.log(`👥 Пользователи: ${[amir, dana, timur, aigerim, arman].map(u => u.email).join(', ')}`);
}

main()
  .catch((e) => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
