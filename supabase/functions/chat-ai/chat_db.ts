import { SupabaseClient } from "https://esm.sh/@supabase/supabase-js@2";
import { ChatMessage } from "./types.ts";

export async function verifySession(
  supabase: SupabaseClient,
  sessionId: string,
  userId: string,
): Promise<boolean> {
  const { data, error } = await supabase
    .from("chat_sessions")
    .select("id")
    .eq("id", sessionId)
    .eq("user_id", userId)
    .maybeSingle();

  if (error) {
    throw error;
  }

  return data !== null;
}

export async function saveMessage(
  supabase: SupabaseClient,
  sessionId: string,
  role: "user" | "assistant",
  content: string,
): Promise<void> {
  const { error } = await supabase
    .from("chat_messages")
    .insert({
      session_id: sessionId,
      role,
      content,
    });

  if (error) {
    throw error;
  }
}

export async function getConversationHistory(
  supabase: SupabaseClient,
  sessionId: string,
  limit = 20,
): Promise<ChatMessage[]> {
  const { data, error } = await supabase
    .from("chat_messages")
    .select("*")
    .eq("session_id", sessionId)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) {
    throw error;
  }

  return (data ?? []).reverse();
}

export async function updateSessionTitle(
  supabase: SupabaseClient,
  sessionId: string,
  title: string,
) {
  const { error } = await supabase
    .from("chat_sessions")
    .update({
      title,
      updated_at: new Date().toISOString(),
    })
    .eq("id", sessionId);

  if (error) {
    throw error;
  }
}

export async function getSessionTitle(
  supabase: SupabaseClient,
  sessionId: string,
): Promise<string> {
  const { data, error } = await supabase
    .from("chat_sessions")
    .select("title")
    .eq("id", sessionId)
    .single();

  if (error) {
    throw error;
  }

  return data.title;
}