// Arapça Okuma (Elifba) — sıfırdan Arapça okumayı öğreten dersler.
// Harfler → harekeler → med/şedde/tenvin → kelimeler → ibareler. Türkçe anlamlı.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';

class _Oge {
  final String ar; // Arapça
  final String oku; // okunuşu / adı
  final String? anlam; // Türkçe anlam (kelimeler için)
  const _Oge(this.ar, this.oku, [this.anlam]);
}

class _Ders {
  final String baslik, aciklama;
  final int sutun; // grid sütun sayısı
  final List<_Oge> ogeler;
  const _Ders(this.baslik, this.aciklama, this.sutun, this.ogeler);
}

const List<_Ders> _dersler = [
  _Ders('1. Ders — Harfler', 'Arap alfabesindeki 28 harf ve isimleri. Her harfi sesli sesli tekrarla.', 4, [
    _Oge('ا', 'elif'), _Oge('ب', 'be'), _Oge('ت', 'te'), _Oge('ث', 'se'),
    _Oge('ج', 'cim'), _Oge('ح', 'ha'), _Oge('خ', 'hı'), _Oge('د', 'dal'),
    _Oge('ذ', 'zel'), _Oge('ر', 'ra'), _Oge('ز', 'ze'), _Oge('س', 'sin'),
    _Oge('ش', 'şın'), _Oge('ص', 'sad'), _Oge('ض', 'dad'), _Oge('ط', 'tı'),
    _Oge('ظ', 'zı'), _Oge('ع', 'ayn'), _Oge('غ', 'gayn'), _Oge('ف', 'fe'),
    _Oge('ق', 'kaf'), _Oge('ك', 'kef'), _Oge('ل', 'lam'), _Oge('م', 'mim'),
    _Oge('ن', 'nun'), _Oge('و', 'vav'), _Oge('ه', 'he'), _Oge('ي', 'ye'),
  ]),
  _Ders('2. Ders — Harflerin Yazılışı', 'Harfler kelime içinde başta, ortada ve sonda farklı yazılır. Örnekler:', 3, [
    _Oge('بـ', 'be (başta)'), _Oge('ـبـ', 'be (ortada)'), _Oge('ـب', 'be (sonda)'),
    _Oge('عـ', 'ayn (başta)'), _Oge('ـعـ', 'ayn (ortada)'), _Oge('ـع', 'ayn (sonda)'),
    _Oge('كـ', 'kef (başta)'), _Oge('ـكـ', 'kef (ortada)'), _Oge('ـك', 'kef (sonda)'),
  ]),
  _Ders('3. Ders — Üstün (Fetha)', 'Harfin üstündeki eğik çizgi "e/a" sesi verir. Üstünlü harfi oku:', 4, [
    _Oge('بَ', 'be'), _Oge('تَ', 'te'), _Oge('جَ', 'ce'), _Oge('دَ', 'de'),
    _Oge('رَ', 'ra'), _Oge('سَ', 'se'), _Oge('كَ', 'ke'), _Oge('لَ', 'le'),
    _Oge('مَ', 'me'), _Oge('نَ', 'ne'), _Oge('وَ', 've'), _Oge('يَ', 'ye'),
  ]),
  _Ders('4. Ders — Esre (Kesre)', 'Harfin altındaki eğik çizgi "i" sesi verir. Esreli harfi oku:', 4, [
    _Oge('بِ', 'bi'), _Oge('تِ', 'ti'), _Oge('جِ', 'ci'), _Oge('دِ', 'di'),
    _Oge('رِ', 'ri'), _Oge('سِ', 'si'), _Oge('كِ', 'ki'), _Oge('لِ', 'li'),
    _Oge('مِ', 'mi'), _Oge('نِ', 'ni'), _Oge('وِ', 'vi'), _Oge('يِ', 'yi'),
  ]),
  _Ders('5. Ders — Ötre (Damme)', 'Harfin üstündeki küçük "vav" işareti "u/ü" sesi verir. Ötreli harfi oku:', 4, [
    _Oge('بُ', 'bu'), _Oge('تُ', 'tu'), _Oge('جُ', 'cu'), _Oge('دُ', 'du'),
    _Oge('رُ', 'ru'), _Oge('سُ', 'su'), _Oge('كُ', 'ku'), _Oge('لُ', 'lu'),
    _Oge('مُ', 'mu'), _Oge('نُ', 'nu'), _Oge('وُ', 'vu'), _Oge('يُ', 'yu'),
  ]),
  _Ders('6. Ders — Cezm (Sükûn)', 'Harfin üstündeki küçük daire harfin sessiz (harekesiz) okunacağını gösterir:', 3, [
    _Oge('اَبْ', 'eb', 'baba'), _Oge('مَنْ', 'men', 'kim'), _Oge('قُلْ', 'kul', 'de/söyle'),
    _Oge('هَلْ', 'hel', 'mı?'), _Oge('كَمْ', 'kem', 'kaç'), _Oge('نَمْ', 'nem', 'uyu'),
  ]),
  _Ders('7. Ders — Şedde', 'Harfin üstündeki "w" benzeri işaret, o harfin iki kez (kalın) okunacağını gösterir:', 3, [
    _Oge('رَبّ', 'rabb', 'Rab'), _Oge('حَقّ', 'hakk', 'gerçek'), _Oge('اُمّ', 'ümm', 'anne'),
    _Oge('حُبّ', 'hubb', 'sevgi'), _Oge('سِرّ', 'sırr', 'sır'), _Oge('عِزّ', 'izz', 'şeref'),
  ]),
  _Ders('8. Ders — Tenvin', 'Harekenin iki kez yazılması sona "n" sesi ekler: en, in, un.', 3, [
    _Oge('اً', 'en'), _Oge('اٍ', 'in'), _Oge('اٌ', 'un'),
    _Oge('كِتَابًا', 'kitâben', 'bir kitap'), _Oge('عِلْمًا', 'ilmen', 'bir ilim'), _Oge('نُورًا', 'nûran', 'bir nur'),
  ]),
  _Ders('9. Ders — Uzatma (Med)', 'Elif, vav ve ye harfleri sesi uzatır: â, û, î.', 3, [
    _Oge('بَا', 'bâ'), _Oge('بُو', 'bû'), _Oge('بِي', 'bî'),
    _Oge('قَالَ', 'kâle', 'dedi'), _Oge('يَقُولُ', 'yekûlü', 'der/söyler'), _Oge('قِيلَ', 'kîle', 'denildi'),
  ]),
  _Ders('10. Ders — Kelimeler', 'Öğrendiğin harf ve harekelerle basit kelimeleri oku ve anlamını öğren:', 2, [
    _Oge('يَد', 'yed', 'el'), _Oge('دَم', 'dem', 'kan'),
    _Oge('نَار', 'nâr', 'ateş'), _Oge('مَاء', 'mâ', 'su'),
    _Oge('نُور', 'nûr', 'ışık, nur'), _Oge('عِلْم', 'ilm', 'ilim, bilgi'),
    _Oge('قَلَم', 'kalem', 'kalem'), _Oge('كِتَاب', 'kitâb', 'kitap'),
    _Oge('بَيْت', 'beyt', 'ev'), _Oge('يَوْم', 'yevm', 'gün'),
    _Oge('قَمَر', 'kamer', 'ay'), _Oge('شَمْس', 'şems', 'güneş'),
  ]),
  _Ders('11. Ders — İbareler', 'Artık uzun ibareleri okuyabilirsin. Sık kullanılan mübarek sözler:', 1, [
    _Oge('بِسْمِ اللّٰهِ', 'bismillâh', 'Allah\'ın adıyla'),
    _Oge('اَلْحَمْدُ لِلّٰهِ', 'elhamdülillâh', 'Hamd Allah\'a mahsustur'),
    _Oge('سُبْحَانَ اللّٰهِ', 'sübhânallâh', 'Allah\'ı tesbih ederim'),
    _Oge('اَللّٰهُ اَكْبَرُ', 'Allâhü ekber', 'Allah en büyüktür'),
    _Oge('لَا إِلٰهَ إِلَّا اللّٰهُ', 'lâ ilâhe illallâh', 'Allah\'tan başka ilah yoktur'),
    _Oge('اَسْتَغْفِرُ اللّٰهَ', 'estağfirullâh', 'Allah\'tan bağışlanma dilerim'),
  ]),
];

