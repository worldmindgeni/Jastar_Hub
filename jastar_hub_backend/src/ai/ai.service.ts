import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Event } from '@prisma/client';

export interface ChatMessage {
  message: string;
  userId?: string;
}

export interface ChatResponse {
  reply: string;
  suggestions: string[];
}

// Маппинг ключевых слов → категории событий
const CATEGORY_KEYWORDS: Record<string, string> = {
  технолог: 'technology',
  'it': 'technology',
  программ: 'technology',
  flutter: 'technology',
  хакатон: 'technology',
  разработ: 'technology',
  спорт: 'sports',
  фитнес: 'sports',
  бег: 'sports',
  футбол: 'sports',
  музык: 'music',
  концерт: 'music',
  джаз: 'music',
  искусств: 'art',
  выставк: 'art',
  живопис: 'art',
  еда: 'food',
  гастро: 'food',
  ресторан: 'food',
  кулинар: 'food',
  образован: 'education',
  курс: 'education',
  воркшоп: 'education',
  лекци: 'education',
  бизнес: 'business',
  стартап: 'business',
  нетворкинг: 'business',
  культур: 'culture',
  театр: 'culture',
  кино: 'entertainment',
  развлечен: 'entertainment',
  йога: 'wellness',
  медитац: 'wellness',
  здоровь: 'wellness',
};

@Injectable()
export class AiService {
  constructor(private readonly prisma: PrismaService) {}

  // ─── Чат-ассистент ────────────────────────────────────────────────────────

  async chat(body: ChatMessage): Promise<ChatResponse> {
    const msg = body.message.toLowerCase().trim();
    const events = await this.prisma.event.findMany({
      where: { status: 'APPROVED' },
      orderBy: { attendeesCount: 'desc' },
      take: 100,
      include: {
        organizer: { select: { id: true, name: true, avatarUrl: true } },
      },
    });

    return this.buildReply(msg, body.message, events);
  }

  private buildReply(
    msgLower: string,
    original: string,
    events: Event[],
  ): ChatResponse {
    // Приветствие
    if (/привет|здравствуй|hello|hi|салем|сәлем/.test(msgLower)) {
      return {
        reply:
          'Привет! 👋 Я ИИ-ассистент Jastar Hub.\n\n' +
          'Могу помочь найти события, ответить на вопросы или порекомендовать что-то интересное.\n\n' +
          'Попробуй спросить:\n• «Что есть бесплатного?»\n• «Покажи IT события»\n• «Что популярно сейчас?»',
        suggestions: ['Бесплатные события', 'IT события', 'Популярное'],
      };
    }

    // Помощь
    if (/помог|help|что умеешь|что ты/.test(msgLower)) {
      return {
        reply:
          'Я умею:\n\n' +
          '🔍 Искать события по категории или ключевому слову\n' +
          '🎉 Показывать бесплатные мероприятия\n' +
          '🔥 Рассказывать о популярных событиях\n' +
          '📅 Показывать ближайшие мероприятия\n\n' +
          'Просто напиши что тебя интересует!',
        suggestions: ['IT события', 'Бесплатные', 'Популярное'],
      };
    }

    // Бесплатные события
    if (/бесплатн|free|тегін/.test(msgLower)) {
      const free = events.filter((e) => e.price === 0).slice(0, 5);
      if (!free.length) {
        return { reply: 'Сейчас бесплатных событий нет, но скоро появятся! 🙂', suggestions: [] };
      }
      return {
        reply: 'Вот бесплатные мероприятия 🎉\n\n' + free.map(this.formatEvent).join('\n'),
        suggestions: ['Показать все', 'IT события', 'Спорт'],
      };
    }

    // Популярные / трендовые
    if (/популярн|тренд|топ|popular|trending/.test(msgLower)) {
      const top = [...events].sort((a, b) => b.attendeesCount - a.attendeesCount).slice(0, 5);
      if (!top.length) return { reply: 'Пока нет данных о популярных событиях.', suggestions: [] };
      return {
        reply: 'Самые популярные события прямо сейчас 🔥\n\n' + top.map(this.formatEvent).join('\n'),
        suggestions: ['Бесплатные', 'IT события'],
      };
    }

    // Ближайшие
    if (/ближайш|скоро|сегодня|завтра|upcoming/.test(msgLower)) {
      const now = new Date();
      const upcoming = events
        .filter((e) => new Date(e.date) > now)
        .sort((a, b) => new Date(a.date).getTime() - new Date(b.date).getTime())
        .slice(0, 5);
      if (!upcoming.length) return { reply: 'Ближайших событий пока нет.', suggestions: [] };
      return {
        reply: 'Ближайшие мероприятия 📅\n\n' + upcoming.map(this.formatEvent).join('\n'),
        suggestions: ['Популярное', 'Бесплатные'],
      };
    }

    // Поиск по категории
    const matchedCategory = this.detectCategory(msgLower);
    if (matchedCategory) {
      const catEvents = events.filter((e) => e.category.toLowerCase() === matchedCategory).slice(0, 5);
      if (!catEvents.length) {
        return {
          reply: `По категории «${matchedCategory}» пока ничего нет. Попробуй другую! 🔍`,
          suggestions: ['Бесплатные', 'Популярное'],
        };
      }
      return {
        reply: `Нашёл события по теме 🔎\n\n` + catEvents.map(this.formatEvent).join('\n'),
        suggestions: ['Бесплатные', 'Популярное', 'Все события'],
      };
    }

    // Полнотекстовый поиск
    if (original.trim().length > 2) {
      const q = original.toLowerCase();
      const found = events
        .filter(
          (e) =>
            e.title.toLowerCase().includes(q) ||
            e.description.toLowerCase().includes(q) ||
            e.location.toLowerCase().includes(q) ||
            e.city.toLowerCase().includes(q),
        )
        .slice(0, 5);

      if (found.length) {
        return {
          reply: `Нашёл по запросу «${original}» 🔍\n\n` + found.map(this.formatEvent).join('\n'),
          suggestions: [],
        };
      }
    }

    // Дефолт
    return {
      reply:
        `Не совсем понял запрос «${original}» 🤔\n\n` +
        'Попробуй спросить о конкретной категории или написать название события. ' +
        'Например: «IT события», «бесплатные», «популярное».',
      suggestions: ['Бесплатные события', 'IT события', 'Популярное', 'Ближайшие'],
    };
  }

