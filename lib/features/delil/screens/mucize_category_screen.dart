import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/mucize_data.dart';
import '../theme/app_theme.dart';
import '../widgets/mucize_card_widget.dart';
import '../widgets/marquee_title.dart';
import 'mucize_detail_screen.dart';

class MucizeCategoryScreen extends StatefulWidget {
  final String category;
  const MucizeCategoryScreen({super.key, required this.category});

  @override
  State<MucizeCategoryScreen> createState() => _MucizeCategoryScreenState();
}

class _MucizeCategoryScreenState extends State<MucizeCategoryScreen> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final mucizeler = getMucizeByCategory(widget.category);
    final color     = MucizeColors.forCategory(widget.category);
    final icon      = MucizeColors.iconForCategory(widget.category);
    // subcategory grouping
    final subcats   = mucizeler.map((m) => m.subcategory).toSet().toList();

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
                    text: widget.category,
                    style: GoogleFonts.notoSerif(
                      fontSize: 16,
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
                  '${mucizeler.length} kart',
                  style: GoogleFonts.notoSans(
                      fontSize: 11, color: color, fontWeight: FontWeight.w600),
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
                    Container(width: 3, height: 14, color: color,
                        margin: const EdgeInsets.only(right: 8)),
                    Text(subcat, style: GoogleFonts.notoSans(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: color, letterSpacing: 0.5,
                    )),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final sub = mucizeler
                      .where((m) => m.subcategory == subcat)
                      .toList();
                  final m = sub[i];
                  return MucizeCardWidget(
                    mucize: m,
                    onTap: () async {
                      if (_navigating) return;
                      setState(() => _navigating = true);
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (_) => MucizeDetailScreen(mucize: m),
                      ));
                      if (mounted) setState(() => _navigating = false);
                    },
                  );
                },
                childCount: mucizeler
                    .where((m) => m.subcategory == subcat)
                    .length,
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}
