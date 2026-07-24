import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/provider/chat_provider.dart';
import 'package:mainsupabase_projuct/features/ai_coach.dart/widgets/session_tile.dart';
import 'package:provider/provider.dart';



class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.psychology_alt),
                  SizedBox(width: 12),
                  Text(
                    'MindSort AI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilledButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  await provider.createSession();
                },
                icon: const Icon(Icons.add),
                label: const Text('New Chat'),
              ),
            ),

            const SizedBox(height: 12),

            const Divider(height: 1),

            Expanded(
              child: provider.sessions.isEmpty
                  ? const Center(
                      child: Text(
                        'No conversations yet',
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.sessions.length,
                      itemBuilder: (context, index) {
                        final session = provider.sessions[index];

                        return SessionTile(
                          session: session,
                          isSelected:
                              provider.currentSession?.id ==
                                  session.id,
                          onTap: () async {
                            Navigator.pop(context);

                            await provider.selectSession(session.id);
                          },
                          onDelete: () async {
                            await provider.deleteSession(
                              session.id,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}