class ElifbaScreen extends StatelessWidget {
  const ElifbaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Arapça Okuma · Elifba')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Text('Sıfırdan Arapça okumayı öğren. Dersleri sırayla çalış; her derste harfleri sesli tekrarla.',
              style: GoogleFonts.lora(fontSize: 12.5, height: 1.45, color: QC.greenMid)),
          const SizedBox(height: 14),
          ..._dersler.asMap().entries.map((e) => _dersTile(context, e.key)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _dersTile(BuildContext context, int i) {
    final d = _dersler[i];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QC.greenPale.withAlpha(160)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  center: Alignment(-0.3, -0.4), colors: [QC.goldLight, QC.gold])),
          child: Center(
              child: Text('${i + 1}',
                  style: GoogleFonts.lora(
                      fontSize: 17, fontWeight: FontWeight.w800, color: QC.greenDark))),
        ),
        title: Text(d.baslik,
            style: GoogleFonts.lora(
                fontSize: 14.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
        subtitle: Text('${d.ogeler.length} öğe',
            style: GoogleFonts.lora(fontSize: 11.5, color: QC.greenMid)),
        trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => ElifbaDersScreen(index: i))),
      ),
    );
  }
}

class ElifbaDersScreen extends StatefulWidget {
  final int index;
  const ElifbaDersScreen({super.key, required this.index});
  @override
  State<ElifbaDersScreen> createState() => _ElifbaDersScreenState();
}

