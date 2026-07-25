import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/provider/chat_provider.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/widgets/chat_drawer.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/widgets/chat_input_field.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/widgets/chat_message_list.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/widgets/empty_chat.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/widgets/typing_indicator.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;
  void _scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
}

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initialize();
    });
  }
  @override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MindSort AI")),

      drawer: const ChatDrawer(),

      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.messages.isEmpty) {
                  return const EmptyChat();
                }

                if (provider.messages.length != _lastMessageCount) {
                  _lastMessageCount = provider.messages.length;
                  _scrollToBottom();
                }
                return ChatMessageList(
                  messages: provider.messages,
                  scrollController: _scrollController,
                );
              },
            ),
          ),

          Consumer<ChatProvider>(
            builder: (context, provider, child) {
              if (provider.isSending) {
                return const TypingIndicator();
              }
              return const SizedBox.shrink();
            },
          ),

          Consumer<ChatProvider>(
            builder: (context, provider, child) {
              return ChatInputField(
                key: const ValueKey('chat_input_field'),
                isSending: provider.isSending,
                onSend: provider.sendMessage,
              );
            },
          ),
        ],
      ),
    );
  }
}
