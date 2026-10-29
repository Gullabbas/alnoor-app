import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ClinicalStatus {
  normal('Normal', AppColors.success, AppColors.successLight),
  borderline('Borderline', AppColors.warning, AppColors.warningLight),
  abnormal('Abnormal', AppColors.danger, AppColors.dangerLight),
  pending('Pending', AppColors.info, AppColors.infoLight);

  final String label;
  final Color textColor;
  final Color bgColor;
  const ClinicalStatus(this.label, this.textColor, this.bgColor);
}

class StatusChip extends StatelessWidget {
  final ClinicalStatus status;
  final String? customLabel;

  const StatusChip({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status.textColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: status.textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            customLabel ?? status.label,
            style: TextStyle(
              color: status.textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
