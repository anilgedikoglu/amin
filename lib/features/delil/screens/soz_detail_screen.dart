// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/soz_model.dart';
import '../theme/app_theme.dart';
import '../services/read_tracker.dart';
import '../services/time_tracker.dart';
import '../services/ad_service.dart';

class SozDetailScreen extends StatefulWidget {
  final Soz soz;
  const SozDetailScreen({super.key, required this.soz});

  @override
  State<SozDetailScreen> createState() => _SozDetailScreenState();
}

class _SozDetailScreenState extends State<SozDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _heightFactor;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    ReadTracker.instance.markRead(widget.soz.id);
    TimeTracker.instance.startSession('soz');
    AdService.instance.onCardRead();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactor = CurvedAnimation(
      parent: _animCtrl,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    TimeTracker.instance.endSession('soz');
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _animCtrl.forward();
      } else {
        _animCtrl.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final soz       = widget.soz;
    final catColor  = SozColors.forCategory(soz.category);
    final catColorDim = SozColors.dimForCategory(soz.category);
    final catIcon   = SozColors.iconForCategory(soz.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.surface,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                Icon(catIcon, color: catColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    soz.category,
                    style: GoogleFonts.notoSans(
                      color: catColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Person header ────────────────────────────────────
                  _PersonHeader(soz: soz, catColor: catColor),
                  const SizedBox(height: 20),

                  // ── Main quote box ───────────────────────────────────
                  _QuoteBox(soz: soz, catColor: catColor, catColorDim: catColorDim),
                  const SizedBox(height: 16),

                  // ── Original expression (if different) ───────────────
                  if (soz.quoteTurkish.isNotEmpty &&
                      soz.quoteOriginalOrView.isNotEmpty) ...[
                    _OriginalBox(soz: soz, catColor: catColor, catColorDim: catColorDim),
                    const SizedBox(height: 16),
                  ],

                  // ── What it supports ────────────────────────────────
                  if (soz.whatItSupports.isNotEmpty) ...[
                    _InfoRow(
                      icon: Icons.lightbulb_outline,
                      label: 'Ne Destekliyor?',
                      value: soz.whatItSupports,
                      catColor: catColor,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── Source ───────────────────────────────────────────
                  if (soz.source.isNotEmpty) ...[
                    _InfoRow(
                      icon: Icons.link_outlined,
                      label: 'Kaynak',
                      value: soz.source,
                      catColor: catColor,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── Reliability note ─────────────────────────────────
                  if (soz.sourceReliabilityNote.isNotEmpty) ...[
                    _InfoRow(
                      icon: Icons.verified_outlined,
                      label: 'Kaynak Notu',
                      value: soz.sourceReliabilityNote,
                      catColor: catColor,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── Why relevant ─────────────────────────────────────
                  if (soz.whyRelevant.isNotEmpty) ...[
                    _InfoRow(
                      icon: Icons.connect_without_contact_outlined,
                      label: 'Neden Önemli?',
                      value: soz.whyRelevant,
                      catColor: catColor,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Tags ─────────────────────────────────────────────
                  if (soz.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: soz.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: catColorDim,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: catColor.withAlpha(60)),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.notoSans(
                              color: catColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Expandable detailed explanation ──────────────────
                  if (soz.detailedExplanation.isNotEmpty)
                    _ExpandableDetail(
                      detailedExplanation: soz.detailedExplanation,
                      catColor: catColor,
                      catColorDim: catColorDim,
                      expanded: _expanded,
                      heightFactor: _heightFactor,
                      onToggle: _toggleExpand,
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

// ── Person header ─────────────────────────────────────────────────────────────
class _PersonHeader extends StatelessWidget {
  final Soz soz;
  final Color catColor;
  const _PersonHeader({required this.soz, required this.catColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar circle
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: catColor.withAlpha(30),
            shape: BoxShape.circle,
            border: Border.all(color: catColor.withAlpha(100), width: 2),
          ),
          child: Center(
            child: Text(
              soz.person.isNotEmpty ? soz.person[0].toUpperCase() : '?',
              style: GoogleFonts.notoSerif(
                color: catColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                soz.person,
                style: GoogleFonts.notoSerif(
                  color: AppColors.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (soz.whoIs.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  soz.whoIs,
                  style: GoogleFonts.notoSans(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ── Main quote box ────────────────────────────────────────────────────────────
class _QuoteBox extends StatelessWidget {
  final Soz soz;
  final Color catColor;
  final Color catColorDim;
  const _QuoteBox(
      {required this.soz,
      required this.catColor,
      required this.catColorDim});

  @override
  Widget build(BuildContext context) {
    final text = soz.quoteTurkish.isNotEmpty
        ? soz.quoteTurkish
        : soz.quoteOriginalOrView;
    final label = soz.quoteTurkish.isNotEmpty ? 'TÜRKÇE' : 'İFADE';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: catColorDim,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: catColor.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote, color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.notoSans(
                  color: AppColors.gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: GoogleFonts.notoSerif(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Original expression box ───────────────────────────────────────────────────
class _OriginalBox extends StatelessWidget {
  final Soz soz;
  final Color catColor;
  final Color catColorDim;
  const _OriginalBox(
      {required this.soz,
      required this.catColor,
      required this.catColorDim});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORİJİNAL / GÖRÜŞ',
            style: GoogleFonts.notoSans(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            soz.quoteOriginalOrView,
            style: GoogleFonts.notoSerif(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color catColor;
  const _InfoRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.catColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: catColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.notoSans(
                    color: catColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.notoSans(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    height: 1.5,
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

// ── Expandable detailed explanation ──────────────────────────────────────────
class _ExpandableDetail extends StatelessWidget {
  final String detailedExplanation;
  final Color catColor;
  final Color catColorDim;
  final bool expanded;
  final Animation<double> heightFactor;
  final VoidCallback onToggle;

  const _ExpandableDetail({
    required this.detailedExplanation,
    required this.catColor,
    required this.catColorDim,
    required this.expanded,
    required this.heightFactor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          // Header / toggle button
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.auto_stories_outlined,
                      color: catColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Detaylı Açıklama',
                    style: GoogleFonts.notoSans(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5)
                        .animate(heightFactor),
                    child: Icon(Icons.keyboard_arrow_down,
                        color: catColor, size: 20),
                  ),
                ],
              ),
            ),
          ),
          // Expandable content
          ClipRect(
            child: AnimatedAlign(
              alignment: Alignment.topCenter,
              heightFactor: expanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: AppColors.cardBorder),
                    const SizedBox(height: 6),
                    Text(
                      detailedExplanation,
                      style: GoogleFonts.notoSans(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
