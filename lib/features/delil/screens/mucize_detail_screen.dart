import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mucize_model.dart';
import '../theme/app_theme.dart';
import '../services/read_tracker.dart';
import '../services/time_tracker.dart';
import '../services/ad_service.dart';

class MucizeDetailScreen extends StatefulWidget {
  final Mucize mucize;
  const MucizeDetailScreen({super.key, required this.mucize});

  @override
  State<MucizeDetailScreen> createState() => _MucizeDetailScreenState();
}

class _MucizeDetailScreenState extends State<MucizeDetailScreen> {
  @override
  void initState() {
    super.initState();
    ReadTracker.instance.markRead(widget.mucize.id);
    TimeTracker.instance.startSession('mucize');
    AdService.instance.onCardRead();
  }

  @override
  void dispose() {
    TimeTracker.instance.endSession('mucize');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mucize    = widget.mucize;
    final catColor  = MucizeColors.forCategory(mucize.mainCategory);
    final catIcon   = MucizeColors.iconForCategory(mucize.mainCategory);
    final typeColor = MucizeColors.forMiracleType(mucize.miracleType);
    final typeLabel = MucizeColors.labelForMiracleType(mucize.miracleType);

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
                        color: catColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(catIcon, color: catColor, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            mucize.id,
                            style: GoogleFonts.notoSans(
                              fontSize: 10,
                              color: catColor.withOpacity(0.8),
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            mucize.title,
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
                    if (typeLabel.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: typeColor.withOpacity(0.30)),
                        ),
                        child: Text(
                          typeLabel,
                          style: GoogleFonts.notoSans(
                            fontSize: 9,
                            color: typeColor,
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

                  // ── Kaynak & Orijinal İfade ───────────────────────────
                  if (mucize.sourceRef.isNotEmpty || mucize.originalExpression.isNotEmpty)
                    _SourceBox(
                      ref: mucize.sourceRef,
                      originalExpression: mucize.originalExpression,
                      color: catColor,
                    ),
                  if (mucize.sourceRef.isNotEmpty || mucize.originalExpression.isNotEmpty)
                    const SizedBox(height: 20),

                  // ── Mucize / İşaret ───────────────────────────────────
                  _SectionTitle('Mucize / İşaret'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(left: BorderSide(color: catColor, width: 3)),
                    ),
                    child: Text(
                      mucize.claim,
                      style: GoogleFonts.notoSerif(
                        fontSize: 15.5,
                        height: 1.65,
                        color: AppColors.textPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  // ── Açıklama ──────────────────────────────────────────
                  const SizedBox(height: 24),
                  _SectionTitle('Açıklama'),
                  const SizedBox(height: 10),
                  Text(
                    mucize.shortExplanation,
                    style: GoogleFonts.notoSerif(
                      fontSize: 15,
                      height: 1.75,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  // ── Detaylı Açıklama (expandable) ─────────────────────
                  if (mucize.detailedExplanation != null) ...[
                    const SizedBox(height: 20),
                    _MucizeDetailedExplanationSection(
                      detail: mucize.detailedExplanation!,
                      color: catColor,
                    ),
                  ],

                  // ── Etiketler ─────────────────────────────────────────
                  if (mucize.tags.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle('Etiketler'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: mucize.tags.map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: catColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: catColor.withOpacity(0.3)),
                        ),
                        child: Text(tag,
                            style: GoogleFonts.notoSans(fontSize: 12, color: catColor)),
                      )).toList(),
                    ),
                  ],

                  // ── Kategori satırı ───────────────────────────────────
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(catIcon, color: catColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mucize.mainCategory,
                                style: GoogleFonts.notoSans(
                                    fontSize: 11, color: catColor,
                                    fontWeight: FontWeight.w600)),
                              if (mucize.subcategory.isNotEmpty)
                                Text(mucize.subcategory,
                                  style: GoogleFonts.notoSans(
                                      fontSize: 11, color: AppColors.textMuted)),
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

// ── Kaynak & Orijinal İfade kutusu ────────────────────────────────────────────
class _SourceBox extends StatelessWidget {
  final String ref;
  final String originalExpression;
  final Color color;
  const _SourceBox({required this.ref, required this.originalExpression, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ref.isNotEmpty)
            Row(
              children: [
                Icon(Icons.menu_book_outlined, size: 14, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(ref, style: GoogleFonts.notoSans(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: color, letterSpacing: 0.3,
                  )),
                ),
              ],
            ),
          if (originalExpression.isNotEmpty) ...[
            if (ref.isNotEmpty) const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border(left: BorderSide(color: color.withOpacity(0.6), width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORİJİNAL İFADE',
                    style: GoogleFonts.notoSans(
                      fontSize: 9,
                      color: color.withOpacity(0.7),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    originalExpression,
                    style: GoogleFonts.notoSerif(
                      fontSize: 14.5,
                      color: AppColors.textPrimary,
                      height: 1.65,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Detaylı Açıklama (expandable) ─────────────────────────────────────────────
class _MucizeDetailedExplanationSection extends StatefulWidget {
  final MucizeDetailedExplanation detail;
  final Color color;
  const _MucizeDetailedExplanationSection({required this.detail, required this.color});

  @override
  State<_MucizeDetailedExplanationSection> createState() =>
      _MucizeDetailedExplanationSectionState();
}

class _MucizeDetailedExplanationSectionState
    extends State<_MucizeDetailedExplanationSection>
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
        // Toggle button
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
                Text(
                  'Detaylı Açıklama',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 6),
                RotationTransition(
                  turns: _chevron,
                  child: Icon(Icons.expand_more_rounded, size: 18, color: color),
                ),
              ],
            ),
          ),
        ),
        // Expandable content
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
                  if (d.detayliAciklama.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.description_outlined,
                      label: 'Detaylı Açıklama',
                      text: d.detayliAciklama,
                      color: color,
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (d.nedenVayBeDedirtiyor.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.flash_on_rounded,
                      label: 'Neden "Vay be" Dedirtiyor?',
                      text: d.nedenVayBeDedirtiyor,
                      color: AppColors.gold,
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (d.kaynakNotu.isNotEmpty) ...[
                    _DetailRow(
                      icon: Icons.bookmark_border_rounded,
                      label: 'Kaynak Notu',
                      text: d.kaynakNotu,
                      color: color,
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
  final String text;
  final Color color;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.text,
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
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                )),
            ],
          ),
          const SizedBox(height: 7),
          Text(text,
            style: GoogleFonts.notoSerif(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.65,
            )),
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
