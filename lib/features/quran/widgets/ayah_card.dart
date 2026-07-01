// Tek ayet kartı: numara rozeti, Arapça metin, Türkçe meal,
// dinle + favori butonları. Çalan ayet vurgulanır.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/meal_registry.dart';
import '../models/quran_models.dart';
import '../quran_theme.dart';

class AyahCard extends StatelessWidget {
  final Ayah ayah;
  final double fontScale;
  final bool showArabic;
  final bool showOkunus;
  final bool showMeal;
  final bool isFavorite;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onToggleFavorite;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.fontScale,
    required this.showArabic,
    required this.showOkunus,
    required this.showMeal,
    required this.isFavorite,
    required this.isPlaying,
    required this.onPlay,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isPlaying ? QC.gold : QC.greenPale,
            width: isPlaying ? 2 : 1.2),
        boxShadow: [
          BoxShadow(
              color: (isPlaying ? QC.gold : QC.greenMain).withAlpha(isPlaying ? 60 : 18),
              blurRadius: isPlaying ? 14 : 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Üst satır: numara rozeti + aksiyonlar
        Row(children: [
          _NumberBadge(number: ayah.number),
          const Spacer(),
          _IconBtn(
            icon: isPlaying ? Icons.graphic_eq : Icons.play_arrow_rounded,
            color: isPlaying ? QC.gold : QC.greenMid,
            onTap: onPlay,
          ),
          const SizedBox(width: 4),
          _IconBtn(
            icon: isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
            color: isFavorite ? QC.gold : QC.greenMid,
            onTap: onToggleFavorite,
          ),
        ]),
        if (showArabic) ...[
          const SizedBox(height: 10),
          Text(
            ayah.arabic,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: QC.arabicFont,
              fontSize: 23 * fontScale,
              height: 1.9,
              color: QC.greenDark,
            ),
          ),
        ],
        if (showOkunus && ayah.okunus.isNotEmpty) ...[
          const SizedBox(height: 10),
          if (showArabic) Divider(color: QC.greenPale.withAlpha(120), height: 1),
          const SizedBox(height: 8),
          Text(
            ayah.okunus,
            style: GoogleFonts.lora(
              fontSize: 13.5 * fontScale,
              height: 1.6,
              fontStyle: FontStyle.italic,
              color: QC.greenMain,
            ),
          ),
        ],
        if (showMeal && ayah.translations.isNotEmpty) ...[
          const SizedBox(height: 10),
          if (showArabic || showOkunus)
            Divider(color: QC.greenPale.withAlpha(140), height: 1),
          const SizedBox(height: 8),
          // Tek meal: sade. Çoklu meal: her birini çevirmen etiketiyle (karşılaştırma).
          ...() {
            final entries = ayah.translations.entries.toList();
            final multi = entries.length > 1;
            return entries.map((e) {
              final info = mealById(e.key);
              return Padding(
                padding: EdgeInsets.only(bottom: multi ? 10 : 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (multi) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: QC.greenMain.withAlpha(28),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(info.name,
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700, color: QC.greenMain)),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    e.value,
                    style: GoogleFonts.lora(
                      fontSize: 14.5 * fontScale,
                      height: 1.7,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ]),
              );
            }).toList();
          }(),
        ],
        const SizedBox(height: 4),
      ]),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  final int number;
  const _NumberBadge({required this.number});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [QC.greenMain, QC.greenDark]),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: QC.gold.withAlpha(150), width: 1),
      ),
      child: Center(
        child: Text('$number',
            style: GoogleFonts.lora(
                fontSize: 13, fontWeight: FontWeight.w700, color: QC.goldLight)),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
