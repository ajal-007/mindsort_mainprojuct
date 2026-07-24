import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

import { corsHeaders } from "./cors.ts";
import { ChatRequest } from "./types.ts";

import {
  verifySession,
  saveMessage,
  getConversationHistory,
  getSessionTitle,
  updateSessionTitle,
} from "./chat_db.ts";

import {
  buildChatPrompt,
  buildTitlePrompt,
} from "./prompt.ts";

import {
  generateReply,
  generateTitle,
} from "./groq.ts";

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders,
    });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const supabaseKey =
    Deno.env.get("SUPABASE_PUBLISHABLE_KEY") ??
    Deno.env.get("SUPABASE_ANON_KEY")!;

  try {
    // Create authenticated Supabase client
    const supabase = createClient(
      supabaseUrl,
      supabaseKey,
      {
        global: {
          headers: {
            Authorization: req.headers.get("Authorization") ?? "",
          },
        },
      },
    );

    // Get authenticated user
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Unauthorized",
        }),
        {
          status: 401,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    // Parse request
    const body: ChatRequest = await req.json();

    // Verify chat session
    const sessionExists = await verifySession(
      supabase,
      body.sessionId,
      user.id,
    );

    if (!sessionExists) {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Chat session not found.",
        }),
        {
          status: 404,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    // Save user's message
    await saveMessage(
      supabase,
      body.sessionId,
      "user",
      body.message,
    );

    // Load conversation history
    const history = await getConversationHistory(
      supabase,
      body.sessionId,
    );

    // Generate title only for new chats
    let sessionTitle = await getSessionTitle(
      supabase,
      body.sessionId,
    );

    if (sessionTitle == "New Chat") {
      const titlePrompt = buildTitlePrompt(
        body.message,
      );

      sessionTitle = await generateTitle(
        titlePrompt,
      );

      await updateSessionTitle(
        supabase,
        body.sessionId,
        sessionTitle,
      );
    }

    // Build AI prompt
    const prompt = buildChatPrompt(
      history,
      body.message,
    );

    // Generate AI response
    const aiReply = await generateReply(
      prompt,
    );

    // Save assistant message
    await saveMessage(
      supabase,
      body.sessionId,
      "assistant",
      aiReply,
    );

    // Return response
    return new Response(
      JSON.stringify({
        success: true,
        title: sessionTitle,
        reply: {
          role: "assistant",
          content: aiReply,
        },
      }),
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
        success: false,
        error: error instanceof Error
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