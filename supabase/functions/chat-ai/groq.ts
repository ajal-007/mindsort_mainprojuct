const GROQ_API_KEY = Deno.env.get("GROQ_API_KEY");

export async function generateReply(
  prompt: string,
): Promise<string> {
  if (!GROQ_API_KEY) {
    throw new Error("Missing GROQ_API_KEY");
  }

  const response = await fetch(
    "https://api.groq.com/openai/v1/chat/completions",
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${GROQ_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "llama-3.3-70b-versatile",
        messages: [
          {
            role: "user",
            content: prompt,
          },
        ],
        temperature: 0.7,
        max_tokens: 500,
      }),
    },
  );

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Groq API Error: ${error}`);
  }

  const data = await response.json();

  return data.choices[0].message.content.trim();
}


export async function generateTitle(
  prompt: string,
): Promise<string> {
  if (!GROQ_API_KEY) {
    throw new Error("Missing GROQ_API_KEY");
  }

  const response = await fetch(
    "https://api.groq.com/openai/v1/chat/completions",
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${GROQ_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "llama-3.3-70b-versatile",
        messages: [
          {
            role: "user",
            content: prompt,
          },
        ],
        temperature: 0.2,
        max_tokens: 20,
      }),
    },
  );

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Groq API Error: ${error}`);
  }

  const data = await response.json();

  return data.choices[0].message.content.trim();
}