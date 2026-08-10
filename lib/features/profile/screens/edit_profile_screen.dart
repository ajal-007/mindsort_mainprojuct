import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mainsupabase_projuct/core/constants/app_colors.dart';
import 'package:mainsupabase_projuct/core/constants/app_radius.dart';
import 'package:mainsupabase_projuct/core/constants/app_sizes.dart';
import 'package:mainsupabase_projuct/core/theme/app_text_styles.dart';
import 'package:provider/provider.dart';


import '../providers/profile_provider.dart';
import '../../authentication/provider/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  late final TextEditingController _usernameController;

  Uint8List? _selectedImage;
  String? _avatarUrl;

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    final profile =
        context.read<ProfileProvider>().profile;

    _usernameController = TextEditingController(
      text: profile?.username ?? '',
    );

    _avatarUrl = profile?.avatarUrl;

    _usernameController.addListener(
      _checkForChanges,
    );
  }

  void _checkForChanges() {
    final profile =
        context.read<ProfileProvider>().profile;

    final changed =
        _usernameController.text.trim() !=
                (profile?.username ?? '') ||
            _selectedImage != null;

    if (_hasChanges != changed) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      _selectedImage = bytes;
      _hasChanges = true;
    });
  }

  Future<void> _save() async {
    final authProvider =
        context.read<AuthProvider>();

    final profileProvider =
        context.read<ProfileProvider>();

    final user =
        authProvider.getCurrentUser();

    if (user == null) return;

    final username =
        _usernameController.text.trim().toLowerCase();

    if (username.isEmpty) {
      _showError('Username cannot be empty.');
      return;
    }

    String? avatarUrl = _avatarUrl;

    if (_selectedImage != null) {
      final uploaded =
          await profileProvider.uploadAvatar(
        userId: user.id,
        bytes: _selectedImage!,
        extension: 'jpg',
      );

      if (uploaded == null) {
        _showError(
          profileProvider.error ??
              'Failed to upload profile picture.',
        );
        return;
      }

      avatarUrl = uploaded;
    }

    final success =
        await profileProvider.updateProfile(
      userId: user.id,
      username: username,
      avatarUrl: avatarUrl,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile updated successfully.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } else {
      _showError(
        profileProvider.error ??
            'Unable to update profile.',
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) {
      return true;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          title: const Text(
            'Discard changes?',
            style: TextStyle(
              color: AppColors.white,
            ),
          ),
          content: const Text(
            'Your changes will not be saved.',
            style: TextStyle(
              color: AppColors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );

    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        context.watch<ProfileProvider>();

    final profile = profileProvider.profile;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult:
          (didPop, result) async {
        if (didPop) return;

        final shouldPop =
            await _onWillPop();

        if (shouldPop && mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(
            color: AppColors.white,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
              AppSizes.xl,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSizes.lg),

                GestureDetector(
                  onTap: profileProvider.isUpdating
                      ? null
                      : _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primaryAccent,
                              AppColors.secondaryAccent,
                            ],
                          ),
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: MemoryImage(
                                    _selectedImage!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : (_avatarUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        _avatarUrl!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                        ),
                      ),

                      if (_selectedImage == null &&
                          _avatarUrl == null)
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              (profile?.username
                                          .isNotEmpty ??
                                      false)
                                  ? profile!
                                      .username[0]
                                      .toUpperCase()
                                  : 'A',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 42,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding:
                              const EdgeInsets.all(
                            AppSizes.msm,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryAccent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  AppColors.backgroundDark,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.giant),

                _buildField(
                  label: 'Username',
                  controller: _usernameController,
                  enabled:
                      !profileProvider.isUpdating,
                ),

                const SizedBox(height: AppSizes.xl),

                _buildReadOnlyField(
                  label: 'Email',
                  value: profile?.email ?? '',
                ),

                const SizedBox(height: AppSizes.huge),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        !_hasChanges ||
                                profileProvider.isUpdating
                            ? null
                            : _save,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryAccent,
                      disabledBackgroundColor:
                          AppColors.white
                              .withOpacity(0.06),
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: AppSizes.lg,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            AppRadius.r16,
                      ),
                    ),
                    child: profileProvider.isUpdating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color:
                                  AppColors.white,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              color:
                                  AppColors.white,
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.profileTileTitle,
        ),
        const SizedBox(height: AppSizes.sm),
        TextField(
          controller: controller,
          enabled: enabled,
          style: const TextStyle(
            color: AppColors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor:
                AppColors.white.withOpacity(0.04),
            border: OutlineInputBorder(
              borderRadius: AppRadius.r16,
              borderSide: BorderSide(
                color:
                    AppColors.white.withOpacity(0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.r16,
              borderSide: BorderSide(
                color:
                    AppColors.white.withOpacity(0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.r16,
              borderSide: const BorderSide(
                color:
                    AppColors.primaryAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.profileTileTitle,
        ),
        const SizedBox(height: AppSizes.sm),
        TextField(
          readOnly: true,
          controller:
              TextEditingController(text: value),
          style: TextStyle(
            color:
                AppColors.white.withOpacity(0.45),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor:
                AppColors.white.withOpacity(0.025),
            suffixIcon: Icon(
              Icons.lock_outline,
              color:
                  AppColors.white.withOpacity(0.25),
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.r16,
              borderSide: BorderSide(
                color:
                    AppColors.white.withOpacity(0.06),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}