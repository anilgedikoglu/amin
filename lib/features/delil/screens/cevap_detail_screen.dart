import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cevap_model.dart';
import '../theme/app_theme.dart';
import '../services/read_tracker.dart';
import '../services/time_tracker.dart';
import '../services/ad_service.dart';

class CevapDetailScreen extends StatefulWidget {
  final Cevap cevap;
  const CevapDetailScreen({super.key, required this.cevap});

  @override
  State<CevapDetailScreen> createState() => _CevapDetailScreenState();
}

class _CevapDetailScreenState extends State<CevapDetailScreen> {
  @override
  void initState() {
    super.initState();
    ReadTracker.instance.markRead(widget.cevap.id);
    TimeTracker.instance.startSession('cevap');
    AdService.instance.onCardRead();
  }

  @override
  void dispose() {
    TimeTracker.instance.endSession('cevap');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c        = widget.cevap;
    final secColor = CevapColors.forSection(c.section);
    final secIcon  = CevapColors.iconForSection(c.section);
    final diffColor = CevapColors.forDifficulty(c.difficulty);
    final diffLabel = CevapColors.labelForDifficulty(c.difficulty);
    final profColor = CevapColors.forProfile(c.askerProfile);
    final profLabel = CevapColors.labelForProfile(c.askerProfile);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── SABİT HEADER ──────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder, width: 0.5),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: AppColors.gold, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: secColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(secIcon, color: secColor, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            c.id,
                            style: GoogleFonts.notoSans(
                              fontSize: 10,
                              color: secColor.withOpacity(0.8),
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            c.title,
                            style: GoogleFonts.notoSerif(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (diffLabel.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: diffColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: diffColor.withOpacity(0.30)),
                        ),
                        child: Text(
                          diffLabel,
                          style: GoogleFonts.notoSans(
                            fontSize: 9,
                            color: diffColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // ── KAYDIRILAN İÇERİK ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Soru kutusu ───────────────────────────────────────
                  _QuestionBox(
                    question: c.question,
                    profile: profLabel,
                    profileColor: profColor,
                    sectionColor: secColor,
                  ),
                  const SizedBox(height: 20),

                  // ── Kısa Cevap ────────────────────────────────────────
                  _SectionTitle('Kısa Cevap'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: secColor.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(left: BorderSide(color: secColor, width: 3)),
                    ),
                    child: Text(
                      c.shortAnswer,
                      style: GoogleFonts.notoSerif(
                        fontSize: 15.5,
                        height: 1.65,
                        color: AppColors.textPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  // ── Cevap ─────────────────────────────────────────────
                  const SizedBox(height: 24),
                  _SectionTitle('Cevap'),
                  const SizedBox(height: 10),
                  Text(
                    c.answer,
                    style: GoogleFonts.notoSerif(
                      fontSize: 15,
                      height: 1.75,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  // ── Detaylı Açıklama (expandable) ─────────────────────
                  if (c.detailedExplanation != null) ...[
                    const SizedBox(height: 20),
                    _CevapDetailedSection(
                      detail: c.detailedExplanation!,
                      color: secColor,
                    ),
                  ],

                  // ── Etiketler ─────────────────────────────────────────
                  if (c.tags.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle('Etiketler'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: c.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: secColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: secColor.withOpacity(0.3)),
                        ),
                        child: Text(tag,
                            style: GoogleFonts.notoSans(fontSize: 12, color: secColor)),
                      )).toList(),
                    ),
                  ],

                  // ── Kaynaklar ─────────────────────────────────────────
                  if (c.sources.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle('Kaynaklar'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: c.sources.map((src) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Text(src,
                          style: GoogleFonts.notoSans(
                              fontSize: 11, color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600)),
                      )).toList(),
                    ),
                  ],

                  // ── Bölüm satırı ──────────────────────────────────────
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(secIcon, color: secColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.section,
                                style: GoogleFonts.notoSans(
                                    fontSize: 11, color: secColor,
                                    fontWeight: FontWeight.w600)),
                              if (c.sectionDescription.isNotEmpty)
                                Text(c.sectionDescription,
                                  style: GoogleFonts.notoSans(
                                      fontSize: 10, color: AppColors.textMuted),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Soru kutusu ───────────────────────────────────────────────────────────────
class _QuestionBox extends StatelessWidget {
  final String question;
  final String profile;
  final Color profileColor;
  final Color sectionColor;
  const _QuestionBox({
    required this.question,
    required this.profile,
    required this.profileColor,
    required this.sectionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: sectionColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: sectionColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline_rounded, size: 14, color: sectionColor),
              const SizedBox(width: 6),
              Text('SORU', style: GoogleFonts.notoSans(
                fontSize: 10, fontWeight: FontWeight.w700,
                color: sectionColor, letterSpacing: 1,
              )),
              const Spacer(),
              if (profile.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: profileColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: profileColor.withOpacity(0.3)),
                  ),
                  child: Text(profile,
                    style: GoogleFonts.notoSans(
                        fontSize: 10, color: profileColor,
                        fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(question,
            style: GoogleFonts.notoSerif(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            )),
        ],
      ),
    );
  }
}

// ── Detaylı Açıklama (expandable) ─────────────────────────────────────────────
class _CevapDetailedSection extends StatefulWidget {
  final CevapDetailedExplanation detail;
  final Color color;
  const _CevapDetailedSection({required this.detail, required this.color});

  @override
  State<_CevapDetailedSection> createState() => _CevapDetailedSectionState();
}

class _CevapDetailedSectionState extends State<_CevapDetailedSection>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _ctrl;
  late final Animation<double> _chevron;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _chevron = Tween<double>(begin: 0, end: 0.5).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    final d = widget.detail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _toggle,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.layers_outlined, size: 14, color: color),
                const SizedBox(width: 8),
                Text('Detaylı Açıklama',
                  style: GoogleFonts.notoSans(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: color, letterSpacing: 0.5,
                  )),
                const SizedBox(width: 6),
                RotationTransition(
                  turns: _chevron,
                  child: Icon(Icons.expand_more_rounded, size: 18, color: color),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            heightFactor: _open ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (d.orijinalMetinler.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.format_quote_rounded,
                      label: 'Temel Söylemler',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: d.orijinalMetinler.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('• $m',
                            style: GoogleFonts.notoSerif(
                              fontSize: 13.5,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            )),
                        )).toList(),
                      ),
                      color: color,
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (d.cevabinDayanagi.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.foundation_outlined,
                      label: 'Cevabın Dayanağı',
                      text: d.cevabinDayanagi,
                      color: color,
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (d.detayliAciklama.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.description_outlined,
                      label: 'Detaylı Açıklama',
                      text: d.detayliAciklama,
                      color: color,
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (d.ornek.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.lightbulb_outline,
                      label: 'Örnek Anlatım',
                      text: d.ornek,
                      color: AppColors.gold,
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (d.ihtiyatNotu.isNotEmpty)
                    _DetailRow(
                      icon: Icons.info_outline_rounded,
                      label: 'İhtiyat Notu',
                      text: d.ihtiyatNotu,
                      color: AppColors.amber,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? text;
  final Widget? child;
  final Color color;

  const _DetailRow({
    required this.icon,
    required this.label,
    this.text,
    this.child,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 6),
              Text(label,
                style: GoogleFonts.notoSans(
                  fontSize: 10, color: color,
                  fontWeight: FontWeight.w700, letterSpacing: 0.5,
                )),
            ],
          ),
          const SizedBox(height: 7),
          if (text != null)
            Text(text!,
              style: GoogleFonts.notoSerif(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.65,
              ))
          else if (child != null)
            child!,
        ],
      ),
    );
  }
}

// ── Bölüm başlığı ──────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 16, color: AppColors.gold,
            margin: const EdgeInsets.only(right: 8)),
        Text(title, style: GoogleFonts.notoSerif(
          fontSize: 13, fontWeight: FontWeight.w700,
          color: AppColors.gold, letterSpacing: 1,
        )),
      ],
    );
  }
}
