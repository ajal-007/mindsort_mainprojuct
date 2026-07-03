import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:mainsupabase_projuct/constants/color_constant.dart';

class AICoach extends StatefulWidget {
  const AICoach({super.key});

  @override
  State<AICoach> createState() => _AICoachState();
}

class _AICoachState extends State<AICoach> with SingleTickerProviderStateMixin {
  late final AnimationController _orbController;
  late final Animation<double> _orbPulse;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'coach',
      'text': 'Hello! I am your MindSort AI Coach. What is currently occupying your mind? We can organize your thoughts, explore ideas, or find steps to destress.',
      'time': '10:00 AM'
    },
  ];

  final List<String> _suggestedPrompts = [
    'Help me structure my day',
    'I want to brainstorm a new project',
    'Explain how to build focus habits',
    'Help me process some stress'
  ];

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _orbPulse = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _orbController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _orbController.dispose();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text,
        'time': 'Just now',
      });
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      String response = "That sounds fascinating. Let's break that down into three actionable steps. How can we simplify the first hurdle you foresee?";
      if (text.toLowerCase().contains('day')) {
        response = "To structure your day, let's start with your top 3 non-negotiables. What are the three absolute priorities you need to complete today?";
      } else if (text.toLowerCase().contains('brainstorm') || text.toLowerCase().contains('project')) {
        response = "Exciting! A new project is a blank canvas. What is the core problem this project solves? Understanding that will define everything else.";
      } else if (text.toLowerCase().contains('focus') || text.toLowerCase().contains('habit')) {
        response = "Habit formation starts with friction reduction. To build focus habits, identify one environmental trigger you can remove. What distracts you first?";
      } else if (text.toLowerCase().contains('stress')) {
        response = "Take a slow deep breath. Let's do a brain dump. Write down everything that is bothering you in a list, without formatting. Let's empty the tank first.";
      }

      setState(() {
        _messages.add({
          'sender': 'coach',
          'text': response,
          'time': 'Just now',
        });
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _orbPulse,
                    builder: (context, _) {
                      return Transform.scale(
                        scale: _orbPulse.value,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [
                                MindSortColors.accent,
                                MindSortColors.blueAccent,
                                Colors.transparent
                              ],
                              stops: [0.1, 0.7, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: MindSortColors.accent.withOpacity(0.35),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Coach MindSort',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Online | Cognitive Guide',
                          style: TextStyle(
                            color: Colors.greenAccent.withOpacity(0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Messages View
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[index];
                final isCoach = msg['sender'] == 'coach';

                return Align(
                  alignment: isCoach ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.76,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: isCoach
                          ? Colors.white.withOpacity(0.04)
                          : MindSortColors.accent.withOpacity(0.85),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: isCoach ? Radius.zero : const Radius.circular(20),
                        bottomRight: isCoach ? const Radius.circular(20) : Radius.zero,
                      ),
                      border: isCoach
                          ? Border.all(
                              color: Colors.white.withOpacity(0.08),
                            )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msg['time']!,
                            style: TextStyle(
                              color: isCoach
                                  ? Colors.white30
                                  : Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Suggestion chips
          if (_messages.length == 1 && !_isTyping)
            Container(
              height: 48,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: _suggestedPrompts.length,
                itemBuilder: (context, index) {
                  final prompt = _suggestedPrompts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      backgroundColor: Colors.white.withOpacity(0.04),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.06),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      label: Text(
                        prompt,
                        style: const TextStyle(
                          color: MindSortColors.accentGlow,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _sendMessage(prompt),
                    ),
                  );
                },
              ),
            ),

          // Message input field
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'Message Coach...',
                            hintStyle: TextStyle(color: Colors.white30, fontSize: 15),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          onSubmitted: _sendMessage,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: GestureDetector(
                          onTap: () => _sendMessage(_messageController.text),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [MindSortColors.accent, MindSortColors.blueAccent],
                              ),
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(150),
            const SizedBox(width: 4),
            _buildDot(300),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int delayMs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      onEnd: () {},
      builder: (context, value, child) {
        return Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: MindSortColors.accent,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
