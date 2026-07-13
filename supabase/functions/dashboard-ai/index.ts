import { corsHeaders } from "./cors.ts";
import { buildDashboardPrompt } from "./prompt.ts";
import { generateInsight } from "./groq.ts";
import { DashboardRequest } from "./types.ts";

Deno.serve(async (req) => {

  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders,
    });
  }

  try {
    const dashboard: DashboardRequest = await req.json();

    const prompt = buildDashboardPrompt(dashboard);

    const insight = await generateInsight(prompt);

    return new Response(
      JSON.stringify(insight),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (error) {
    console.error("Error in dashboard-ai function:", error);

    let errorMessage = "An unexpected error occurred while generating AI insights.";
    let status = 500;

    const errorStr = error instanceof Error ? error.message : String(error);
    const lowerErrorStr = errorStr.toLowerCase();

    if (
      lowerErrorStr.includes("quota") ||
      lowerErrorStr.includes("limit") ||
      lowerErrorStr.includes("429") ||
      lowerErrorStr.includes("resource_exhausted") ||
      lowerErrorStr.includes("resource exhausted")
    ) {
      errorMessage = "AI service quota exceeded. Please check your Gemini API plan or try again later.";
      status = 429;
    } else {
      errorMessage = error instanceof Error ? error.message : String(error);
    }

    return new Response(
      JSON.stringify({
        error: errorMessage,
      }),
      {
        status: status,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  }
});