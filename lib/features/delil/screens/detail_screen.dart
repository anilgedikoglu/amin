import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/delil_model.dart';
import '../data/sources_data.dart';
import '../theme/app_theme.dart';
import '../widgets/strength_badge.dart';
import '../services/read_tracker.dart';
import '../services/time_tracker.dart';
import '../services/ad_service.dart';

class DetailScreen extends StatefulWidget {
  final Delil delil;

  const DetailScreen({super.key, required this.delil});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    ReadTracker.instance.markRead(widget.delil.id);
    TimeTracker.instance.startSession('delil');
    AdService.instance.onCardRead();
  }

  @override
  void dispose() {
    TimeTracker.instance.endSession('delil');
    super.dispose();
  }

  Delil get delil => widget.delil;

  @override
  Widget build(BuildContext context) {
    final catColor = AppColors.forCategory(delil.category);
    final catIcon = AppIcons.forCategory(delil.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── SABİT HEADER BANDI ─────────────────────────────────
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
                    // Geri butonu
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: AppColors.gold, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // Boşluk + kategori ikonu
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
                    // ID + Başlık
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            delil.id,
                            style: GoogleFonts.notoSans(
                              fontSize: 10,
                              color: catColor.withOpacity(0.8),
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            delil.title,
                            style: GoogleFonts.notoSerif(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Güç badgei — sağda sabit
                    StrengthBadge(strength: delil.strength),
                  ],
                ),
              ),
            ),
          ),

          // ── KAYDIRILAN İÇERİK ─────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuoteBox(text: delil.short, color: catColor),
                  const SizedBox(height: 24),
                  _SectionTitle('Açıklama'),
                  const SizedBox(height: 10),
                  Text(
                    delil.expanded,
                    style: GoogleFonts.notoSerif(
                      fontSize: 15.5,
                      height: 1.75,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (delil.detailedExplanation != null) ...[
                    const SizedBox(height: 20),
                    _DetailedExplanationSection(
                      detail: delil.detailedExplanation!,
                      color: catColor,
                    ),
                  ],
                  if (delil.hasObjectionReply) ...[
                    const SizedBox(height: 28),
                    _ObjectionReplySection(delil: delil),
                  ],
                  const SizedBox(height: 28),
                  _TagsSection(tags: delil.tags, color: catColor),
                  const SizedBox(height: 28),
                  _CategoryRow(
                      category: delil.category,
                      subcategory: delil.subcategory),
                  const SizedBox(height: 28),
                  _SourcesSection(codes: delil.sources),
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

class _QuoteBox extends StatelessWidget {
  final String text;
  final Color color;
  const _QuoteBox({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Text(
        '"$text"',
        style: GoogleFonts.notoSerif(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 16, color: AppColors.gold, margin: const EdgeInsets.only(right: 8)),
        Text(
          title,
          style: GoogleFonts.notoSerif(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.gold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _ObjectionReplySection extends StatefulWidget {
  final Delil delil;
  const _ObjectionReplySection({required this.delil});

  @override
  State<_ObjectionReplySection> createState() => _ObjectionReplySectionState();
}

class _ObjectionReplySectionState extends State<_ObjectionReplySection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('İtiraz & Cevap'),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.red.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.help_outline, color: AppColors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.delil.objection,
                        style: GoogleFonts.notoSerif(
                          fontSize: 13.5,
                          color: AppColors.red.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.textMuted,
                      size: 18,
                    ),
                  ],
                ),
                if (_expanded) ...[
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.green, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.delil.reply,
                          style: GoogleFonts.notoSerif(
                            fontSize: 13.5,
                            color: AppColors.textPrimary,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TagsSection extends StatelessWidget {
  final List<String> tags;
  final Color color;
  const _TagsSection({required this.tags, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Etiketler'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: tags.map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              tag,
              style: GoogleFonts.notoSans(fontSize: 12, color: color),
            ),
          )).toList(),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final String subcategory;
  const _CategoryRow({required this.category, required this.subcategory});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forCategory(category);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(AppIcons.forCategory(category), color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subcategory,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailedExplanationSection extends StatefulWidget {
  final DetailedExplanation detail;
  final Color color;
  const _DetailedExplanationSection({required this.detail, required this.color});

  @override
  State<_DetailedExplanationSection> createState() =>
      _DetailedExplanationSectionState();
}

class _DetailedExplanationSectionState
    extends State<_DetailedExplanationSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Aşağı ok butonu — ortalı
        Center(
          child: GestureDetector(
            onTap: () => setState(() => _open = !_open),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: widget.color.withOpacity(0.30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Detaylı Açıklama',
                    style: GoogleFonts.notoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: widget.color,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: widget.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Açılır içerik — yukarıdan aşağı açılma
        ClipRect(
          child: AnimatedAlign(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            heightFactor: _open ? 1.0 : 0.0,
            child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: widget.color.withOpacity(0.20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (d.kaynakYeri.isNotEmpty)
                    _DetailRow(
                      icon: Icons.library_books_outlined,
                      label: 'Kaynak',
                      text: d.kaynakYeri,
                      color: widget.color,
                    ),
                  if (d.kaynakMetniVeyaCekirdekFormulasyon.isNotEmpty) ...[
                    if (d.kaynakYeri.isNotEmpty) const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.format_quote_rounded,
                      label: 'Çekirdek Formülasyon',
                      text: d.kaynakMetniVeyaCekirdekFormulasyon,
                      color: widget.color,
                    ),
                  ],
                  if (d.nedenDelildir.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.lightbulb_outline,
                      label: 'Neden Delildir?',
                      text: d.nedenDelildir,
                      color: widget.color,
                    ),
                  ],
                  if (d.uygulamaNotu.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.info_outline,
                      label: 'Uygulama Notu',
                      text: d.uygulamaNotu,
                      color: widget.color,
                    ),
                  ],
                ],
              ),
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
  const _DetailRow(
      {required this.icon,
      required this.label,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: color.withOpacity(0.8)),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.notoSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color.withOpacity(0.8),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: GoogleFonts.notoSerif(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

class _SourcesSection extends StatelessWidget {
  final List<String> codes;
  const _SourcesSection({required this.codes});

  @override
  Widget build(BuildContext context) {
    final sources = codes.map(findSource).whereType<DelilSource>().toList();
    if (sources.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Kaynaklar'),
        const SizedBox(height: 10),
        ...sources.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.goldDim.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  s.code,
                  style: GoogleFonts.notoSans(
                    fontSize: 9,
                    color: AppColors.gold,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s.title,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