  // ─── Рекомендации ─────────────────────────────────────────────────────────

  async getRecommendations(userId: string): Promise<Event[]> {
    const [events, user] = await Promise.all([
      this.prisma.event.findMany({
        where: { status: 'APPROVED' },
        take: 100,
        include: { organizer: { select: { id: true, name: true, avatarUrl: true } } },
      }),
      this.prisma.user.findUnique({
        where: { id: userId },
        select: { interests: true },
      }),
    ]);

    if (!user || events.length === 0) return this.getTrending(10);

    const interests = user.interests ?? [];
    if (!interests.length) return this.getTrending(10);

    const maxAtt = Math.max(...events.map((e) => e.attendeesCount), 1);

    const scored = events.map((event) => {
      const text = `${event.title} ${event.description} ${event.category}`.toLowerCase();
      const contentScore = interests.reduce(
        (acc, interest) => acc + (text.includes(interest.toLowerCase()) ? 1 : 0),
        0,
      );
      const popularityScore = event.attendeesCount / maxAtt;
      return { event, score: contentScore * 0.7 + popularityScore * 0.3 };
    });

    return scored
      .sort((a, b) => b.score - a.score)
      .slice(0, 10)
      .map((s) => s.event);
  }

  // ─── Похожие события ──────────────────────────────────────────────────────

  async getSimilar(eventId: string, limit = 5): Promise<Event[]> {
    const target = await this.prisma.event.findUnique({ where: { id: eventId } });
    if (!target) return [];

    const events = await this.prisma.event.findMany({
      where: { status: 'APPROVED', id: { not: eventId } },
      take: 100,
      include: { organizer: { select: { id: true, name: true, avatarUrl: true } } },
    });

    const targetText = `${target.title} ${target.description} ${target.category} ${target.city}`.toLowerCase();
    const targetWords = new Set(targetText.split(/\s+/).filter((w) => w.length > 3));

    const scored = events.map((event) => {
      const text = `${event.title} ${event.description} ${event.category} ${event.city}`.toLowerCase();
      const words = text.split(/\s+/).filter((w) => w.length > 3);
      const intersection = words.filter((w) => targetWords.has(w)).length;
      const union = new Set([...targetWords, ...words]).size;
      const jaccardScore = union > 0 ? intersection / union : 0;

      // Бонус за ту же категорию
      const categoryBonus = event.category === target.category ? 0.3 : 0;
      return { event, score: jaccardScore + categoryBonus };
    });

    return scored
      .sort((a, b) => b.score - a.score)
      .slice(0, limit)
      .map((s) => s.event);
  }

  // ─── Trending ─────────────────────────────────────────────────────────────

  async getTrending(limit = 10): Promise<Event[]> {
    return this.prisma.event.findMany({
      where: { status: 'APPROVED' },
      orderBy: { attendeesCount: 'desc' },
      take: limit,
      include: { organizer: { select: { id: true, name: true, avatarUrl: true } } },
    });
  }

  // ─── Утилиты ──────────────────────────────────────────────────────────────

  private formatEvent(event: Event): string {
    const price = event.price === 0 ? 'Бесплатно' : `${Math.round(event.price)} ₸`;
    const date = new Date(event.date);
    const dateStr = date.toLocaleDateString('ru-RU', {
      day: 'numeric',
      month: 'short',
      hour: '2-digit',
      minute: '2-digit',
    });
    return `• **${event.title}** — ${dateStr}, ${event.location} (${price})`;
  }

  private detectCategory(msg: string): string | null {
    for (const [keyword, category] of Object.entries(CATEGORY_KEYWORDS)) {
      if (msg.includes(keyword)) return category;
    }
    return null;
  }
}
