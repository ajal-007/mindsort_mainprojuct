import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_text_styles.dart';

class CyberConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelLabel;
  final String confirmLabel;
  final Future<void> Function() onConfirm;

  const CyberConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: AlertDialog(
        backgroundColor: AppColors.glassSurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.r28,
          side: BorderSide(color: AppColors.white.withOpacity(0.08)),
        ),
        title: Text(
          title,
          style: AppTextStyles.dialogTitle,
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: AppTextStyles.completeProfileSub,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            
            child: Text(
              cancelLabel,
              style: TextStyle(
                color: AppColors.white.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
                Navigator.of(context).pop();
               onConfirm();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: AppSizes.md),
              decoration: BoxDecoration(
                borderRadius: AppRadius.r12,
                gradient: const LinearGradient(
                  colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                ),
              ),
              child: Text(
                confirmLabel,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
