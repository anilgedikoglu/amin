import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppLogoHeader extends StatelessWidget {
  final bool large;
  const AppLogoHeader({super.key, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/delil_images/logo.png',
          width: large ? 64 : 40,
          height: large ? 64 : 40,
          errorBuilder: (_, __, ___) => const _FallbackIcon(size: 40),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DELİL',
              style: GoogleFonts.notoSerif(
                fontSize: large ? 28 : 20,
                fontWeight: FontWeight.w800,
                color: AppColors.goldLight,
                letterSpacing: large ? 5 : 3,
              ),
            ),
            if (large)
              Text(
                'Allah\'ın Varlığının Delilleri',
                style: GoogleFonts.notoSerif(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              )
            else
              Text(
                'Allah\'ın Varlığının Delilleri',
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  final double size;
  const _FallbackIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
      child: const Icon(Icons.menu_book_rounded, color: AppColors.gold, size: 22),
    );
  }
}
