import OpenAI from "npm:openai";

import { AIInsightResponse } from "./types.ts";

const client = new OpenAI({
  apiKey: Deno.env.get("GROQ_API_KEY")!,
  baseURL: "https://api.groq.com/openai/v1",
});

export async function generateInsight(
  prompt: string,
): Promise<AIInsightResponse> {
  const completion = await client.chat.completions.create({
    model: "llama-3.3-70b-versatile",

    temperature: 0.6,

    response_format: {
      type: "json_object",
    },

    messages: [
      {
        role: "system",
        content:
          "Always respond with valid JSON containing summary and motivation.",
      },
      {
        role: "user",
        content: prompt,
      },
    ],
  });

  const text = completion.choices[0].message.content;

  if (!text) {
    throw new Error("Groq returned an empty response.");
  }

  return JSON.parse(text) as AIInsightResponse;
}