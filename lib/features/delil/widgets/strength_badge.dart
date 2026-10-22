import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StrengthBadge extends StatelessWidget {
  final String strength;
  final bool compact;

  const StrengthBadge({super.key, required this.strength, this.compact = false});

  (String, int) get _info {
    switch (strength) {
      case 'yüksek':
        return ('Güçlü', 3);
      case 'orta-yüksek':
        return ('Orta', 2);
      case 'orta':
        return ('Zayıf', 1);
      default:
        return ('Zayıf', 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, level) = _info;
    final dotSize = compact ? 5.0 : 5.0;
    final fontSize = compact ? 9.0 : 10.0;
    final hPad = compact ? 6.0 : 8.0;
    final vPad = compact ? 2.0 : 3.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
        color: AppColors.gold.withOpacity(0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(3, (i) => Container(
            width: dotSize,
            height: dotSize,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < level
                  ? AppColors.gold
                  : AppColors.gold.withOpacity(0.2),
            ),
          )),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: fontSize,
              color: AppColors.gold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
