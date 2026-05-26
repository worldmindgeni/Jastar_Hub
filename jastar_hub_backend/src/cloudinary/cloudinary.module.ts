import { Module, Global } from '@nestjs/common';
import { CloudinaryService } from './cloudinary.service';

// Global — чтобы не импортировать в каждый модуль отдельно
@Global()
@Module({
  providers: [CloudinaryService],
  exports: [CloudinaryService],
})
export class CloudinaryModule {}
