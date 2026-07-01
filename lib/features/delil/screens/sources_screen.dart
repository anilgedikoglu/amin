// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sources_data.dart';
import '../models/delil_model.dart';
import '../theme/app_theme.dart';

class SourcesScreen extends StatelessWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Başlık ────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kaynaklar',
                      style: GoogleFonts.notoSerif(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.goldLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tüm modüllerde kullanılan akademik, dinî ve editoryal kaynaklar',
                      style: GoogleFonts.notoSerif(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Her modül için bölüm ───────────────────────────────────
            for (final module in sourceModules) ...[
              SliverToBoxAdapter(
                child: _ModuleHeader(module: module),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final sources = getSourcesByModule(module);
                    return _SourceTile(source: sources[i]);
                  },
                  childCount: getSourcesByModule(module).length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
            ],

            // ── Editoryal not ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.gold.withAlpha(51)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: AppColors.gold, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Editoryal Not',
                            style: GoogleFonts.notoSerif(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bu içerik, uygulama kartları için hazırlanmış özet '
                        've telif açısından özgünleştirilmiş açıklamalardır. '
                        'Deliller kesin matematik ispat gibi değil; felsefi, '
                        'kelâmî, bilimsel ve fıtrî gerekçeler olarak '
                        'sunulmalıdır. Sözler bölümündeki atıflar mümkün '
                        'olduğunca birincil kaynaklardan doğrulanmıştır; '
                        'doğrudan alıntı olmayan maddeler "görüş özeti" '
                        'olarak işaretlenmiştir.',
                        style: GoogleFonts.notoSerif(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
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
      ),
    );
  }
}

// ── Modül bölüm başlığı ───────────────────────────────────────────────────────
class _ModuleHeader extends StatelessWidget {
  final String module;
  const _ModuleHeader({required this.module});

  IconData get _icon {
    switch (module) {
      case 'DELİLLER':  return Icons.auto_stories_outlined;
      case 'MUCİZELER': return Icons.star_outline_rounded;
      case 'CEVAPLAR':  return Icons.question_answer_outlined;
      case 'SÖZLER':    return Icons.format_quote_rounded;
      default:          return Icons.folder_outlined;
    }
  }

  Color get _color {
    switch (module) {
      case 'DELİLLER':  return AppColors.gold;
      case 'MUCİZELER': return AppColors.tealLight;
      case 'CEVAPLAR':  return AppColors.purple;
      case 'SÖZLER':    return AppColors.rose;
      default:          return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = getSourcesByModule(module).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: _color.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_icon, color: _color, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            module,
            style: GoogleFonts.notoSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _color,
              letterSpacing: 0.6,
            ),
          ),
          const Spacer(),
          Text(
            '$count kaynak',
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

// ── Kaynak kartı ──────────────────────────────────────────────────────────────
class _SourceTile extends StatelessWidget {
  final DelilSource source;
  const _SourceTile({required this.source});

  Color get _moduleColor {
    switch (source.module) {
      case 'DELİLLER':  return AppColors.gold;
      case 'MUCİZELER': return AppColors.tealLight;
      case 'CEVAPLAR':  return AppColors.purple;
      case 'SÖZLER':    return AppColors.rose;
      default:          return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _moduleColor;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withAlpha(38),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    source.code,
                    style: GoogleFonts.notoSans(
                      fontSize: 9,
                      color: color,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    source.title,
                    style: GoogleFonts.notoSerif(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (source.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                source.description,
                style: GoogleFonts.notoSans(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.link, color: AppColors.textMuted, size: 13),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      source.url,
                      style: GoogleFonts.notoSans(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
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
