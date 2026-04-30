import { RecommendationsService } from './recommendations.service';
export declare class RecommendationsController {
    private readonly recService;
    constructor(recService: RecommendationsService);
    getRecommendations(req: any): Promise<any>;
}
