import { GoogleGenAI, Type } from "npm:@google/genai";

import { AIInsightResponse } from "./types.ts";

const ai = new GoogleGenAI({
  apiKey: Deno.env.get("GEMINI_API_KEY")!,
});

export async function generateInsight(
  prompt: string,
): Promise<AIInsightResponse> {
  const envModel = Deno.env.get("GEMINI_MODEL");
  const modelsToTry = envModel ? [envModel] : ['gemini-2.5-pro'];

  let lastError: Error | null = null;

  for (const modelName of modelsToTry) {
    try {
      const response = await ai.models.generateContent({
        model: modelName,
        contents: prompt,
        config: {
          responseMimeType: "application/json",
          responseSchema: {
            type: Type.OBJECT,
            properties: {
              summary: {
                type: Type.STRING,
              },
              motivation: {
                type: Type.STRING,
              },
            },
            required: [
              "summary",
              "motivation",
            ],
          },
        },
      });

      if (!response.text) {
        throw new Error("Gemini returned an empty response.");
      }

      return JSON.parse(response.text) as AIInsightResponse;
    } catch (err) {
      lastError = err instanceof Error ? err : new Error(String(err));
      const errMsg = lastError.message.toLowerCase();
      
      // If the model is not found, deprecated, or unavailable, try the next model
      if (
        errMsg.includes("not found") ||
        errMsg.includes("404") ||
        errMsg.includes("no longer available") ||
        errMsg.includes("not supported")
      ) {
        console.warn(`Model ${modelName} not available or supported, trying next model in list...`);
        continue;
      }
      
      // For rate limits / quota errors (429) or other API errors, throw immediately
      throw lastError;
    }
  }

  throw lastError || new Error("No generative AI models were available.");
}