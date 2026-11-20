import 'package:flutter/material.dart';
import 'package:mainsupabase_projuct/features/assessment/assasment_screen.dart';
import 'package:mainsupabase_projuct/features/assessment/provider/assasment_provider.dart';
import 'package:mainsupabase_projuct/features/profile/models/profile_stats_model.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';

import '../../authentication/provider/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../../../shared/widgets/cyber_confirm_dialog.dart';
import 'edit_profile_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isLogoutPressed = false;

  @override
  void initState() {
    super.initState();

    final userId =
        context.read<AuthProvider>().getCurrentUser()?.id ?? '';

    final profileProvider = context.read<ProfileProvider>();

    if (userId.isNotEmpty) {
      Future.microtask(() {
        profileProvider.loadProfile(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final authProvider = context.read<AuthProvider>();

    if (profileProvider.isLoading &&
        profileProvider.profile == null) {
      return const Scaffold(
        backgroundColor: AppColors.transparent,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryAccent,
            ),
          ),
        ),
      );
    }

    final profile = profileProvider.profile;
    final stats = profileProvider.stats;

    final username =
        profile?.username ?? AppText.defaultExplorer;

    final email =
        profile?.email ??
        authProvider.getCurrentUser()?.email ??
        'anonymous@mindsort.ai';

    final initial = username.isNotEmpty
        ? username[0].toUpperCase()
        : 'E';

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.xxxl,
            vertical: AppSizes.giant,
          ),
          child: Column(
            children: [
              _buildHeaderCard(
                context: context,
                username: username,
                email: email,
                initial: initial,
                stats: stats,
                avatarUrl: profile?.avatarUrl,
              ),

              const SizedBox(height: AppSizes.giant),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppText.accountSettings,
                  style: AppTextStyles.profileSectionTitle,
                ),
              ),

              const SizedBox(height: AppSizes.md),

              // Re-assessment
             _buildSettingsTile(
  icon: Icons.refresh_rounded,
  title: 'Re-assessment',
  subtitle: 'Take a new mental assessment',
  onTap: () {
    context
        .read<AssessmentProvider>()
        .startNewAssessment();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AssasmentScreen(),
      ),
    );
  },
),

              const SizedBox(height: AppSizes.md),

              // About MindSort
              _buildSettingsTile(
                icon: Icons.psychology_outlined,
                title: 'About MindSort',
                subtitle: 'Learn more about MindSort',
                onTap: () {
                  // TODO:
                  // Navigate to About MindSort screen.
                },
              ),

              const SizedBox(height: AppSizes.huge),

              _buildLogoutButton(
                context,
                authProvider,
              ),

              const SizedBox(height: AppSizes.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildHeaderCard({
    required BuildContext context,
    required String username,
    required String email,
    required String initial,
    required ProfileStatsModel? stats,
    required String? avatarUrl,
  }) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(
            AppSizes.giant,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.04),
            borderRadius: AppRadius.r28,
            border: Border.all(
              color: AppColors.white.withOpacity(0.08),
            ),
          ),
          child: Column(
            children: [
              // Avatar
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryAccent,
                      AppColors.secondaryAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent
                          .withOpacity(0.35),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: avatarUrl != null &&
                          avatarUrl.isNotEmpty
                      ? Image.network(
                          avatarUrl,
                          width: 86,
                          height: 86,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return _buildInitialAvatar(
                              initial,
                            );
                          },
                        )
                      : _buildInitialAvatar(
                          initial,
                        ),
                ),
              ),

              const SizedBox(
                height: AppSizes.xxl,
              ),

              Text(
                username,
                style: AppTextStyles.profileUsername,
              ),

              const SizedBox(
                height: AppSizes.sxs,
              ),

              Text(
                email,
                style: AppTextStyles.profileEmail,
              ),

              const SizedBox(
                height: AppSizes.xxxl,
              ),

              Divider(
                color: AppColors.white.withOpacity(0.06),
                height: 1,
              ),

              const SizedBox(
                height: AppSizes.xxl,
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniStat(
                    '${stats?.currentStreak ?? 0}',
                    'Streak',
                  ),
                  _buildMiniStat(
                    '${stats?.assessments ?? 0}',
                    'Assessments',
                  ),
                  _buildMiniStat(
                    '${stats?.completedChallenges ?? 0}',
                    'Challenges',
                  ),
                ],
              ),
            ],
          ),
        ),

        // Edit button
        Positioned(
          top: AppSizes.lg,
          right: AppSizes.lg,
          child: GestureDetector(
            onTap: () async {
              final updated =
                  await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const EditProfileScreen(),
                ),
              );

              if (!mounted || updated != true) {
                return;
              }

              final userId = context
                  .read<AuthProvider>()
                  .getCurrentUser()
                  ?.id;

              if (userId != null &&
                  userId.isNotEmpty) {
                await context
                    .read<ProfileProvider>()
                    .refresh(userId);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(
                AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color:
                    AppColors.white.withOpacity(0.06),
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      AppColors.white.withOpacity(0.08),
                ),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: AppColors.lightAccentGlow,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DEFAULT AVATAR
  // ============================================================

  Widget _buildInitialAvatar(String initial) {
    return Container(
      width: 86,
      height: 86,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: AppSizes.huge,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // MINI STATS
  // ============================================================

  Widget _buildMiniStat(
    String value,
    String label,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.profileStatVal,
        ),
        const SizedBox(
          height: AppSizes.xs,
        ),
        Text(
          label,
          style: AppTextStyles.profileStatLabel,
        ),
      ],
    );
  }

  // ============================================================
  // SETTINGS TILE
  // ============================================================

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xxl,
          vertical: AppSizes.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.03),
          borderRadius: AppRadius.r20,
          border: Border.all(
            color: AppColors.white.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(
                AppSizes.msm,
              ),
              decoration: BoxDecoration(
                color:
                    AppColors.white.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.lightAccentGlow,
                size: 22,
              ),
            ),

            const SizedBox(
              width: AppSizes.lg,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        AppTextStyles.profileTileTitle,
                  ),
                  const SizedBox(
                    height: AppSizes.xs,
                  ),
                  Text(
                    subtitle,
                    style:
                        AppTextStyles.profileTileSub,
                  ),
                ],
              ),
            ),

            trailing ??
                Icon(
                  AppIcons.chevronRight,
                  color:
                      AppColors.white.withOpacity(0.25),
                ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT CONFIRMATION
  // ============================================================

  void _showLogoutConfirmation(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    showDialog(
      context: context,
      barrierColor:
          AppColors.black.withOpacity(0.6),
      builder: (context) {
        return CyberConfirmDialog(
          title: AppText.logoutConfirmTitle,
          content: AppText.logoutConfirmDesc,
          cancelLabel: AppText.cancelLabel,
          confirmLabel: AppText.logoutLabel,
          onConfirm: () async {
            debugPrint(
              '1. Logout pressed',
            );

            await authProvider.signOut();

            debugPrint(
              '2. Sign out finished',
            );
          },
        );
      },
    );
  }

  // ============================================================
  // LOGOUT BUTTON
  // ============================================================

  Widget _buildLogoutButton(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isLogoutPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isLogoutPressed = false;
        });

        _showLogoutConfirmation(
          context,
          authProvider,
        );
      },
      onTapCancel: () {
        setState(() {
          _isLogoutPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isLogoutPressed ? 0.97 : 1.0,
        duration:
            const Duration(milliseconds: 100),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: AppRadius.r20,
            color:
                AppColors.redAccent.withOpacity(0.06),
            border: Border.all(
              color:
                  AppColors.redAccent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.logout,
                color: AppColors.redAccent,
                size: 20,
              ),
              SizedBox(
                width: AppSizes.msm,
              ),
              Text(
                AppText.logoutSession,
                style:
                    AppTextStyles.profileLogoutText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}