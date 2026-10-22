// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/soz_model.dart';
import '../theme/app_theme.dart';
import '../services/read_tracker.dart';

// ── List card ────────────────────────────────────────────────────────────────
class SozCardWidget extends StatelessWidget {
  final Soz soz;
  final VoidCallback? onTap;

  const SozCardWidget({super.key, required this.soz, this.onTap});

  @override
  Widget build(BuildContext context) {
    final catColor    = SozColors.forCategory(soz.category);
    final catColorDim = SozColors.dimForCategory(soz.category);
    final catIcon     = SozColors.iconForCategory(soz.category);

    return ValueListenableBuilder<Set<String>>(
      valueListenable: ReadTracker.instance.readIds,
      builder: (context, readIds, _) {
        final isRead = readIds.contains(soz.id);
        return _buildCard(catColor, catColorDim, catIcon, isRead);
      },
    );
  }

  Widget _buildCard(
    Color catColor,
    Color catColorDim,
    IconData catIcon,
    bool isRead,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── top colour band ──────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(13)),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Icon(catIcon, color: catColor, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      soz.category,
                      style: GoogleFonts.notoSans(
                        color: catColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isRead)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          color: Colors.green, size: 12),
                    ),
                  _QuoteTypeBadge(quoteType: soz.quoteType),
                ],
              ),
            ),

            // ── body ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Person name
                  Text(
                    soz.person,
                    style: GoogleFonts.notoSerif(
                      color: AppColors.gold,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (soz.whoIs.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      soz.whoIs,
                      style: GoogleFonts.notoSans(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                  // Quote text
                  Text(
                    soz.quoteTurkish.isNotEmpty
                        ? soz.quoteTurkish
                        : soz.quoteOriginalOrView,
                    style: GoogleFonts.notoSerif(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (soz.whatItSupports.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: catColor, size: 13),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            soz.whatItSupports,
                            style: GoogleFonts.notoSans(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (soz.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: soz.tags.take(4).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: catColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.notoSans(
                              color: catColor.withAlpha(230),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Featured card (horizontal scroll) ───────────────────────────────────────
class SozCardFeatured extends StatelessWidget {
  final Soz soz;
  final VoidCallback? onTap;

  const SozCardFeatured({super.key, required this.soz, this.onTap});

  @override
  Widget build(BuildContext context) {
    final catColor    = SozColors.forCategory(soz.category);
    final catColorDim = SozColors.dimForCategory(soz.category);

    return ValueListenableBuilder<Set<String>>(
      valueListenable: ReadTracker.instance.readIds,
      builder: (context, readIds, _) {
        final isRead = readIds.contains(soz.id);
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 240,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: catColorDim,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: catColor.withAlpha(80)),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(SozColors.iconForCategory(soz.category),
                        color: catColor, size: 16),
                    const Spacer(),
                    if (isRead)
                      Icon(Icons.check_circle,
                          color: Colors.green, size: 14),
                    _QuoteTypeBadge(quoteType: soz.quoteType),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  soz.person,
                  style: GoogleFonts.notoSerif(
                    color: AppColors.gold,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (soz.whoIs.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    soz.whoIs,
                    style: GoogleFonts.notoSans(
                      color: catColor,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    soz.quoteTurkish.isNotEmpty
                        ? soz.quoteTurkish
                        : soz.quoteOriginalOrView,
                    style: GoogleFonts.notoSerif(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Quote type badge ─────────────────────────────────────────────────────────
class _QuoteTypeBadge extends StatelessWidget {
  final String quoteType;
  const _QuoteTypeBadge({required this.quoteType});

  @override
  Widget build(BuildContext context) {
    final color = SozColors.forQuoteType(quoteType);
    final label = SozColors.labelForQuoteType(quoteType);
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoSans(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
