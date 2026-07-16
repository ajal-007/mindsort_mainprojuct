import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_icons.dart';
import 'core/constants/app_text.dart';
import 'core/constants/app_duration.dart';
import 'shared/widgets/cyber_grid_painter.dart';
import 'shared/widgets/glowing_orb.dart';
import 'features/ai_coach.dart/ai_coach_page.dart';
import 'features/dashboard/mental_dashboard.dart';
import 'features/profile/profile_page.dart';
import 'features/daily_challenges/presentation/screens/journey_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _orbController;
  late final AnimationController _entranceController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
  late final Animation<double> _orbFloat;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: AppDuration.homeOrb,
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: AppDuration.homeEntrance,
    )..forward();

    _fadeIn = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.1, 0.9, curve: Curves.easeOutCubic),
    ));

    _orbFloat = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _orbController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _orbController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const Insight(),
      const JourneyScreen(),
      const AICoach(),
      const Profile(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Gradient and Animated Orbs
          AnimatedBuilder(
            animation: _orbController,
            builder: (context, _) {
              final t = _orbController.value;
              return Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.backgroundDark, AppColors.surfaceDark],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -80 + _orbFloat.value,
                    left: -60 + (t * 30),
                    child: GlowingOrb(size: 340, color: AppColors.primaryAccent, opacity: 0.15),
                  ),
                  Positioned(
                    bottom: -100 + _orbFloat.value,
                    right: -80 + (t * 40),
                    child: GlowingOrb(size: 380, color: AppColors.secondaryAccent, opacity: 0.12),
                  ),
                ],
              );
            },
          ),

          // Cyber Grid Overlay
          CustomPaint(
            painter: CyberGridPainter(color: AppColors.white.withOpacity(0.02)),
            child: const SizedBox.expand(),
          ),

          // Main View Switcher
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: pages[_currentIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.black,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.black,
        selectedItemColor: AppColors.lightAccentGlow,
        unselectedItemColor: AppColors.white.withOpacity(0.38),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(AppIcons.dashboard),
            label: AppText.homeLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.challenges),
            label: AppText.challengesLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.coach),
            label: AppText.coachLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.person),
            label: AppText.profileLabel,
          ),
        ],
      ),
    );
  }
}
