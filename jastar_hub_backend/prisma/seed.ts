import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import * as bcrypt from 'bcrypt';
import "dotenv/config";

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('🌱 Seeding database...');

  const passwordHash = await bcrypt.hash('12345678', 10);

  // ─── Users ──────────────────────────────────────────────
  const amir = await prisma.user.upsert({
    where: { email: 'amir@jastar.kz' },
    update: {},
    create: {
      email: 'amir@jastar.kz',
      password: passwordHash,
      name: 'Амир Касымов',
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      bio: 'Разработчик и организатор IT-мероприятий в Алматы 🚀',
      rank: 'Explorer',
      points: 2450,
      eventsAttended: 42,
      eventsOrganized: 8,
      followers: 256,
      following: 128,
      interests: ['technology', 'programming', 'AI'],
      role: 'ADMIN',
    },
  });

  const dana = await prisma.user.upsert({
    where: { email: 'dana@mail.kz' },
    update: {},
    create: {
      email: 'dana@mail.kz',
      password: passwordHash,
      name: 'Дана Нурланова',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      bio: 'Фотограф и путешественница 📸',
      rank: 'Adventurer',
      points: 3100,
      eventsAttended: 35,
      eventsOrganized: 5,
      followers: 189,
      following: 97,
      interests: ['photography', 'travel', 'art'],
    },
  });

  const timur = await prisma.user.upsert({
    where: { email: 'timur@mail.kz' },
    update: {},
    create: {
      email: 'timur@mail.kz',
      password: passwordHash,
      name: 'Тимур Ахметов',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      bio: 'Спортсмен и фитнес-тренер 💪',
      rank: 'Champion',
      points: 4200,
      eventsAttended: 58,
      eventsOrganized: 12,
      followers: 445,
      following: 210,
      interests: ['sports', 'fitness', 'health'],
    },
  });

  const aigerim = await prisma.user.upsert({
    where: { email: 'aigerim@mail.kz' },
    update: {},
    create: {
      email: 'aigerim@mail.kz',
      password: passwordHash,
      name: 'Айгерим Сериккызы',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      bio: 'Дизайнер и иллюстратор из Астаны 🎨',
      rank: 'Creator',
      points: 1800,
      eventsAttended: 22,
      eventsOrganized: 3,
      followers: 312,
      following: 156,
      interests: ['design', 'art', 'culture'],
    },
  });

  const arman = await prisma.user.upsert({
    where: { email: 'arman@mail.kz' },
    update: {},
    create: {
      email: 'arman@mail.kz',
      password: passwordHash,
      name: 'Арман Болатов',
      avatarUrl: 'https://i.pravatar.cc/150?img=14',
      bio: 'Предприниматель и инвестор 📈',
      rank: 'Visionary',
      points: 5600,
      eventsAttended: 75,
      eventsOrganized: 20,
      followers: 890,
      following: 340,
      interests: ['business', 'technology', 'networking'],
    },
  });

  // ─── Events ─────────────────────────────────────────────
  const events = [
    {
      title: 'Tech Meetup Almaty 2026',
      description: 'Присоединяйтесь к крупнейшему IT-сообществу Алматы! Доклады о Flutter, AI и Cloud. Нетворкинг, розыгрыши и многое другое.',
      imageUrl: 'https://picsum.photos/seed/tech2026/400/250',
      category: 'technology',
      date: new Date('2026-05-15T18:00:00.000Z'),
      location: 'SmartPoint Hub, Достык 85',
      city: 'Алматы',
      latitude: 43.2567,
      longitude: 76.9286,
      price: 0,
      attendeesCount: 156,
      maxAttendees: 200,
      status: 'APPROVED' as const,
      organizerId: amir.id,
    },
    {
      title: 'Startup Weekend Astana',
      description: '54 часа, чтобы запустить стартап! Собирайте команду, разрабатывайте MVP и презентуйте инвесторам.',
      imageUrl: 'https://picsum.photos/seed/startup26/400/250',
      category: 'business',
      date: new Date('2026-05-22T10:00:00.000Z'),
      location: 'Astana Hub, Мәңгілік Ел 55/8',
      city: 'Астана',
      latitude: 51.0891,
      longitude: 71.4178,
      price: 5000,
      attendeesCount: 45,
      maxAttendees: 100,
      status: 'APPROVED' as const,
      organizerId: arman.id,
    },
    {
      title: 'Almaty Marathon Run',
      description: 'Ежегодный благотворительный марафон. Дистанции 10км, 21км и 42км. Медали для всех финишеров!',
      imageUrl: 'https://picsum.photos/seed/marathon/400/250',
      category: 'sports',
      date: new Date('2026-09-12T07:00:00.000Z'),
      location: 'Парк Первого Президента',
      city: 'Алматы',
      latitude: 43.1974,
      longitude: 76.8920,
      price: 12000,
      attendeesCount: 890,
      maxAttendees: 1500,
      status: 'APPROVED' as const,
      organizerId: timur.id,
    },
    {
      title: 'Flutter DevFest Шымкент',
      description: 'Однодневная конференция для Flutter-разработчиков. Мастер-классы, live-coding и networking.',
      imageUrl: 'https://picsum.photos/seed/flutter26/400/250',
      category: 'technology',
      date: new Date('2026-06-08T10:00:00.000Z'),
      location: 'IT Park Shymkent, Тауке хан 12',
      city: 'Шымкент',
      latitude: 42.3417,
      longitude: 69.5901,
      price: 2000,
      attendeesCount: 78,
      maxAttendees: 150,
      status: 'APPROVED' as const,
      organizerId: amir.id,
    },
    {
      title: 'Дизайн-митап: UI/UX тренды 2026',
      description: 'Обсуждаем актуальные тренды в дизайне интерфейсов. Glassmorphism, AI в дизайне и многое другое.',
      imageUrl: 'https://picsum.photos/seed/design26/400/250',
      category: 'design',
      date: new Date('2026-06-20T17:00:00.000Z'),
      location: 'Коворкинг Almaty Digital, Абая 150',
      city: 'Алматы',
      latitude: 43.2380,
      longitude: 76.9451,
      price: 0,
      attendeesCount: 62,
      maxAttendees: 80,
      status: 'APPROVED' as const,
      organizerId: aigerim.id,
    },
    {
      title: 'Ночь музеев Караганда',
      description: 'Уникальная возможность посетить все музеи города за одну ночь! Специальные экскурсии и мастер-классы.',
      imageUrl: 'https://picsum.photos/seed/museum26/400/250',
      category: 'culture',
      date: new Date('2026-05-18T20:00:00.000Z'),
      location: 'Музей искусств, Бухар-Жырау 47',
      city: 'Караганда',
      latitude: 49.8035,
      longitude: 73.0951,
      price: 1500,
      attendeesCount: 230,
      maxAttendees: 500,
      status: 'APPROVED' as const,
      organizerId: dana.id,
    },
    {
      title: 'Yoga Sunrise: утренняя йога',
      description: 'Начните день с энергией! Групповая йога на свежем воздухе с видом на горы. Все уровни подготовки.',
      imageUrl: 'https://picsum.photos/seed/yoga26/400/250',
      category: 'health',
      date: new Date('2026-07-05T06:00:00.000Z'),
      location: 'Кок-Тобе, верхняя площадка',
      city: 'Алматы',
      latitude: 43.2282,
      longitude: 76.9830,
      price: 3000,
      attendeesCount: 35,
      maxAttendees: 50,
      status: 'APPROVED' as const,
      organizerId: timur.id,
    },
    {
      title: 'AI Hackathon Astana 2026',
      description: '48-часовой хакатон по искусственному интеллекту. Призовой фонд 5 000 000 тг. Приглашаются команды от 2 до 5 человек.',
      imageUrl: 'https://picsum.photos/seed/aihack/400/250',
      category: 'technology',
      date: new Date('2026-08-15T09:00:00.000Z'),
      location: 'Назарбаев Университет',
      city: 'Астана',
      latitude: 51.0906,
      longitude: 71.3964,
      price: 0,
      attendeesCount: 200,
      maxAttendees: 300,
      status: 'APPROVED' as const,
      organizerId: amir.id,
    },
    {
      title: 'Фудфест: Вкусы Казахстана',
      description: 'Гастрономический фестиваль с блюдами из всех регионов Казахстана. Мастер-классы от шеф-поваров.',
      imageUrl: 'https://picsum.photos/seed/food26/400/250',
      category: 'food',
      date: new Date('2026-06-28T12:00:00.000Z'),
      location: 'Центральный парк, Тараз',
      city: 'Тараз',
      latitude: 42.9000,
      longitude: 71.3667,
      price: 2500,
      attendeesCount: 450,
      maxAttendees: 1000,
      status: 'APPROVED' as const,
      organizerId: dana.id,
    },
    {
      title: 'Бизнес-форум «Болашак»',
      description: 'Ежегодный форум для молодых предпринимателей. Спикеры из Forbes Kazakhstan, инвесторы и менторы.',
      imageUrl: 'https://picsum.photos/seed/bizforum/400/250',
      category: 'business',
      date: new Date('2026-10-05T09:00:00.000Z'),
      location: 'Rixos Khadisha Shymkent',
      city: 'Шымкент',
      latitude: 42.3154,
      longitude: 69.5967,
      price: 15000,
      attendeesCount: 120,
      maxAttendees: 250,
      status: 'APPROVED' as const,
      organizerId: arman.id,
    },
    {
      title: 'Актау Beach Volleyball Cup',
      description: 'Турнир по пляжному волейболу на берегу Каспийского моря. Категории: любители и профессионалы.',
      imageUrl: 'https://picsum.photos/seed/volleyball/400/250',
      category: 'sports',
      date: new Date('2026-07-20T08:00:00.000Z'),
      location: 'Городской пляж, набережная',
      city: 'Актау',
      latitude: 43.6350,
      longitude: 51.1580,
      price: 5000,
      attendeesCount: 64,
      maxAttendees: 128,
      status: 'APPROVED' as const,
      organizerId: timur.id,
    },
    {
      title: 'Фото-тур: Чарынский каньон',
      description: 'Однодневный фототур в Чарынский каньон. Профессиональный фотограф поможет с композицией и настройками.',
      imageUrl: 'https://picsum.photos/seed/charyn/400/250',
      category: 'travel',
      date: new Date('2026-06-14T06:00:00.000Z'),
      location: 'Сбор: Достык 91, Алматы',
      city: 'Алматы',
      latitude: 43.2564,
      longitude: 76.9285,
      price: 8000,
      attendeesCount: 18,
      maxAttendees: 25,
      status: 'APPROVED' as const,
      organizerId: dana.id,
    },
  ];

  for (const eventData of events) {
    const { organizerId, ...data } = eventData;
    await prisma.event.create({
      data: {
        ...data,
        organizer: { connect: { id: organizerId } },
      },
    });
  }

  // ─── Notifications (sample) ─────────────────────────────
  await prisma.notification.createMany({
    data: [
      {
        userId: amir.id,
        type: 'NEW_RECOMMENDATION',
        title: 'Новые рекомендации',
        message: 'У нас есть 3 новых события, которые могут вам понравиться!',
      },
      {
        userId: amir.id,
        type: 'EVENT_REMINDER',
        title: 'Напоминание о событии',
        message: 'Tech Meetup Almaty 2026 начнётся через 2 дня!',
      },
      {
        userId: amir.id,
        type: 'NEW_FOLLOWER',
        title: 'Новый подписчик',
        message: 'Дана Нурланова подписалась на вас',
      },
      {
        userId: amir.id,
        type: 'SYSTEM',
        title: 'Добро пожаловать!',
        message: 'Добро пожаловать в Jastar Hub Community! Начните исследовать события вашего города.',
        isRead: true,
      },
    ],
  });

  console.log({
    users: [amir.email, dana.email, timur.email, aigerim.email, arman.email],
    eventsCount: events.length,
  });
  console.log('✅ Database seeded successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
