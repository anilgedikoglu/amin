// Sure detay ekranı: Arapça metin + Türkçe meal, ayet ayet kartlar,
// tüm sureyi/ayeti dinle, favori, font kontrolü, AR/meal toggle,
// offline indirme ve altta mini oynatıcı.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/meal_registry.dart';
import '../data/quran_audio_service.dart';
import '../data/quran_prefs.dart';
import '../data/quran_repository.dart';
import '../models/quran_models.dart';
import '../quran_theme.dart';
import '../widgets/audio_player_bar.dart';
import '../widgets/ayah_card.dart';
import 'meal_selection_screen.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahId;
  final int initialAyah;
  const SurahDetailScreen({super.key, required this.surahId, this.initialAyah = 1});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final _repo = QuranRepository.instance;
  final _prefs = QuranPrefs.instance;
  final _audio = QuranAudioService.instance;
  final _scroll = ScrollController();

  late Surah _surah;
  bool _ready = false;
  bool _downloaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _repo.ensureLoaded();
    await _prefs.ensureLoaded();
    await _audio.ensureInit();
    await _repo.ensureMeals(_prefs.selectedMeals);
    _surah = _repo.surahById(widget.surahId);
    _downloaded = await _audio.isSurahDownloaded(_surah);
    await _prefs.setLastRead(widget.surahId, widget.initialAyah);
    _prefs.addListener(_onPrefs);
    if (mounted) setState(() => _ready = true);
    _jumpToInitial();
  }

  // Meal seçimi değişince yeni meal dosyalarını yükle, sonra yenile.
  void _onPrefs() async {
    await _repo.ensureMeals(_prefs.selectedMeals);
    if (mounted) setState(() {});
  }

  void _jumpToInitial() {
    if (widget.initialAyah <= 1) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      // Değişken yükseklikler için yaklaşık konum (her kart ~ 170px)
      final target = (widget.initialAyah - 1) * 170.0;
      _scroll.jumpTo(target.clamp(0, _scroll.position.maxScrollExtent));
    });
  }

  @override
  void dispose() {
    _prefs.removeListener(_onPrefs);
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _toggleDownload() async {
    if (_downloaded) {
      await _audio.deleteDownload(_surah);
      if (mounted) setState(() => _downloaded = false);
    } else {
      await _audio.downloadSurah(_surah);
      final ok = await _audio.isSurahDownloaded(_surah);
      if (mounted) setState(() => _downloaded = ok);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: QC.greenBg,
        body: Center(child: CircularProgressIndicator(color: QC.greenMain)),
      );
    }
    return Scaffold(
      backgroundColor: QC.greenBg,
      bottomNavigationBar: const AudioPlayerBar(),
      body: AnimatedBuilder(
        animation: _prefs,
        builder: (context, _) {
          final ayahs = _repo.ayahsOf(_surah.id, _prefs.selectedMeals);
          return CustomScrollView(
            controller: _scroll,
            slivers: [
              _buildHeader(),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
                sliver: ValueListenableBuilder<Surah?>(
                  valueListenable: _audio.currentSurah,
                  builder: (context, playingSurah, __) {
                    return StreamBuilder<int?>(
                      stream: _audio.player.currentIndexStream,
                      builder: (context, snap) {
                        final playingAyah = (playingSurah?.id == _surah.id)
                            ? (snap.data ?? -1) + 1
                            : -1;
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final a = ayahs[i];
                              return AyahCard(
                                ayah: a,
                                fontScale: _prefs.fontScale,
                                showArabic: _prefs.showArabic,
                                showOkunus: _prefs.showOkunus,
                                showMeal: _prefs.showMeal,
                                isFavorite: _prefs.isFavorite(a.key),
                                isPlaying: playingAyah == a.number,
                                onPlay: () {
                                  _audio.playAyah(_surah, a.number);
                                  _prefs.setLastRead(_surah.id, a.number);
                                },
                                onToggleFavorite: () => _prefs.toggleFavorite(a.key),
                              );
                            },
                            childCount: ayahs.length,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 280,
      backgroundColor: QC.greenDark,
      iconTheme: const IconThemeData(color: Colors.white70),
      title: Text(_surah.turkishName,
          style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
      actions: [
        IconButton(
          tooltip: "Meal seçimi / karşılaştırma",
          icon: const Icon(Icons.translate_rounded, color: Colors.white70),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MealSelectionScreen())),
        ),
        IconButton(
          tooltip: _downloaded ? "İndirildi (sil)" : "Çevrimdışı indir",
          icon: ValueListenableBuilder<bool>(
            valueListenable: _audio.downloading,
            builder: (context, dl, _) {
              if (dl) {
                return ValueListenableBuilder<double>(
                  valueListenable: _audio.downloadProgress,
                  builder: (context, p, __) => SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        value: p, strokeWidth: 2.5, color: QC.goldLight),
                  ),
                );
              }
              return Icon(
                  _downloaded ? Icons.download_done_rounded : Icons.download_rounded,
                  color: _downloaded ? QC.greenLight : Colors.white70);
            },
          ),
          onPressed: _toggleDownload,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [QC.greenDark, QC.greenMain]),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 44, 20, 12),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(_surah.arabicName,
                    style: const TextStyle(
                        fontFamily: QC.arabicFont, fontSize: 34, color: QC.goldLight)),
                const SizedBox(height: 2),
                Text("${_surah.turkishName} Suresi",
                    style: GoogleFonts.lora(
                        fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 6),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: [
                    _chip("${_surah.ayahCount} Ayet"),
                    _chip(_surah.revelation),
                    _chip("Nüzul ${_surah.revelationOrder}."),
                  ],
                ),
                const SizedBox(height: 12),
                _toolbar(),
                const SizedBox(height: 10),
                _mealButton(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
            color: Colors.white.withAlpha(28),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: QC.gold.withAlpha(120))),
        child: Text(t, style: const TextStyle(fontSize: 10.5, color: QC.greenPale)),
      );

  // "Dinle"nin hemen altında pratik meal (çevirmen) seçimi.
  Widget _mealButton() {
    final sel = _prefs.selectedMeals;
    final label = sel.length == 1
        ? mealById(sel.first).name
        : '${sel.length} meal seçili';
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const MealSelectionScreen())),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
            color: Colors.white.withAlpha(28),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: QC.gold.withAlpha(130))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.menu_book_rounded, color: QC.goldLight, size: 16),
          const SizedBox(width: 7),
          Flexible(
            child: Text('Meal: $label',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lora(
                    fontSize: 12.5, fontWeight: FontWeight.w600, color: QC.greenPale)),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.expand_more_rounded, color: QC.goldLight, size: 18),
        ]),
      ),
    );
  }

  Widget _toolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      // Tüm sureyi dinle
      GestureDetector(
        onTap: () => _audio.playSurah(_surah, startAyah: 1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [QC.gold, QC.goldLight]),
              borderRadius: BorderRadius.circular(22)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.play_arrow_rounded, color: QC.greenDark, size: 20),
            const SizedBox(width: 4),
            Text("Dinle",
                style: GoogleFonts.lora(
                    fontSize: 13, fontWeight: FontWeight.w700, color: QC.greenDark)),
          ]),
        ),
      ),
      const SizedBox(width: 8),
      _circleBtn(Icons.text_decrease_rounded, () => _prefs.bumpFont(-0.1)),
      _circleBtn(Icons.text_increase_rounded, () => _prefs.bumpFont(0.1)),
      _toggleBtn("ع", _prefs.showArabic, () => _prefs.setShowArabic(!_prefs.showArabic)),
      _toggleBtn("Oku", _prefs.showOkunus, () => _prefs.setShowOkunus(!_prefs.showOkunus)),
      _toggleBtn("Meâl", _prefs.showMeal, () => _prefs.setShowMeal(!_prefs.showMeal)),
    ]),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.white.withAlpha(28),
                shape: BoxShape.circle,
                border: Border.all(color: QC.gold.withAlpha(120))),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      );

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 30,
            constraints: const BoxConstraints(minWidth: 30),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
                color: active ? QC.gold : Colors.white.withAlpha(28),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: QC.gold.withAlpha(160))),
            child: Text(label,
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: active ? QC.greenDark : Colors.white)),
          ),
        ),
      );
}
