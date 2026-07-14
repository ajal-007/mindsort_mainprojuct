import { corsHeaders } from "./cors.ts";
import { buildChallengePrompt } from "./prompt.ts";
import { generateChallenges } from "./groq.ts";
import { ChallengeRequest } from "./types.ts";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders,
    });
  }

  try {
    const body: ChallengeRequest = await req.json();

    const prompt = buildChallengePrompt(body);

    const response = await generateChallenges(prompt);

    return new Response(
      JSON.stringify(response),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (error) {
    console.error(error);

    return new Response(
      JSON.stringify({
        error:
          error instanceof Error
              ? error.message
              : "Unknown error",
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  }
});