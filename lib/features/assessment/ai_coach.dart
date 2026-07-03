import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_duration.dart';
import '../../core/theme/app_text_styles.dart';

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
      'text': AppText.coachHello,
      'time': '10:00 AM'
    },
  ];

  final List<String> _suggestedPrompts = [
    AppText.promptStructureDay,
    AppText.promptBrainstormProject,
    AppText.promptFocusHabits,
    AppText.promptProcessStress
  ];

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: AppDuration.welcomeGlow,
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
          duration: AppDuration.coachScroll,
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
        'time': AppText.timeJustNow,
      });
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    Future.delayed(AppDuration.coachResponseDelay, () {
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
          'time': AppText.timeJustNow,
        });
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl, vertical: AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.white.withOpacity(0.06),
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
                                AppColors.primaryAccent,
                                AppColors.secondaryAccent,
                                AppColors.transparent
                              ],
                              stops: [0.1, 0.7, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryAccent.withOpacity(0.35),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            AppIcons.coach,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: AppSizes.mlg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppText.coachHeaderName,
                          style: AppTextStyles.coachHeaderTitle,
                        ),
                        const SizedBox(height: AppSizes.xxs),
                        Text(
                          AppText.coachOnlineSub,
                          style: AppTextStyles.coachHeaderSub,
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
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxl, vertical: AppSizes.xxxl),
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
                    margin: const EdgeInsets.only(bottom: AppSizes.xl),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.76,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.mlg),
                    decoration: BoxDecoration(
                      color: isCoach
                          ? AppColors.white.withOpacity(0.04)
                          : AppColors.primaryAccent.withOpacity(0.85),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: isCoach ? Radius.zero : const Radius.circular(20),
                        bottomRight: isCoach ? const Radius.circular(20) : Radius.zero,
                      ),
                      border: isCoach
                          ? Border.all(
                              color: AppColors.white.withOpacity(0.08),
                            )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text']!,
                          style: AppTextStyles.coachMessageText,
                        ),
                        const SizedBox(height: AppSizes.sxs),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            msg['time']!,
                            style: isCoach
                                ? AppTextStyles.coachMessageTimeCoach
                                : AppTextStyles.coachMessageTimeUser,
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
              margin: const EdgeInsets.only(bottom: AppSizes.md),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                physics: const BouncingScrollPhysics(),
                itemCount: _suggestedPrompts.length,
                itemBuilder: (context, index) {
                  final prompt = _suggestedPrompts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.sm),
                    child: ActionChip(
                      backgroundColor: AppColors.white.withOpacity(0.04),
                      side: BorderSide(
                        color: AppColors.white.withOpacity(0.06),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.r16,
                      ),
                      label: Text(
                        prompt,
                        style: AppTextStyles.coachChipLabel,
                      ),
                      onPressed: () => _sendMessage(prompt),
                    ),
                  );
                },
              ),
            ),

          // Message input field
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.xxl, right: AppSizes.xxl, bottom: AppSizes.lg, top: AppSizes.sm),
            child: ClipRRect(
              borderRadius: AppRadius.r20,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.04),
                    borderRadius: AppRadius.r20,
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: AppTextStyles.coachInputText,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: AppText.messageCoachHint,
                            hintStyle: AppTextStyles.coachInputHint,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.xxl, vertical: AppSizes.mlg),
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
                                colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                              ),
                            ),
                            child: const Icon(
                              AppIcons.send,
                              color: AppColors.white,
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
        margin: const EdgeInsets.only(bottom: AppSizes.xl),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.mlg),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.04),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(
            color: AppColors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: AppSizes.xs),
            _buildDot(150),
            const SizedBox(width: AppSizes.xs),
            _buildDot(300),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int delayMs) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: AppDuration.coachDotAnim,
      curve: Curves.easeInOut,
      onEnd: () {},
      builder: (context, value, child) {
        return Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.primaryAccent,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
