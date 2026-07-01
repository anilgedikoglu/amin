import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/delil_data.dart';
import '../data/mucize_data.dart';
import '../data/cevap_data.dart';
import '../data/soz_data.dart';
import '../services/read_tracker.dart';
import '../services/time_tracker.dart';
import '../theme/app_theme.dart';
import '../widgets/delil_card_widget.dart';
import '../widgets/mucize_card_widget.dart';
import '../widgets/cevap_card_widget.dart';
import '../widgets/soz_card_widget.dart';
import 'detail_screen.dart';
import 'category_screen.dart';
import 'mucize_category_screen.dart';
import 'mucize_detail_screen.dart';
import 'cevap_category_screen.dart';
import 'cevap_detail_screen.dart';
import 'soz_category_screen.dart';
import 'soz_detail_screen.dart';

class DelilHomeScreen extends StatefulWidget {
  final int initialTab; // 0=Deliller 1=Mucizeler 2=Cevaplar 3=Sözler
  const DelilHomeScreen({super.key, this.initialTab = 0});

  @override
  State<DelilHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<DelilHomeScreen> {
  late final List<dynamic> _recommended;
  late final List<dynamic> _recommendedMucize;
  late final List<dynamic> _recommendedCevap;
  late final List<dynamic> _recommendedSoz;
  int _activeTab = 0; // 0=Deliller 1=Mucizeler 2=Cevaplar 3=Sözler

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
    _recommended       = getRecommended();
    _recommendedMucize = getRecommendedMucize();
    _recommendedCevap  = getRecommendedCevap();
    _recommendedSoz    = getRecommendedSoz();
  }

