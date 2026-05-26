import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { Event } from '@prisma/client';
import axios from 'axios';

export class ChatMessage {
  message: string;
  userId?: string;
}

export class ChatResponse {
  reply: string;
  suggestions: string[];
}

const CATEGORY_KEYWORDS: Record<string, string> = {
  технолог: 'technology', it: 'technology', программ: 'technology',
  flutter: 'technology', хакатон: 'technology', разработ: 'technology',
  спорт: 'sports', фитнес: 'sports', бег: 'sports', футбол: 'sports',
  музык: 'music', концерт: 'music', джаз: 'music',
  искусств: 'art', выставк: 'art', живопис: 'art',
  еда: 'food', гастро: 'food', ресторан: 'food', кулинар: 'food',
  образован: 'education', курс: 'education', воркшоп: 'education', лекци: 'education',
  бизнес: 'business', стартап: 'business', нетворкинг: 'business',
  культур: 'culture', театр: 'culture',
  кино: 'entertainment', развлечен: 'entertainment',
  йога: 'wellness', медитац: 'wellness', здоровь: 'wellness',
};

const MISTRAL_API_URL = 'https://api.mistral.ai/v1/chat/completions';

@Injectable()
export class AiService {
  private readonly logger = new Logger(AiService.name);

  constructor(private readonly prisma: PrismaService) {}

  private get mistralKey(): string | null {
    const key = process.env.MISTRAL_API_KEY;
    return key && key !== 'your_mistral_api_key' ? key : null;
  }

  // ─── Чат ─────────────────────────────────────────────────────────────────

  async chat(body: ChatMessage): Promise<ChatResponse> {
    const events = await this.prisma.event.findMany({
      where: { status: 'APPROVED' },
      orderBy: { attendeesCount: 'desc' },
      take: 50,
      select: {
        id: true, title: true, description: true, category: true,
        date: true, location: true, city: true, price: true, attendeesCount: true,
        imageUrl: true, maxAttendees: true, organizerId: true,
        latitude: true, longitude: true, status: true,
        createdAt: true, updatedAt: true,
      },
    });

    if (this.mistralKey) {
      return this.chatWithMistral(body.message, events as unknown as Event[]);
    }

    return this.ruleBasedReply(body.message, events as unknown as Event[]);
  }

  // ─── Mistral через axios (без SDK) ────────────────────────────────────────

  private async chatWithMistral(message: string, events: Event[]): Promise<ChatResponse> {
    try {
      const eventsContext = events.slice(0, 20).map((e) => {
        const price = e.price === 0 ? 'бесплатно' : `${Math.round(e.price)} ₸`;
        const date = new Date(e.date).toLocaleDateString('ru-RU', {
          day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit',
        });
        return `- ${e.title} | ${e.category} | ${date} | ${e.city}, ${e.location} | ${price}`;
      }).join('\n');

      const systemPrompt =
        `Ты — дружелюбный ИИ-ассистент приложения Jastar Hub, помогающий находить мероприятия в Казахстане.\n\n` +
        `Доступные события:\n${eventsContext}\n\n` +
        `Правила:\n` +
        `- Отвечай на русском языке, кратко и по делу\n` +
        `- Используй эмодзи\n` +
        `- Если спрашивают о событиях — ищи в списке выше, формат: • **Название** — дата, место (цена)\n` +
        `- Не выдумывай события которых нет в списке\n` +
        `- В самом конце ответа добавь строку: SUGGESTIONS: подсказка1|подсказка2|подсказка3`;

      const response = await axios.post(
        MISTRAL_API_URL,
        {
          model: 'mistral-small-latest',
          messages: [
            { role: 'system', content: systemPrompt },
            { role: 'user', content: message },
          ],
          max_tokens: 600,
          temperature: 0.7,
        },
        {
          headers: {
            Authorization: `Bearer ${this.mistralKey}`,
            'Content-Type': 'application/json',
          },
          timeout: 20000,
        },
      );

      const raw: string = response.data?.choices?.[0]?.message?.content ?? '';

      // Парсим подсказки из строки SUGGESTIONS: ...
      const suggestionsMatch = raw.match(/SUGGESTIONS:\s*(.+)$/m);
      let suggestions: string[] = [];
      let reply = raw;

      if (suggestionsMatch) {
        suggestions = suggestionsMatch[1]
          .split('|')
          .map((s) => s.trim())
          .filter(Boolean)
          .slice(0, 4);
        reply = raw.replace(suggestionsMatch[0], '').trim();
      }

      return { reply: reply || raw, suggestions };
    } catch (err: any) {
      this.logger.error(`Mistral error: ${err?.message ?? err}`);
      // Если Mistral упал — тихо переключаемся на rule-based
      return this.ruleBasedReply(message, events);
    }
  }

  // ─── Rule-based fallback ──────────────────────────────────────────────────

