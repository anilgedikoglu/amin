import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../quran/quran_theme.dart';
import '../data/sacred_repository.dart';
import '../models/sacred_models.dart';
import 'sacred_reader_screen.dart';

class SacredHomeScreen extends StatefulWidget {
  const SacredHomeScreen({super.key});

  @override
  State<SacredHomeScreen> createState() => _SacredHomeScreenState();
}

class _SacredHomeScreenState extends State<SacredHomeScreen> {
  final _repo = SacredRepository.instance;
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _searching = false;
  List<SacredHit> _results = [];

  @override
  void initState() {
    super.initState();
    // Arama hızlı olsun diye metinleri arka planda yükle.
    _repo.ensureAll();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _query = v;
    _debounce?.cancel();
    if (v.trim().length < 2) {
      setState(() {
        _results = [];
        _searching = false;
      });
      return;
    }
    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final hits = await _repo.search(v);
      if (!mounted || v != _query) return;
      setState(() {
        _results = hits;
        _searching = false;
      });
    });
  }

  Future<void> _openText(String id) async {
    final text = await _repo.load(id);
    if (!mounted) return;
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => SacredReaderScreen(text: text)));
  }

  Future<void> _openHit(SacredHit h) async {
    final text = await _repo.load(h.textId);
    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SacredReaderScreen(
                  text: text,
                  initialBook: h.bookIndex,
                  initialChapter: h.chapterIndex,
                  highlightVerse: h.verseIndex,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final searching = _query.trim().length >= 2;
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Kutsal Metinler')),
      body: Column(children: [
        _searchField(),
        Expanded(child: searching ? _resultsView() : _libraryView()),
      ]),
    );
  }

  Widget _searchField() {
    return Container(
      color: QC.greenDark,
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          controller: _searchCtrl,
          onChanged: _onChanged,
          style: GoogleFonts.lora(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Tüm kutsal metinlerde ara (ör. aşk, merhamet, love)',
            hintStyle: GoogleFonts.lora(color: QC.greenPale, fontSize: 13.5),
            prefixIcon: const Icon(Icons.search_rounded, color: QC.goldLight),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, color: QC.greenPale),
                    onPressed: () {
                      _searchCtrl.clear();
                      _onChanged('');
                    })
                : null,
            filled: true,
            fillColor: QC.greenMain.withAlpha(120),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
          ),
        ),
      ]),
    );
  }

  // ── Kütüphane (arama yokken) ──
  Widget _libraryView() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
      children: [
        Text('Dünya dinlerinin kutsal metinleri',
            style: GoogleFonts.lora(
                fontSize: 17, fontWeight: FontWeight.w700, color: QC.greenDark)),
        const SizedBox(height: 4),
        Text(
            'Bir kelime aratıp tüm metinlerdeki yerleri tek listede görebilir, dokunup ilgili bölüme gidebilirsiniz.',
            style: GoogleFonts.lora(fontSize: 12.5, height: 1.4, color: QC.greenMid)),
        const SizedBox(height: 16),
        ...kSacredRegistry.map((e) => _TextCard(entry: e, onTap: () => _openText(e.id))),
      ],
    );
  }

  // ── Arama sonuçları ──
  Widget _resultsView() {
    if (_searching) {
      return const Center(child: CircularProgressIndicator(color: QC.greenMain));
    }
    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
              '"$_query" için sonuç bulunamadı.\nFarklı bir kelime deneyin (Türkçe veya İngilizce).',
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(color: QC.greenMid, height: 1.5)),
        ),
      );
    }
    // Metne göre grupla.
    final groups = <String, List<SacredHit>>{};
    for (final h in _results) {
      (groups[h.textId] ??= []).add(h);
    }
    final widgets = <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        child: Text('${_results.length} sonuç · ${groups.length} metin',
            style: GoogleFonts.lora(
                fontSize: 12.5, fontWeight: FontWeight.w600, color: QC.greenMid)),
      ),
    ];
    for (final id in kSacredRegistry.map((e) => e.id)) {
      final list = groups[id];
      if (list == null || list.isEmpty) continue;
      final first = list.first;
      widgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Row(children: [
          Container(width: 4, height: 18, color: QC.gold),
          const SizedBox(width: 8),
          Expanded(
            child: Text('${first.textName}  ·  ${first.religion}',
                style: GoogleFonts.lora(
                    fontSize: 15, fontWeight: FontWeight.w700, color: QC.greenDark)),
          ),
          Text('${list.length}',
              style: GoogleFonts.lora(
                  fontSize: 12.5, fontWeight: FontWeight.w700, color: QC.gold)),
        ]),
      ));
      for (final h in list) {
        widgets.add(_HitCard(hit: h, query: _query, onTap: () => _openHit(h)));
      }
    }
    return ListView(children: widgets);
  }
}

class _TextCard extends StatelessWidget {
  final SacredEntry entry;
  final VoidCallback onTap;
  const _TextCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: QC.greenPale.withAlpha(160))),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
                center: Alignment(-0.3, -0.4), colors: [QC.goldLight, QC.gold]),
          ),
          child: const Icon(Icons.menu_book_rounded, color: QC.greenDark, size: 24),
        ),
        title: Text(entry.name,
            style: GoogleFonts.lora(
                fontSize: 16, fontWeight: FontWeight.w700, color: QC.greenDark)),
        subtitle: Text(entry.religion,
            style: GoogleFonts.lora(fontSize: 12.5, color: QC.greenMid)),
        trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
        onTap: onTap,
      ),
    );
  }
}

class _HitCard extends StatelessWidget {
  final SacredHit hit;
  final String query;
  final VoidCallback onTap;
  const _HitCard({required this.hit, required this.query, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: QC.greenPale.withAlpha(140))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.place_rounded, size: 14, color: QC.gold),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(hit.ref,
                      style: GoogleFonts.lora(
                          fontSize: 13, fontWeight: FontWeight.w700, color: QC.greenMain)),
                ),
                const Icon(Icons.chevron_right_rounded, color: QC.gold, size: 20),
              ]),
              const SizedBox(height: 5),
              Text(
                hit.verse.length > 180 ? '${hit.verse.substring(0, 180)}…' : hit.verse,
                style: GoogleFonts.lora(fontSize: 14, height: 1.5, color: QC.greenDark),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
