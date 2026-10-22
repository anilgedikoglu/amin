import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/delil_model.dart';
import '../theme/app_theme.dart';
import '../services/read_tracker.dart';
import 'strength_badge.dart';

class DelilCardWidget extends StatelessWidget {
  final Delil delil;
  final VoidCallback? onTap;
  final bool featured;

  const DelilCardWidget({
    super.key,
    required this.delil,
    this.onTap,
    this.featured = false,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = AppColors.forCategory(delil.category);
    final catColorDim = AppColors.dimForCategory(delil.category);
    final catIcon = AppIcons.forCategory(delil.category);

    return ValueListenableBuilder<Set<String>>(
      valueListenable: ReadTracker.instance.readIds,
      builder: (context, readIds, _) {
        final isRead = readIds.contains(delil.id);
        return _buildCard(catColor, catColorDim, catIcon, isRead);
      },
    );
  }

  Widget _buildCard(Color catColor, Color catColorDim, IconData catIcon, bool isRead) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: catColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [catColor.withOpacity(0.8), catColor.withOpacity(0.3)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Üst satır: ikon + DELIL-X + tick + badge ──────────
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: catColorDim,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(catIcon, color: catColor, size: 16),
                        ),
                        const SizedBox(width: 9),
                        Text(
                          delil.id,
                          style: GoogleFonts.notoSans(
                            fontSize: 10,
                            color: catColor.withOpacity(0.75),
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        if (isRead)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF2ECC71).withOpacity(0.18),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: Color(0xFF2ECC71),
                              ),
                            ),
                          ),
                        StrengthBadge(strength: delil.strength, compact: true),
                      ],
                    ),
                    const SizedBox(height: 9),
                    // ── Tam genişlik başlık ───────────────────────────────
                    Text(
                      delil.title,
                      style: GoogleFonts.notoSerif(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.30,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // ── Kısa açıklama ─────────────────────────────────────
                    Text(
                      delil.short,
                      style: GoogleFonts.notoSerif(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        height: 1.55,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    // ── Etiketler + ok ────────────────────────────────────
                    Row(
                      children: [
                        Wrap(
                          spacing: 5,
                          runSpacing: 4,
                          children: delil.tags.take(3).map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: catColor.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.notoSans(
                                fontSize: 10,
                                color: catColor.withOpacity(0.9),
                              ),
                            ),
                          )).toList(),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 11,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DelilCardFeatured extends StatelessWidget {
  final Delil delil;
  final VoidCallback? onTap;
  final int index;

  const DelilCardFeatured({
    super.key,
    required this.delil,
    this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = AppColors.forCategory(delil.category);
    final catColorDim = AppColors.dimForCategory(delil.category);
    final catIcon = AppIcons.forCategory(delil.category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: catColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: catColor.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: catColor.withOpacity(0.06),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: catColorDim,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(catIcon, color: catColor, size: 18),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${index + 1} / 12',
                            style: GoogleFonts.notoSans(
                              fontSize: 10,
                              color: AppColors.gold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      delil.title,
                      style: GoogleFonts.notoSerif(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      delil.short,
                      style: GoogleFonts.notoSerif(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    StrengthBadge(strength: delil.strength),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