  private ruleBasedReply(message: string, events: Event[]): ChatResponse {
    const msg = message.toLowerCase().trim();

    if (/привет|здравствуй|hello|hi|салем|сәлем/.test(msg)) {
      return {
        reply:
          'Привет! 👋 Я ИИ-ассистент Jastar Hub.\n\n' +
          'Могу помочь найти события, ответить на вопросы или порекомендовать что-то интересное.\n\n' +
          'Попробуй спросить:\n• «Что есть бесплатного?»\n• «Покажи IT события»\n• «Что популярно сейчас?»',
        suggestions: ['Бесплатные события', 'IT события', 'Популярное'],
      };
    }

    if (/помог|help|что умеешь|что ты/.test(msg)) {
      return {
        reply:
          'Я умею:\n\n' +
          '🔍 Искать события по категории или ключевому слову\n' +
          '🎉 Показывать бесплатные мероприятия\n' +
          '🔥 Рассказывать о популярных событиях\n' +
          '📅 Показывать ближайшие мероприятия',
        suggestions: ['IT события', 'Бесплатные', 'Популярное'],
      };
    }

    if (/бесплатн|free|тегін/.test(msg)) {
      const free = events.filter((e) => e.price === 0).slice(0, 5);
      if (!free.length) return { reply: 'Сейчас бесплатных событий нет 🙂', suggestions: [] };
      return {
        reply: 'Бесплатные мероприятия 🎉\n\n' + free.map(this.formatEvent).join('\n'),
        suggestions: ['IT события', 'Спорт', 'Популярное'],
      };
    }

    if (/популярн|тренд|топ/.test(msg)) {
      const top = [...events].sort((a, b) => b.attendeesCount - a.attendeesCount).slice(0, 5);
      return {
        reply: 'Самые популярные 🔥\n\n' + top.map(this.formatEvent).join('\n'),
        suggestions: ['Бесплатные', 'IT события'],
      };
    }

    if (/ближайш|скоро|сегодня|завтра/.test(msg)) {
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

    const category = this.detectCategory(msg);
    if (category) {
      const found = events.filter((e) => e.category.toLowerCase() === category).slice(0, 5);
      if (!found.length) {
        return { reply: `По категории «${category}» пока ничего нет 🔍`, suggestions: ['Бесплатные', 'Популярное'] };
      }
      return {
        reply: 'Нашёл события 🔎\n\n' + found.map(this.formatEvent).join('\n'),
        suggestions: ['Бесплатные', 'Популярное'],
      };
    }

    // Полнотекстовый поиск
    const q = message.toLowerCase();
    const found = events
      .filter(
        (e) =>
          e.title.toLowerCase().includes(q) ||
          e.description.toLowerCase().includes(q) ||
          e.city.toLowerCase().includes(q),
      )
      .slice(0, 5);

    if (found.length) {
      return {
        reply: `По запросу «${message}» 🔍\n\n` + found.map(this.formatEvent).join('\n'),
        suggestions: [],
      };
    }

    return {
      reply:
        `Не нашёл ничего по «${message}» 🤔\n\n` +
        'Попробуй: «IT события», «бесплатные», «популярное».',
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

    if (!user || !events.length) return this.getTrending(10);

    const interests = user.interests ?? [];
    if (!interests.length) return this.getTrending(10);

    const maxAtt = Math.max(...events.map((e) => e.attendeesCount), 1);

    return events
      .map((event) => {
        const text = `${event.title} ${event.description} ${event.category}`.toLowerCase();
        const contentScore = interests.reduce(
          (acc, i) => acc + (text.includes(i.toLowerCase()) ? 1 : 0),
          0,
        );
        const popularityScore = event.attendeesCount / maxAtt;
        return { event, score: contentScore * 0.7 + popularityScore * 0.3 };
      })
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

    const targetWords = new Set(
      `${target.title} ${target.description} ${target.category} ${target.city}`
        .toLowerCase()
        .split(/\s+/)
        .filter((w) => w.length > 3),
    );

    return events
      .map((event) => {
        const words = `${event.title} ${event.description} ${event.category} ${event.city}`
          .toLowerCase()
          .split(/\s+/)
          .filter((w) => w.length > 3);
        const intersection = words.filter((w) => targetWords.has(w)).length;
        const union = new Set([...targetWords, ...words]).size;
        const score =
          (union > 0 ? intersection / union : 0) +
          (event.category === target.category ? 0.3 : 0);
        return { event, score };
      })
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
    const date = new Date(event.date).toLocaleDateString('ru-RU', {
      day: 'numeric',
      month: 'short',
      hour: '2-digit',
      minute: '2-digit',
    });
    return `• **${event.title}** — ${date}, ${event.location} (${price})`;
  }

  private detectCategory(msg: string): string | null {
    for (const [kw, cat] of Object.entries(CATEGORY_KEYWORDS)) {
      if (msg.includes(kw)) return cat;
    }
    return null;
  }
}
