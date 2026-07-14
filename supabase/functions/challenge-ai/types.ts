export interface ChallengeRequest {
  currentDay: number;

  difficulty: string;

  overallClarity: number;

  mentalStage: string;

  stressScore: number;

  focusScore: number;

  emotionScore: number;

  productivityScore: number;
}

export interface ChallengeItem {
  title: string;

  description: string;

  estimatedMinutes: number;
}

export interface ChallengeResponse {
  challenges: ChallengeItem[];
}