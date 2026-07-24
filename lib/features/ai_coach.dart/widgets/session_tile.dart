import 'package:flutter/material.dart';

import 'package:mainsupabase_projuct/features/ai_coach.dart/models/chat_session_model.dart';

class SessionTile extends StatelessWidget {
  final ChatSessionModel session;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const SessionTile({
    super.key,
    required this.session,
    required this.isSelected,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      selectedTileColor: Theme.of(context)
          .colorScheme
          .primary
          .withOpacity(.08),
      leading: const Icon(Icons.chat_bubble_outline),
      title: Text(
        session.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: onDelete == null
          ? null
          : IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
            ),
      onTap: onTap,
    );
  }
}