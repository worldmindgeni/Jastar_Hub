import { HttpService } from '@nestjs/axios';
export declare class RecommendationsService {
    private readonly httpService;
    private readonly AI_SERVICE_URL;
    constructor(httpService: HttpService);
    getRecommendations(userId: string): Promise<any>;
}