class _ElifbaDersScreenState extends State<ElifbaDersScreen> {
  late int _i = widget.index;

  @override
  Widget build(BuildContext context) {
    final d = _dersler[_i];
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: Text('Ders ${_i + 1}/${_dersler.length}')),
      body: Column(children: [
        Container(
          width: double.infinity,
          color: QC.greenMain.withAlpha(26),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.baslik,
                style: GoogleFonts.lora(
                    fontSize: 16, fontWeight: FontWeight.w800, color: QC.greenDark)),
            const SizedBox(height: 4),
            Text(d.aciklama,
                style: GoogleFonts.lora(fontSize: 12.5, height: 1.45, color: QC.greenMid)),
          ]),
        ),
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.all(14),
            crossAxisCount: d.sutun,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: d.sutun >= 4
                ? 0.82
                : d.sutun == 3
                    ? 1.0
                    : (d.sutun == 2 ? 1.7 : 3.4),
            children: d.ogeler.map(_ogeCard).toList(),
          ),
        ),
        _navBar(),
      ]),
    );
  }

  Widget _ogeCard(_Oge o) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QC.greenPale.withAlpha(160)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(
          child: FittedBox(
            child: Text(o.ar,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    fontFamily: 'AmiriQuran', fontSize: 34, color: QC.greenDark)),
          ),
        ),
        const SizedBox(height: 6),
        Text(o.oku,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
                fontSize: 13.5, fontWeight: FontWeight.w700, color: QC.greenMain)),
        if (o.anlam != null) ...[
          const SizedBox(height: 2),
          Text(o.anlam!,
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(fontSize: 11.5, color: QC.greenMid)),
        ],
      ]),
    );
  }

  Widget _navBar() {
    final hasPrev = _i > 0;
    final hasNext = _i < _dersler.length - 1;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
        child: Row(children: [
          if (hasPrev)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _i--),
                icon: const Icon(Icons.chevron_left_rounded),
                label: const Text('Önceki ders'),
              ),
            ),
          if (hasPrev && hasNext) const SizedBox(width: 12),
          if (hasNext)
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: QC.greenMain, foregroundColor: Colors.white),
                onPressed: () => setState(() => _i++),
                icon: const Icon(Icons.chevron_right_rounded),
                label: const Text('Sonraki ders'),
              ),
            ),
        ]),
      ),
    );
  }
}
