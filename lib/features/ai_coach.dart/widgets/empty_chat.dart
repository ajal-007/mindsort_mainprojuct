import 'package:flutter/material.dart';

class EmptyChat extends StatelessWidget {
  const EmptyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.psychology_alt,
              size: 72,
            ),
            SizedBox(height: 20),
            Text(
              "MindSort AI",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Start a conversation.\nI'm here to help you organize your thoughts.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}