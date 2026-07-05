// Kur'an-ı Kerim ana ekranı (hub).
// Son okunan yer, sure listesi, favoriler, kaynaklar; altta mini oynatıcı.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/meal_registry.dart';
import '../data/quran_prefs.dart';
import '../data/quran_repository.dart';
import '../models/quran_models.dart';
import '../quran_theme.dart';
import '../widgets/audio_player_bar.dart';
import 'surah_detail_screen.dart';
import 'surah_list_screen.dart';
import 'meal_selection_screen.dart';

class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  final _repo = QuranRepository.instance;
  final _prefs = QuranPrefs.instance;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _repo.ensureLoaded();
    await _prefs.ensureLoaded();
    await _repo.ensureMeals(_prefs.selectedMeals);
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      bottomNavigationBar: const AudioPlayerBar(),
      body: !_ready
          ? const Center(child: CircularProgressIndicator(color: QC.greenMain))
          : AnimatedBuilder(
              animation: _prefs,
              builder: (context, _) => CustomScrollView(slivers: [
                _appBar(),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (_prefs.hasLastRead) _continueCard(),
                      _actionTile(
                        icon: Icons.menu_book_rounded,
                        title: "Sureler",
                        subtitle: "114 sure · Arapça metin + Türkçe meal",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const SurahListScreen())),
                      ),
                      _actionTile(
                        icon: Icons.search_rounded,
                        title: "Ara",
                        subtitle: "Sure adı veya meal içinde arama yap",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const SurahListScreen())),
                      ),
                      _actionTile(
                        icon: Icons.star_rounded,
                        title: "Favori Ayetler",
                        subtitle: _prefs.favorites.isEmpty
                            ? "Henüz favori eklemediniz"
                            : "${_prefs.favorites.length} ayet kaydedildi",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                      ),
                      _actionTile(
                        icon: Icons.translate_rounded,
                        title: "Meal Seçimi",
                        subtitle: _prefs.selectedMeals.length == 1
                            ? mealById(_prefs.selectedMeals.first).name
                            : "${_prefs.selectedMeals.length} meal · karşılaştırmalı",
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const MealSelectionScreen())),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
    );
  }

  Widget _appBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      backgroundColor: QC.greenDark,
      iconTheme: const IconThemeData(color: Colors.white70),
      flexibleSpace: FlexibleSpaceBar(
        title: Text("Kur'an-ı Kerim",
            style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
        centerTitle: true,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [QC.greenDark, QC.greenMain]),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 28),
              child: Text("القرآن الكريم",
                  style: TextStyle(
                      fontFamily: QC.arabicFont, fontSize: 30, color: QC.goldLight)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _continueCard() {
    final s = _repo.surahById(_prefs.lastSurah!);
    final ayah = _prefs.lastAyah ?? 1;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SurahDetailScreen(surahId: s.id, initialAyah: ayah)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [QC.gold, QC.goldLight]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: QC.gold.withAlpha(90), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(children: [
          const Icon(Icons.bookmark_rounded, color: QC.greenDark, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("OKUMAYA DEVAM ET",
                  style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      color: QC.greenDark.withAlpha(180))),
              const SizedBox(height: 3),
              Text("${s.turkishName} Suresi · $ayah. ayet",
                  style: GoogleFonts.lora(
                      fontSize: 15.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
            ]),
          ),
          const Icon(Icons.arrow_forward_rounded, color: QC.greenDark),
        ]),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Color(0xFFFAF7F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: QC.greenPale, width: 1.4),
          boxShadow: [
            BoxShadow(
                color: QC.greenMain.withAlpha(18),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [QC.greenMain, QC.greenDark]),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: QC.goldLight, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: GoogleFonts.lora(
                      fontSize: 15.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
              const SizedBox(height: 3),
              Text(subtitle,
                  style: const TextStyle(fontSize: 11.5, color: QC.greenMid)),
            ]),
          ),
          const Icon(Icons.chevron_right, color: QC.greenMid),
        ]),
      ),
    );
  }
}

// ── Favori Ayetler ──
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _repo = QuranRepository.instance;
  final _prefs = QuranPrefs.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text("Favori Ayetler",
            style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
      ),
      body: AnimatedBuilder(
        animation: _prefs,
        builder: (context, _) {
          final favs = _prefs.favorites
              .map((k) {
                final parts = k.split(':');
                if (parts.length != 2) return null;
                final sid = int.tryParse(parts[0]);
                final num = int.tryParse(parts[1]);
                if (sid == null || num == null) return null;
                return _repo.ayahAt(sid, num, _prefs.selectedMeals);
              })
              .whereType<Ayah>()
              .toList();

          if (favs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.star_outline_rounded, size: 56, color: QC.greenMid),
                  SizedBox(height: 12),
                  Text("Henüz favori ayet yok.",
                      style: TextStyle(fontSize: 15, color: QC.greenMain)),
                  SizedBox(height: 6),
                  Text("Bir ayetin yanındaki yıldıza dokunarak\nfavorilere ekleyebilirsiniz.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: QC.greenMid)),
                ]),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            itemCount: favs.length,
            itemBuilder: (context, i) {
              final a = favs[i];
              final s = _repo.surahById(a.surahId);
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          SurahDetailScreen(surahId: a.surahId, initialAyah: a.number)),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Color(0xFFFAF7F0),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: QC.greenPale, width: 1.2),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                            color: QC.greenMain, borderRadius: BorderRadius.circular(6)),
                        child: Text("${s.turkishName} ${a.number}",
                            style: const TextStyle(fontSize: 10.5, color: QC.goldLight)),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => _prefs.toggleFavorite(a.key),
                        child: const Icon(Icons.star_rounded, color: QC.gold, size: 22),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Text(a.arabic,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                            fontFamily: QC.arabicFont, fontSize: 20, height: 1.9, color: QC.greenDark)),
                    const SizedBox(height: 8),
                    Text(a.turkish,
                        style: GoogleFonts.lora(
                            fontSize: 13.5, height: 1.6, color: const Color(0xFF374151))),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
