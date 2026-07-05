// Arapça Sözlük — Türkçe↔Arapça, çift yön switch + yaklaşık (fuzzy) okunuş arama.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';
import 'sozluk_data.dart';

class SozlukScreen extends StatefulWidget {
  const SozlukScreen({super.key});
  @override
  State<SozlukScreen> createState() => _SozlukScreenState();
}

class _SozlukScreenState extends State<SozlukScreen> {
  String _q = '';
  bool _trToAr = true; // true: Türkçe→Arapça, false: Arapça→Türkçe

  // Türkçe-duyarsız + Arapça harekelerini eleyen sadeleştirme.
  static String _fold(String s) {
    final b = StringBuffer();
    for (var ch in s.toLowerCase().trim().split('')) {
      switch (ch) {
        case 'ı': case 'î': case 'İ': b.write('i'); break;
        case 'ş': b.write('s'); break;
        case 'ğ': b.write('g'); break;
        case 'ç': b.write('c'); break;
        case 'ü': case 'û': b.write('u'); break;
        case 'ö': b.write('o'); break;
        case 'â': b.write('a'); break;
        case '\'': case '`': case 'ʼ': case 'ʻ': break; // hemze/kesme atla
        default: b.write(ch);
      }
    }
    return b.toString();
  }

  // Basit Levenshtein (yaklaşık okunuş eşleşmesi için).
  static int _lev(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    final prev = List<int>.generate(b.length + 1, (i) => i);
    final cur = List<int>.filled(b.length + 1, 0);
    for (var i = 0; i < a.length; i++) {
      cur[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a[i] == b[j] ? 0 : 1;
        cur[j + 1] = [cur[j] + 1, prev[j + 1] + 1, prev[j] + cost]
            .reduce((x, y) => x < y ? x : y);
      }
      for (var k = 0; k <= b.length; k++) {
        prev[k] = cur[k];
      }
    }
    return prev[b.length];
  }

  // Kelimenin sorguya uyumu: 0 = uymaz, büyük = daha iyi.
  int _skor(SozlukKelime k, String q) {
    if (q.isEmpty) return 1;
    final fq = _fold(q);
    final ftr = _fold(k.turkce);
    final fok = _fold(k.okunus);
    // Arapça yazımdan doğrudan
    if (k.arabic.contains(q)) return 100;
    // Tam/başlangıç eşleşmeleri
    if (ftr == fq || fok == fq) return 95;
    if (ftr.startsWith(fq) || fok.startsWith(fq)) return 80;
    if (ftr.contains(fq) || fok.contains(fq)) return 60;
    // Yaklaşık (fuzzy) okunuş: kısa mesafe
    if (fq.length >= 3) {
      final d = _lev(fq, fok);
      if (d <= (fq.length <= 5 ? 1 : 2)) return 40 - d;
      // kelime içindeki tek kelimelerle de karşılaştır
      for (final part in fok.split(RegExp(r'[\s-]'))) {
        if (part.isNotEmpty && _lev(fq, part) <= 1) return 35;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final q = _q.trim();
    List<SozlukKelime> list;
    if (q.isEmpty) {
      list = List.of(kSozluk);
    } else {
      final scored = <MapEntry<SozlukKelime, int>>[];
      for (final k in kSozluk) {
        final s = _skor(k, q);
        if (s > 0) scored.add(MapEntry(k, s));
      }
      scored.sort((a, b) => b.value.compareTo(a.value));
      list = scored.map((e) => e.key).toList();
    }

    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Arapça Sözlük')),
      body: Column(children: [
        Container(
          color: QC.greenMain.withAlpha(24),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(children: [
            // Yön switch
            Row(children: [
              Expanded(child: _yonBtn('Türkçe → Arapça', _trToAr, () => setState(() => _trToAr = true))),
              const SizedBox(width: 8),
              Expanded(child: _yonBtn('Arapça → Türkçe', !_trToAr, () => setState(() => _trToAr = false))),
            ]),
            const SizedBox(height: 8),
            TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: _trToAr
                    ? 'Türkçe kelime ara (ör. su, sevgi)…'
                    : 'Arapça/okunuş ara (ör. mâ, حب, hub)…',
                prefixIcon: const Icon(Icons.translate_rounded, color: QC.greenMid),
                isDense: true,
                filled: true,
                fillColor: Color(0xFFFAF7F0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: QC.greenPale.withAlpha(160))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: QC.greenPale.withAlpha(160))),
              ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('${kSozluk.length} kelime · yaklaşık okunuş araması aktif',
                  style: GoogleFonts.lora(fontSize: 11.5, color: QC.greenMid)),
            ),
          ]),
        ),
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Text('Kelime bulunamadı',
                      style: GoogleFonts.lora(color: QC.greenMid)))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _kart(list[i]),
                ),
        ),
      ]),
    );
  }

  Widget _yonBtn(String label, bool aktif, VoidCallback onTap) {
    return Material(
      color: aktif ? QC.greenMain : Color(0xFFFAF7F0),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: QC.greenPale.withAlpha(160))),
          child: Text(label,
              style: GoogleFonts.lora(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: aktif ? Color(0xFFFAF7F0) : QC.greenDark)),
        ),
      ),
    );
  }

  Widget _kart(SozlukKelime k) {
    // Yöne göre birincil taraf.
    final solUst = _trToAr ? k.turkce : k.okunus;
    final solAlt = _trToAr ? k.okunus : k.turkce;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: QC.greenPale.withAlpha(150)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(solUst,
                style: GoogleFonts.lora(
                    fontSize: 15.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
            const SizedBox(height: 3),
            Text(solAlt,
                style: GoogleFonts.lora(
                    fontSize: 13, fontStyle: FontStyle.italic, color: QC.greenMain)),
          ]),
        ),
        const SizedBox(width: 10),
        Text(k.arabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
                fontFamily: QC.arabicFont, fontSize: 24, height: 1.8, color: QC.gold)),
      ]),
    );
  }
}
