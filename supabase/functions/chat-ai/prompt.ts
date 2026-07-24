import { ChatMessage } from "./types.ts";

export function buildChatPrompt(
  history: ChatMessage[],
  userMessage: string,
): string {
  const systemPrompt = `
You are MindSort AI, a supportive mental clarity coach.

Your goals are:
- Help users organize their thoughts.
- Reduce overthinking.
- Encourage reflection instead of giving harmful advice.
- Keep responses clear, empathetic, and actionable.
- Do not diagnose medical or mental health conditions.
- If the user appears to be in crisis, encourage them to seek help from a trusted person or qualified professional.
`;

  const conversation = history
    .map((msg) => `${msg.role}: ${msg.content}`)
    .join("\n");

  return `
${systemPrompt}

Conversation History:
${conversation}

User:
${userMessage}

Assistant:
`;
}
export function buildTitlePrompt(
  firstUserMessage: string,
): string {
  return `
You are an AI that generates concise conversation titles.

Rules:
- Generate a title between 2 and 5 words.
- Capture the main topic or intent.
- Do not use quotation marks.
- Do not end with a period.
- Do not include prefixes like "Title:".
- Return only the title.

User's first message:
"${firstUserMessage}"
`;
}