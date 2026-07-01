import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/delil_data.dart';
import '../theme/app_theme.dart';
import '../widgets/delil_card_widget.dart';
import '../widgets/marquee_title.dart';
import 'detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final deliller = getByCategory(widget.category);
    final color = AppColors.forCategory(widget.category);
    final icon = AppIcons.forCategory(widget.category);

    final subcats = deliller.map((d) => d.subcategory).toSet().toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.gold),
              onPressed: () {
                if (!_navigating) Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: MarqueeTitle(
                    text: _shortName(widget.category),
                    style: GoogleFonts.notoSerif(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${deliller.length} kart',
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          for (final subcat in subcats) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  children: [
                    Container(width: 3, height: 14, color: color, margin: const EdgeInsets.only(right: 8)),
                    Text(
                      subcat,
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final sub = deliller.where((d) => d.subcategory == subcat).toList();
                  final d = sub[i];
                  return DelilCardWidget(
                    delil: d,
                    onTap: () async {
                      if (_navigating) return;
                      setState(() => _navigating = true);
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (_) => DetailScreen(delil: d),
                      ));
                      if (mounted) setState(() => _navigating = false);
                    },
                  );
                },
                childCount: deliller.where((d) => d.subcategory == subcat).length,
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  String _shortName(String cat) {
    switch (cat) {
      case 'Felsefi ve Kelâmî Deliller': return 'Felsefe & Kelâm';
      case 'Bilimsel ve Doğa Üzerinden Deliller': return 'Bilim & Kâinat';
      case 'İman Hakikatleri ve Risale-i Nur Tarzı Deliller': return 'Risale-i Nur';
      case 'Fıtrat, Ahlak ve İnsan Delilleri': return 'Fıtrat & Ahlak';
      case 'İtirazlar ve Cevap Kartları': return 'İtiraz & Cevap';
      case 'Kâinat ve Günlük Hayat Delilleri': return 'Kâinat & Günlük Hayat';
      case 'Zihin ve Bilinç Delilleri': return 'Zihin & Bilinç';
      default: return cat;
    }
  }
}
