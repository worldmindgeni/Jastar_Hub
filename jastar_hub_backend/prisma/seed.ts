import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import * as bcrypt from 'bcrypt';
import "dotenv/config";

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('Seeding database...');

  // 1. Create a dummy password hash
  const passwordHash = await bcrypt.hash('12345678', 10);

  // 2. Create Users
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
      bio: 'Фотограф и путешественница',
      rank: 'Adventurer',
      points: 3100,
    },
  });

  // 3. Create Events
  const event1 = await prisma.event.create({
    data: {
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
      organizer: {
        connect: { id: amir.id }
      }
    }
  });

  const event2 = await prisma.event.create({
    data: {
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
      organizer: {
        connect: { id: dana.id }
      }
    }
  });

  const event3 = await prisma.event.create({
    data: {
      title: 'Almaty Marathon Run',
      description: 'Ежегодный благотворительный марафон. Дистанции 10км, 21км и 42км.',
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
      organizer: {
        connect: { id: amir.id }
      }
    }
  });

  console.log({
    users: [amir.email, dana.email],
    events: [event1.title, event2.title, event3.title]
  });
  console.log('Database seeded successfully! 🌱');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
