/**
 * Скрипт удаления дубликатов событий из БД.
 * Запуск: npx ts-node prisma/dedup.ts
 *
 * Логика: среди событий с одинаковым title + organizerId оставляем
 * самое старое (первое созданное), остальные удаляем вместе с их
 * participations, favorites и interactions.
 */

import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import 'dotenv/config';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('🔍 Ищем дубликаты событий...');

  // Получаем все события, сортируем по дате создания
  const all = await prisma.event.findMany({
    orderBy: { createdAt: 'asc' },
    select: { id: true, title: true, organizerId: true, createdAt: true },
  });

  // Группируем по ключу "title + organizerId"
  const seen = new Map<string, string>(); // key → id первого (оригинала)
  const toDelete: string[] = [];

  for (const event of all) {
    const key = `${event.title.toLowerCase().trim()}__${event.organizerId}`;
    if (seen.has(key)) {
      toDelete.push(event.id);
    } else {
      seen.set(key, event.id);
    }
  }

  if (toDelete.length === 0) {
    console.log('✅ Дубликатов не найдено.');
    return;
  }

  console.log(`🗑  Найдено дубликатов: ${toDelete.length}`);
  console.log('   Удаляем связанные записи...');

  // Удаляем в транзакции — сначала зависимые таблицы, потом сами события
  await prisma.$transaction(async (tx) => {
    await tx.eventInteraction.deleteMany({ where: { eventId: { in: toDelete } } });
    await tx.favorite.deleteMany({ where: { eventId: { in: toDelete } } });
    await tx.participation.deleteMany({ where: { eventId: { in: toDelete } } });
    await tx.event.deleteMany({ where: { id: { in: toDelete } } });
  });

  console.log(`✅ Удалено ${toDelete.length} дубликатов.`);
}

main()
  .catch((e) => {
    console.error('❌ Ошибка:', e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
