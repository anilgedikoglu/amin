// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/soz_data.dart';
import '../models/soz_model.dart';
import '../theme/app_theme.dart';
import '../widgets/soz_card_widget.dart';
import '../widgets/marquee_title.dart';
import 'soz_detail_screen.dart';

class SozCategoryScreen extends StatefulWidget {
  final String category;
  const SozCategoryScreen({super.key, required this.category});

  @override
  State<SozCategoryScreen> createState() => _SozCategoryScreenState();
}

class _SozCategoryScreenState extends State<SozCategoryScreen> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final catColor    = SozColors.forCategory(widget.category);
    final catColorDim = SozColors.dimForCategory(widget.category);
    final catIcon     = SozColors.iconForCategory(widget.category);
    final cards       = getSozByCategory(widget.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.surface,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.gold),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                Icon(catIcon, color: catColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: MarqueeTitle(
                    text: widget.category,
                    style: GoogleFonts.notoSerif(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: catColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cards.length} Söz',
                  style: GoogleFonts.notoSans(
                    color: catColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final soz = cards[index];
                return SozCardWidget(
                  soz: soz,
                  onTap: () {
                    if (_navigating) return;
                    _navigating = true;
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (_) => SozDetailScreen(soz: soz),
                        ))
                        .then((_) => _navigating = false);
                  },
                );
              },
              childCount: cards.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
