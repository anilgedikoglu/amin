// Hadis & Özlü Sözler — büyük hadis kaynaklarına (Buhârî, Müslim, Tirmizî…)
// göre başlıklara ayrılmış; koleksiyon filtresi + arama.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';
import 'sozler_repository.dart';

const _kSozFilter = '__soz__';

class SozlerScreen extends StatefulWidget {
  const SozlerScreen({super.key});
  @override
  State<SozlerScreen> createState() => _SozlerScreenState();
}

class _SozlerScreenState extends State<SozlerScreen> {
  final _repo = SozlerRepository.instance;
  bool _ready = false;
  String _filter = ''; // '' = Tümü, kaynak adı, veya _kSozFilter
  String _q = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _repo.ensureLoaded();
    if (mounted) setState(() => _ready = true);
  }

  String _norm(String s) {
    s = s.toLowerCase();
    const m = {'â': 'a', 'î': 'i', 'û': 'u', 'ç': 'c', 'ğ': 'g', 'ı': 'i', 'ö': 'o', 'ş': 's', 'ü': 'u'};
    final b = StringBuffer();
    for (final c in s.split('')) {
      b.write(m[c] ?? c);
    }
    return b.toString();
  }

  bool _matchesQuery(Soz s) =>
      _q.isEmpty || _norm(s.metin).contains(_norm(_q)) || _norm(s.kaynak).contains(_norm(_q));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Hadis & Sözler", style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
          Text(_ready ? "${_repo.all.where((s) => s.isHadis).length} hadis · büyük kaynaklara göre"
                      : "…",
              style: const TextStyle(fontSize: 10, color: QC.greenPale)),
        ]),
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator(color: QC.greenMain))
          : Column(children: [
              _searchAndChips(),
              Expanded(child: _list()),
            ]),
    );
  }

  Widget _searchAndChips() {
    // Koleksiyon sayıları
    final hadisler = _repo.all.where((s) => s.isHadis).toList();
    final counts = <String, int>{};
    for (final h in hadisler) {
      final k = hadisKaynagi(h.kaynak);
      counts[k] = (counts[k] ?? 0) + 1;
    }
    final sozCount = _repo.all.where((s) => !s.isHadis).length;

    final chips = <Widget>[
      _chip("Tümü", '', _repo.all.length),
      for (final k in kHadisKaynaklari)
        if ((counts[k] ?? 0) > 0) _chip(k, k, counts[k]!),
      _chip("Özlü Sözler", _kSozFilter, sozCount),
    ];

    return Container(
      color: QC.greenDark,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Column(children: [
        TextField(
          onChanged: (v) => setState(() => _q = v),
          style: const TextStyle(color: Color(0xFFFAF7F0), fontSize: 14),
          cursorColor: QC.goldLight,
          decoration: InputDecoration(
            hintText: "Hadis veya söz ara…",
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
            prefixIcon: const Icon(Icons.search, color: QC.greenPale, size: 20),
            filled: true, fillColor: Color(0xFFFAF7F0).withAlpha(22),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: QC.gold.withAlpha(90))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: QC.gold)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 34,
          child: ListView(scrollDirection: Axis.horizontal, children: chips),
        ),
      ]),
    );
  }

  Widget _chip(String label, String value, int count) {
    final active = _filter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filter = value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            color: active ? QC.gold : Color(0xFFFAF7F0).withAlpha(22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: QC.gold.withAlpha(active ? 255 : 90)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12.5, fontWeight: FontWeight.w600,
                    color: active ? QC.greenDark : QC.goldLight)),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                  color: active ? QC.greenDark.withAlpha(40) : Colors.black.withAlpha(40),
                  borderRadius: BorderRadius.circular(10)),
              child: Text('$count',
                  style: TextStyle(
                      fontSize: 10.5, fontWeight: FontWeight.w700,
                      color: active ? QC.greenDark : QC.greenPale)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _list() {
    // Özlü Sözler filtresi
    if (_filter == _kSozFilter) {
      final list = _repo.all.where((s) => !s.isHadis && _matchesQuery(s)).toList();
      return _flatList(list);
    }
    // Belirli koleksiyon filtresi
    if (_filter.isNotEmpty) {
      final list = _repo.all
          .where((s) => s.isHadis && hadisKaynagi(s.kaynak) == _filter && _matchesQuery(s))
          .toList();
      return _flatList(list, header: _filter);
    }
    // Tümü → koleksiyona göre gruplu
    final children = <Widget>[];
    for (final k in kHadisKaynaklari) {
      final group = _repo.all
          .where((s) => s.isHadis && hadisKaynagi(s.kaynak) == k && _matchesQuery(s))
          .toList();
      if (group.isEmpty) continue;
      children.add(_sectionHeader(k, group.length));
      children.addAll(group.map((s) => _SozCard(soz: s)));
    }
    final sozler = _repo.all.where((s) => !s.isHadis && _matchesQuery(s)).toList();
    if (sozler.isNotEmpty) {
      children.add(_sectionHeader("Özlü Sözler", sozler.length));
      children.addAll(sozler.map((s) => _SozCard(soz: s)));
    }
    if (children.isEmpty) return _empty();
    return ListView(padding: const EdgeInsets.fromLTRB(14, 14, 14, 24), children: children);
  }

  Widget _flatList(List<Soz> list, {String? header}) {
    if (list.isEmpty) return _empty();
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        if (header != null) _sectionHeader(header, list.length),
        ...list.map((s) => _SozCard(soz: s)),
      ],
    );
  }

  Widget _empty() => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text("Sonuç bulunamadı.", style: TextStyle(color: QC.greenMain, fontSize: 14)),
        ),
      );

  Widget _sectionHeader(String text, int count) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 6, 2, 10),
        child: Row(children: [
          Container(width: 4, height: 20,
              decoration: BoxDecoration(color: QC.gold, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Text(text,
              style: GoogleFonts.lora(
                  fontSize: 16, fontWeight: FontWeight.w700, color: QC.greenDark)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: QC.greenMain, borderRadius: BorderRadius.circular(10)),
            child: Text('$count',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: QC.goldLight)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: QC.gold.withAlpha(70))),
        ]),
      );
}

class _SozCard extends StatelessWidget {
  final Soz soz;
  const _SozCard({required this.soz});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QC.greenPale, width: 1.2),
        boxShadow: [BoxShadow(color: QC.greenMain.withAlpha(16), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
                color: soz.isHadis ? QC.greenMain : QC.gold,
                borderRadius: BorderRadius.circular(7)),
            child: Text(soz.isHadis ? "HADİS" : "ÖZLÜ SÖZ",
                style: TextStyle(
                    fontSize: 9.5, letterSpacing: 1, fontWeight: FontWeight.w700,
                    color: soz.isHadis ? QC.goldLight : QC.greenDark)),
          ),
          const Spacer(),
          const Icon(Icons.format_quote_rounded, color: QC.greenPale, size: 22),
        ]),
        const SizedBox(height: 10),
        Text(soz.metin,
            style: GoogleFonts.lora(fontSize: 15, height: 1.7, color: QC.greenDark)),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Text("— ${soz.kaynak}",
              style: const TextStyle(
                  fontSize: 12, color: QC.greenMid, fontStyle: FontStyle.italic)),
        ),
      ]),
    );
  }
}
