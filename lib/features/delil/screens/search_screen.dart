// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/delil_data.dart';
import '../data/mucize_data.dart';
import '../data/cevap_data.dart';
import '../data/soz_data.dart';
import '../models/delil_model.dart';
import '../models/mucize_model.dart';
import '../models/cevap_model.dart';
import '../models/soz_model.dart';
import '../theme/app_theme.dart';
import '../widgets/delil_card_widget.dart';
import '../widgets/mucize_card_widget.dart';
import '../widgets/cevap_card_widget.dart';
import '../widgets/soz_card_widget.dart';
import 'detail_screen.dart';
import 'mucize_detail_screen.dart';
import 'cevap_detail_screen.dart';
import 'soz_detail_screen.dart';

// ── Result holder ─────────────────────────────────────────────────────────────
class _Results {
  final List<Delil>  deliller;
  final List<Mucize> mucizeler;
  final List<Cevap>  cevaplar;
  final List<Soz>    sozler;

  const _Results({
    this.deliller  = const [],
    this.mucizeler = const [],
    this.cevaplar  = const [],
    this.sozler    = const [],
  });

  int get total =>
      deliller.length + mucizeler.length + cevaplar.length + sozler.length;
  bool get isEmpty => total == 0;
}

// ── Screen ────────────────────────────────────────────────────────────────────
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  _Results _results = const _Results();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final q = _controller.text.trim();
      if (q == _query) return;
      setState(() {
        _query = q;
        if (q.isEmpty) {
          _results = const _Results();
        } else {
          _results = _Results(
            deliller:  search(q),
            mucizeler: searchMucize(q),
            cevaplar:  searchCevap(q),
            sozler:    searchSoz(q),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Arama kutusu ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ara',
                    style: GoogleFonts.notoSerif(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.goldLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.notoSerif(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Delil, mucize, soru veya kişi adı...',
                        hintStyle: GoogleFonts.notoSerif(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.gold, size: 20),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppColors.textMuted, size: 18),
                                onPressed: () => _controller.clear(),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── İçerik ────────────────────────────────────────────────
            Expanded(
              child: _query.isEmpty
                  ? _EmptySearch(
                      onSuggestion: (s) => _controller.text = s)
                  : _results.isEmpty
                      ? _NoResults(query: _query)
                      : _ResultsView(
                          results: _results,
                          onUpdate: () {
                            if (mounted) setState(() {});
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptySearch extends StatelessWidget {
  final ValueChanged<String> onSuggestion;
  const _EmptySearch({required this.onSuggestion});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Big Bang', 'hudus', 'vicdan', 'kötülük', 'evrim',
      'Newton', 'mucize', 'ince ayar', 'bilinç', 'ahlak',
    ];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module chips
          Row(
            children: [
              _ModuleChip('DELİLLER',  AppColors.gold,      Icons.auto_stories_outlined),
              const SizedBox(width: 6),
              _ModuleChip('MUCİZELER', AppColors.tealLight, Icons.star_outline_rounded),
              const SizedBox(width: 6),
              _ModuleChip('CEVAPLAR',  AppColors.purple,    Icons.question_answer_outlined),
              const SizedBox(width: 6),
              _ModuleChip('SÖZLER',    AppColors.rose,      Icons.format_quote_rounded),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Önerilen aramalar',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((s) => GestureDetector(
              onTap: () => onSuggestion(s),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  s,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 40),
          Center(
            child: Icon(Icons.search, size: 64,
                color: AppColors.textMuted.withAlpha(77)),
          ),
        ],
      ),
    );
  }
}

class _ModuleChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _ModuleChip(this.label, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.notoSans(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── No results ────────────────────────────────────────────────────────────────
class _NoResults extends StatelessWidget {
  final String query;
  const _NoResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 56,
              color: AppColors.textMuted.withAlpha(102)),
          const SizedBox(height: 16),
          Text(
            '"$query" için sonuç bulunamadı',
            style: GoogleFonts.notoSerif(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tüm modüllerde arandı',
            style: GoogleFonts.notoSans(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Results view ──────────────────────────────────────────────────────────────
class _ResultsView extends StatefulWidget {
  final _Results results;
  final VoidCallback onUpdate;
  const _ResultsView({required this.results, required this.onUpdate});

  @override
  State<_ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<_ResultsView> {
  @override
  Widget build(BuildContext context) {
    final r = widget.results;

    return CustomScrollView(
      slivers: [
        // Total count
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Text(
                  '${r.total} sonuç',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                if (r.deliller.isNotEmpty)
                  _CountPill('${r.deliller.length} Delil',  AppColors.gold),
                if (r.mucizeler.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  _CountPill('${r.mucizeler.length} Mucize', AppColors.tealLight),
                ],
                if (r.cevaplar.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  _CountPill('${r.cevaplar.length} Cevap',  AppColors.purple),
                ],
                if (r.sozler.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  _CountPill('${r.sozler.length} Söz',      AppColors.rose),
                ],
              ],
            ),
          ),
        ),

        // ── DELİLLER ─────────────────────────────────────────────────
        if (r.deliller.isNotEmpty) ...[
          _sectionHeader('DELİLLER', r.deliller.length,
              AppColors.gold, Icons.auto_stories_outlined),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => DelilCardWidget(
                delil: r.deliller[i],
                onTap: () async {
                  await Navigator.push(ctx, MaterialPageRoute(
                    builder: (_) => DetailScreen(delil: r.deliller[i]),
                  ));
                  if (mounted) setState(() {});
                  widget.onUpdate();
                },
              ),
              childCount: r.deliller.length,
            ),
          ),
        ],

        // ── MUCİZELER ────────────────────────────────────────────────
        if (r.mucizeler.isNotEmpty) ...[
          _sectionHeader('MUCİZELER', r.mucizeler.length,
              AppColors.tealLight, Icons.star_outline_rounded),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => MucizeCardWidget(
                mucize: r.mucizeler[i],
                onTap: () async {
                  await Navigator.push(ctx, MaterialPageRoute(
                    builder: (_) =>
                        MucizeDetailScreen(mucize: r.mucizeler[i]),
                  ));
                  if (mounted) setState(() {});
                  widget.onUpdate();
                },
              ),
              childCount: r.mucizeler.length,
            ),
          ),
        ],

        // ── CEVAPLAR ──────────────────────────────────────────────────
        if (r.cevaplar.isNotEmpty) ...[
          _sectionHeader('CEVAPLAR', r.cevaplar.length,
              AppColors.purple, Icons.question_answer_outlined),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => CevapCardWidget(
                cevap: r.cevaplar[i],
                onTap: () async {
                  await Navigator.push(ctx, MaterialPageRoute(
                    builder: (_) =>
                        CevapDetailScreen(cevap: r.cevaplar[i]),
                  ));
                  if (mounted) setState(() {});
                  widget.onUpdate();
                },
              ),
              childCount: r.cevaplar.length,
            ),
          ),
        ],

        // ── SÖZLER ────────────────────────────────────────────────────
        if (r.sozler.isNotEmpty) ...[
          _sectionHeader('SÖZLER', r.sozler.length,
              AppColors.rose, Icons.format_quote_rounded),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => SozCardWidget(
                soz: r.sozler[i],
                onTap: () async {
                  await Navigator.push(ctx, MaterialPageRoute(
                    builder: (_) => SozDetailScreen(soz: r.sozler[i]),
                  ));
                  if (mounted) setState(() {});
                  widget.onUpdate();
                },
              ),
              childCount: r.sozler.length,
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  SliverToBoxAdapter _sectionHeader(
      String label, int count, Color color, IconData icon) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(icon, color: color, size: 13),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.notoSans(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.notoSans(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Count pill ────────────────────────────────────────────────────────────────
class _CountPill extends StatelessWidget {
  final String label;
  final Color color;
  const _CountPill(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoSans(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