  @override
  Widget build(BuildContext context) {
    final tab = widget.initialTab;
    const titles = ['Deliller', 'Mucizeler', 'Cevaplar', 'Sözler'];
    final counts = [allDeliller.length, allMucizeler.length, allCevaplar.length, allSozler.length];
    const units = ['Delil', 'Mucize', 'Cevap', 'Söz'];

    Widget content;
    switch (tab) {
      case 1:
        content = _MucizelerContent(
            recommended: _recommendedMucize, onUpdate: () { if (mounted) setState(() {}); });
        break;
      case 2:
        content = _CevaplarContent(
            recommended: _recommendedCevap, onUpdate: () { if (mounted) setState(() {}); });
        break;
      case 3:
        content = _SozlerContent(
            recommended: _recommendedSoz, onUpdate: () { if (mounted) setState(() {}); });
        break;
      default:
        content = _DelillerContent(
            recommended: _recommended,
            onUpdate: () { if (mounted) setState(() {}); },
            shortCatName: _shortCatName);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      // Tek bölüm + amin menüsüne dönüş için geri tuşu. Sekme geçişi yok.
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.gold),
        title: Text(
          titles[tab],
          style: GoogleFonts.notoSerif(
              fontSize: 19, fontWeight: FontWeight.w700,
              color: AppColors.goldLight, letterSpacing: 0.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gold.withOpacity(0.35)),
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.gold.withOpacity(0.08),
                ),
                child: Text(
                  '${counts[tab]} ${units[tab]}',
                  style: GoogleFonts.notoSans(
                      fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: content,
    );
  }

  static String _shortCatName(String cat) {
    switch (cat) {
      case 'Felsefi ve Kelâmî Deliller':                      return 'Felsefe & Kelâm';
      case 'Bilimsel ve Doğa Üzerinden Deliller':             return 'Bilim & Kâinat';
      case 'İman Hakikatleri ve Risale-i Nur Tarzı Deliller': return 'Risale Tarzı';
      case 'Fıtrat, Ahlak ve İnsan Delilleri':                return 'Fıtrat & Ahlak';
      case 'İtirazlar ve Cevap Kartları':                     return 'İtiraz-Cevap';
      case 'Kâinat ve Günlük Hayat Delilleri':                return 'Günlük Hayat';
      case 'Zihin ve Bilinç Delilleri':                       return 'Zihin & Bilinç';
      default: return cat;
    }
  }
}

// ── Tab Butonu ────────────────────────────────────────────────────────────────
class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.gold : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 12,
                color: isActive ? AppColors.gold : AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.notoSans(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.gold : AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Deliller İçeriği ──────────────────────────────────────────────────────────
class _DelillerContent extends StatelessWidget {
  final List<dynamic> recommended;
  final VoidCallback onUpdate;
  final String Function(String) shortCatName;

  const _DelillerContent({
    required this.recommended,
    required this.onUpdate,
    required this.shortCatName,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
                Text('En Güçlü 12 Delil',
                    style: GoogleFonts.notoSerif(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const Spacer(),
                Text('Önerilen Rota',
                    style: GoogleFonts.notoSans(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: recommended.length,
              itemBuilder: (context, i) => DelilCardFeatured(
                delil: recommended[i],
                index: i,
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => DetailScreen(delil: recommended[i]),
                  ));
                  onUpdate();
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              children: [
                const Icon(Icons.grid_view_rounded, color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
                Text('Kategoriler',
                    style: GoogleFonts.notoSerif(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final cat      = allCategories[i];
                final count    = getByCategory(cat).length;
                final color    = AppColors.forCategory(cat);
                final dimColor = AppColors.dimForCategory(cat);
                final icon     = AppIcons.forCategory(cat);
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CategoryScreen(category: cat),
                  )),
                  child: _CategoryTile(
                    name: shortCatName(cat),
                    count: count,
                    label: 'delil',
                    color: color,
                    dimColor: dimColor,
                    icon: icon,
                  ),
                );
              },
              childCount: allCategories.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: _BottomStatLine(
            idPrefix: 'DELIL-', total: 117, module: 'delil'),
        ),
      ],
    );
  }
}

// ── Mucizeler İçeriği ─────────────────────────────────────────────────────────
class _MucizelerContent extends StatelessWidget {
  final List<dynamic> recommended;
  final VoidCallback onUpdate;

  const _MucizelerContent({
    required this.recommended,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.star_outline_rounded, color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
                Text('Öne Çıkan 12 Mucize',
                    style: GoogleFonts.notoSerif(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const Spacer(),
                Text('Seçki',
                    style: GoogleFonts.notoSans(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 248,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: recommended.length,
              itemBuilder: (context, i) => MucizeCardFeatured(
                mucize: recommended[i],
                index: i,
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => MucizeDetailScreen(mucize: recommended[i]),
                  ));
                  onUpdate();
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              children: [
                const Icon(Icons.grid_view_rounded, color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
                Text('Kategoriler',
                    style: GoogleFonts.notoSerif(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final cat      = allMucizeCategories[i];
                final count    = getMucizeByCategory(cat).length;
                final color    = MucizeColors.forCategory(cat);
                final dimColor = MucizeColors.dimForCategory(cat);
                final icon     = MucizeColors.iconForCategory(cat);
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => MucizeCategoryScreen(category: cat),
                  )),
                  child: _CategoryTile(
                    name: cat,
                    count: count,
                    label: 'kart',
                    color: color,
                    dimColor: dimColor,
                    icon: icon,
                  ),
                );
              },
              childCount: allMucizeCategories.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: _BottomStatLine(
            idPrefix: 'MUCIZE-', total: 1000, module: 'mucize'),
        ),
      ],
    );
  }
}

// ── Cevaplar İçeriği ──────────────────────────────────────────────────────────
class _CevaplarContent extends StatelessWidget {
  final List<dynamic> recommended;
  final VoidCallback onUpdate;

  const _CevaplarContent({
    required this.recommended,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.question_answer_outlined, color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
                Text('Öne Çıkan 12 Cevap',
                    style: GoogleFonts.notoSerif(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const Spacer(),
                Text('Seçki',
                    style: GoogleFonts.notoSans(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 248,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: recommended.length,
              itemBuilder: (context, i) => CevapCardFeatured(
                cevap: recommended[i],
                index: i,
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CevapDetailScreen(cevap: recommended[i]),
                  ));
                  onUpdate();
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              children: [
                const Icon(Icons.grid_view_rounded, color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
                Text('Bölümler',
                    style: GoogleFonts.notoSerif(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final sec      = allCevapSections[i];
                final count    = getCevapBySection(sec).length;
                final color    = CevapColors.forSection(sec);
                final dimColor = CevapColors.dimForSection(sec);
                final icon     = CevapColors.iconForSection(sec);
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CevapCategoryScreen(section: sec),
                  )),
                  child: _CategoryTile(
                    name: sec,
                    count: count,
                    label: 'kart',
                    color: color,
                    dimColor: dimColor,
                    icon: icon,
                  ),
                );
              },
              childCount: allCevapSections.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: _BottomStatLine(
            idPrefix: 'CEVAP-', total: 1000, module: 'cevap'),
        ),
      ],
    );
  }
}

// ── Sözler İçeriği ───────────────────────────────────────────────────────────
class _SozlerContent extends StatelessWidget {
  final List<dynamic> recommended;
  final VoidCallback onUpdate;

  const _SozlerContent({
    required this.recommended,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.format_quote_rounded,
                    color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
                Text('Öne Çıkan 12 Söz',
                    style: GoogleFonts.notoSerif(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const Spacer(),
                Text('Seçki',
                    style: GoogleFonts.notoSans(
                        fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: recommended.length,
              itemBuilder: (context, i) => SozCardFeatured(
                soz: recommended[i],
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SozDetailScreen(soz: recommended[i]),
                    ),
                  );
                  onUpdate();
                },
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(
              children: [
                const Icon(Icons.grid_view_rounded,
                    color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
                Text('Kategoriler',
                    style: GoogleFonts.notoSerif(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final cat      = allSozCategories[i];
                final count    = getSozByCategory(cat).length;
                final color    = SozColors.forCategory(cat);
                final dimColor = SozColors.dimForCategory(cat);
                final icon     = SozColors.iconForCategory(cat);
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SozCategoryScreen(category: cat),
                    ),
                  ),
                  child: _CategoryTile(
                    name: cat,
                    count: count,
                    label: 'söz',
                    color: color,
                    dimColor: dimColor,
                    icon: icon,
                  ),
                );
              },
              childCount: allSozCategories.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: _BottomStatLine(
            idPrefix: 'SOZ-', total: 1000, module: 'soz'),
        ),
      ],
    );
  }
}

// ── Scroll altı istatistik satırı ────────────────────────────────────────────
class _BottomStatLine extends StatelessWidget {
  final String idPrefix;
  final int    total;
  final String module;

  const _BottomStatLine({
    required this.idPrefix,
    required this.total,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    // "X dk okundu • %Y tamamlandı" etiketi kaldırıldı (kullanıcı isteği).
    return const SizedBox(height: 16);
  }
}

// ── Paylaşılan kategori tile ──────────────────────────────────────────────────
class _CategoryTile extends StatelessWidget {
  final String name;
  final int count;
  final String label;
  final Color color;
  final Color dimColor;
  final IconData icon;

  const _CategoryTile({
    required this.name,
    required this.count,
    required this.label,
    required this.color,
    required this.dimColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(
              right: -10, bottom: -10,
              child: Icon(icon, size: 60, color: color.withOpacity(0.06)),
            ),
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color.withOpacity(0.2)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: dimColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                  const Spacer(),
                  Text(
                    name,
                    style: GoogleFonts.notoSerif(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count $label',
                    style: GoogleFonts.notoSans(
                      fontSize: 11,
                      color: color.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
