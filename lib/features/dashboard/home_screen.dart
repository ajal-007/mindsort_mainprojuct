import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_text.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_duration.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/cyber_grid_painter.dart';
import '../../shared/widgets/glowing_orb.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../thoughts/thoughts_page.dart';
import '../assessment/ai_coach.dart';
import 'insight.dart';
import '../profile/profile.dart';

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

    final userId = context.read<AuthProvider>().getCurrentUser()?.id ?? '';
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    Future.microtask(() => profileProvider.loadUserProfile(userId));
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
      _buildHomeBody(context),
      const ThoughtsPage(),
      const AICoach(),
      const Insight(),
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

  Widget _buildHomeBody(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final authProvider = context.read<AuthProvider>();

    if (profileProvider.isLoading && profileProvider.profileData == null) {
      return _buildLoadingState();
    }

    final profile = profileProvider.profileData;
    final username = profile?[AppText.usernameLabel.toLowerCase()] ?? AppText.defaultExplorer;
    final email = profile?[AppText.emailAddressLabel.toLowerCase()] ?? authProvider.getCurrentUser()?.email ?? '';

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl, vertical: AppSizes.huge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderSection(username, email),
              const SizedBox(height: AppSizes.huge),
              _buildDashboardCard(),
              const SizedBox(height: AppSizes.huge),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.massive),
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: AppRadius.r28,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightAccentGlow),
              strokeWidth: 3,
            ),
            const SizedBox(height: AppSizes.xxl),
            Text(
              AppText.loadingWorkspace,
              style: AppTextStyles.homeLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String username, String email) {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : 'U';
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryAccent.withOpacity(0.35),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: AppColors.white.withOpacity(0.2),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: AppTextStyles.homeInitialText,
          ),
        ),
        const SizedBox(height: AppSizes.xxxl),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.white, AppColors.lightAccentGlow],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            '${AppText.helloPrefix}$username',
            style: AppTextStyles.homeHeaderTitle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          email,
          style: AppTextStyles.homeHeaderEmail,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDashboardCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.giant),
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: AppRadius.r28,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.35),
            blurRadius: 40,
            spreadRadius: -4,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.msm),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withOpacity(0.12),
                  borderRadius: AppRadius.r12,
                  border: Border.all(
                    color: AppColors.primaryAccent.withOpacity(0.25),
                  ),
                ),
                child: const Icon(
                  AppIcons.psychology,
                  color: AppColors.lightAccentGlow,
                  size: AppSizes.xxxl,
                ),
              ),
              const SizedBox(width: AppSizes.mlg),
              const Expanded(
                child: Text(
                  AppText.workspaceTitle,
                  style: AppTextStyles.homeDashboardTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xxl),
          Text(
            AppText.workspaceDesc,
            style: AppTextStyles.homeDashboardDesc,
          ),
          const SizedBox(height: AppSizes.xxxl),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.greenAccent,
                ),
              ),
              const SizedBox(width: AppSizes.msm),
              const Text(
                AppText.cloudSyncActive,
                style: AppTextStyles.homeDashboardSync,
              ),
            ],
          ),
        ],
      ),
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
            icon: Icon(AppIcons.psychology),
            label: AppText.thoughtsLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.coach),
            label: AppText.coachLabel,
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.insight),
            label: AppText.insightLabel,
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
