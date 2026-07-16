import { corsHeaders } from "./cors.ts";
import { buildChallengePrompt } from "./prompt.ts";
import { generateChallenges } from "./groq.ts";
import { ChallengeRequest } from "./types.ts";

Deno.serve(async (req) => {
  // 1. Handle HTTP OPTIONS preflight requests
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const body: ChallengeRequest = await req.json();

    const prompt = buildChallengePrompt(body);

    const response = await generateChallenges(prompt);

    // 2. Return the main successful response with CORS headers
    return new Response(
      JSON.stringify(response),
      {
        status: 200,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (error) {
    console.error("Error in challenge-ai function:", error);

    // 3. Return the error response with CORS headers
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
