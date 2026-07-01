// Sure listesi + arama. Boş aramada 114 sure listelenir;
// metin girilince sure adı + Türkçe meal + Arapça içinde arama yapılır.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/quran_prefs.dart';
import '../data/quran_repository.dart';
import '../models/quran_models.dart';
import '../quran_theme.dart';
import 'surah_detail_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final _repo = QuranRepository.instance;
  final _prefs = QuranPrefs.instance;
  final _searchCtrl = TextEditingController();
  bool _ready = false;
  String _query = '';
  List<SearchResult> _results = const [];

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
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    setState(() {
      _query = q;
      _results = q.trim().length >= 2
          ? _repo.search(q, _prefs.selectedMeals)
          : const [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text("Sureler",
            style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator(color: QC.greenMain))
          : Column(children: [
              _searchBar(),
              Expanded(
                child: _query.trim().length >= 2 ? _resultsList() : _surahList(),
              ),
            ]),
    );
  }

  Widget _searchBar() {
    return Container(
      color: QC.greenDark,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: TextField(
        controller: _searchCtrl,
        onChanged: _onSearch,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: QC.goldLight,
        decoration: InputDecoration(
          hintText: "Sure adı veya meal içinde ara…",
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: QC.greenPale, size: 20),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white38, size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    _onSearch('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withAlpha(22),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: QC.gold.withAlpha(90))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: QC.gold)),
        ),
      ),
    );
  }

  Widget _surahList() {
    final surahs = _repo.surahs;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      itemCount: surahs.length,
      itemBuilder: (context, i) => _SurahTile(
        surah: surahs[i],
        onTap: () => _open(surahs[i].id, 1),
      ),
    );
  }

  Widget _resultsList() {
    if (_results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text("Sonuç bulunamadı.",
              style: TextStyle(color: QC.greenMain, fontSize: 14)),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final r = _results[i];
        return _ResultTile(
          result: r,
          query: _query.trim(),
          onTap: () => _open(r.surah.id, r.ayah.number),
        );
      },
    );
  }

  void _open(int surahId, int ayah) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => SurahDetailScreen(surahId: surahId, initialAyah: ayah)),
    );
  }
}

class _SurahTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;
  const _SurahTile({required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: QC.greenPale, width: 1.2),
          boxShadow: [
            BoxShadow(
                color: QC.greenMain.withAlpha(16),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          // Sure no rozeti (mihrap formu)
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [QC.greenMain, QC.greenDark]),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: QC.gold.withAlpha(150), width: 1),
            ),
            child: Center(
              child: Text('${surah.id}',
                  style: GoogleFonts.lora(
                      fontSize: 15, fontWeight: FontWeight.w700, color: QC.goldLight)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${surah.turkishName} Suresi",
                  style: GoogleFonts.lora(
                      fontSize: 14.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
              const SizedBox(height: 2),
              Text("${surah.revelation} · ${surah.ayahCount} ayet",
                  style: const TextStyle(fontSize: 11, color: QC.greenMid)),
            ]),
          ),
          Text(surah.arabicName,
              style: const TextStyle(
                  fontFamily: QC.arabicFont, fontSize: 22, color: QC.greenMain)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: QC.greenMid),
        ]),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final SearchResult result;
  final String query;
  final VoidCallback onTap;
  const _ResultTile(
      {required this.result, required this.query, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: QC.greenPale, width: 1.2),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: QC.greenMain, borderRadius: BorderRadius.circular(6)),
              child: Text("${result.surah.turkishName} ${result.ayah.number}",
                  style: const TextStyle(fontSize: 10.5, color: QC.goldLight)),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: QC.greenMid, size: 18),
          ]),
          const SizedBox(height: 8),
          Text(
            result.ayah.turkish,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lora(
                fontSize: 13.5, height: 1.6, color: const Color(0xFF374151)),
          ),
        ]),
      ),
    );
  }
}
