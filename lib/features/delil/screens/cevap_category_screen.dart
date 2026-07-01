import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/cevap_data.dart';
import '../theme/app_theme.dart';
import '../widgets/cevap_card_widget.dart';
import '../widgets/marquee_title.dart';
import 'cevap_detail_screen.dart';

class CevapCategoryScreen extends StatefulWidget {
  final String section;
  const CevapCategoryScreen({super.key, required this.section});

  @override
  State<CevapCategoryScreen> createState() => _CevapCategoryScreenState();
}

class _CevapCategoryScreenState extends State<CevapCategoryScreen> {
  bool _navigating = false;

  @override
  Widget build(BuildContext context) {
    final cevaplar = getCevapBySection(widget.section);
    final color    = CevapColors.forSection(widget.section);
    final icon     = CevapColors.iconForSection(widget.section);

    // Group by askerProfile
    final profiles = cevaplar.map((c) => c.askerProfile).toSet().toList();

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
                    text: widget.section,
                    style: GoogleFonts.notoSerif(
                      fontSize: 14,
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
                  '${cevaplar.length} kart',
                  style: GoogleFonts.notoSans(
                      fontSize: 11, color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          for (final profile in profiles) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  children: [
                    Container(width: 3, height: 14, color: color,
                        margin: const EdgeInsets.only(right: 8)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: CevapColors.forProfile(profile).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        CevapColors.labelForProfile(profile),
                        style: GoogleFonts.notoSans(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: CevapColors.forProfile(profile),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final sub = cevaplar
                      .where((c) => c.askerProfile == profile)
                      .toList();
                  final cevap = sub[i];
                  return CevapCardWidget(
                    cevap: cevap,
                    onTap: () async {
                      if (_navigating) return;
                      setState(() => _navigating = true);
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (_) => CevapDetailScreen(cevap: cevap),
                      ));
                      if (mounted) setState(() => _navigating = false);
                    },
                  );
                },
                childCount: cevaplar
                    .where((c) => c.askerProfile == profile)
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
