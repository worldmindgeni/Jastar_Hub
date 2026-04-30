"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RecommendationsService = void 0;
const common_1 = require("@nestjs/common");
const axios_1 = require("@nestjs/axios");
const rxjs_1 = require("rxjs");
let RecommendationsService = class RecommendationsService {
    httpService;
    AI_SERVICE_URL = process.env.AI_SERVICE_URL || 'http://localhost:8000';
    constructor(httpService) {
        this.httpService = httpService;
    }
    async getRecommendations(userId) {
        try {
            const response = await (0, rxjs_1.firstValueFrom)(this.httpService.get(`${this.AI_SERVICE_URL}/recommend/${userId}`));
            return response.data;
        }
        catch (error) {
            console.error('AI Service unreachable, returning empty recommendations');
            return [];
        }
    }
};
exports.RecommendationsService = RecommendationsService;
exports.RecommendationsService = RecommendationsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [axios_1.HttpService])
], RecommendationsService);
//# sourceMappingURL=recommendations.service.js.map