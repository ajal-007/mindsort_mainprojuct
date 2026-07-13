export interface DashboardRequest {
  id: string;
  userId: string;

  overallClarity: number;
  mentalStage: string;

  stressScore: number;
  focusScore: number;
  emotionScore: number;
  productivityScore: number;

  assessmentNumber: number;
  assessmentDate: string;
}

export interface AIInsightResponse {
  summary: string;
  motivation: string;
}