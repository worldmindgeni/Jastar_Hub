import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

// Пингует сам себя каждые 10 минут, чтобы Render не усыплял сервис
@Injectable()
export class KeepAliveService {
  private readonly logger = new Logger(KeepAliveService.name);
  private readonly selfUrl = process.env.RENDER_EXTERNAL_URL ?? 'http://localhost:3000';

  constructor(private readonly http: HttpService) {}

  @Cron(CronExpression.EVERY_10_MINUTES)
  async ping() {
    try {
      await firstValueFrom(this.http.get(`${this.selfUrl}/health`));
      this.logger.log('Keep-alive ping OK');
    } catch {
      // Молча игнорируем — сервер мог только что стартовать
    }
  }
}
