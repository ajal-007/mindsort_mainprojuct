import OpenAI from "openai";

import { ChallengeResponse } from "./types.ts";

const client = new OpenAI({
  apiKey: Deno.env.get("GROQ_API_KEY")!,
  baseURL: "https://api.groq.com/openai/v1",
});

export async function generateChallenges(
  prompt: string,
): Promise<ChallengeResponse> {
  const completion = await client.chat.completions.create({
    model: "llama-3.3-70b-versatile",

    temperature: 0.8,

    response_format: {
      type: "json_object",
    },

    messages: [
      {
        role: "system",
        content:
          "You are MindSort AI. Always return ONLY valid JSON matching the requested schema.",
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

  return JSON.parse(text) as ChallengeResponse;
}