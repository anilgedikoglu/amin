// Ezber bölümü — namaz/temel duaları oyunlaştırılmış + aralıklı tekrar (spaced
// repetition) ile ezberletir. Kelime gizleme seviyeleri + Bildim/Tekrar ile
// ustalık artar, sonraki tekrar tarihi otomatik planlanır.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../quran/quran_theme.dart';
import 'ezber_data.dart';

// Seviyeye göre sonraki tekrara kaç gün (aralıklı tekrar).
const List<int> _araGun = [0, 1, 2, 4, 8, 16];

class EzberPrefs {
  static int _today() => DateTime.now().millisecondsSinceEpoch ~/ 86400000;

  static int level(SharedPreferences p, String id) => p.getInt('ezber_lv_$id') ?? 0;
  static int nextReview(SharedPreferences p, String id) =>
      p.getInt('ezber_due_$id') ?? 0;

  static bool dueToday(SharedPreferences p, String id) =>
      nextReview(p, id) <= _today();

  static Future<void> record(String id, bool bildim) async {
    final p = await SharedPreferences.getInstance();
    var lv = level(p, id);
    lv = bildim ? (lv + 1).clamp(0, 5) : (lv - 1).clamp(0, 5);
    await p.setInt('ezber_lv_$id', lv);
    await p.setInt('ezber_due_$id', _today() + _araGun[lv]);
  }
}

class EzberScreen extends StatefulWidget {
  const EzberScreen({super.key});
  @override
  State<EzberScreen> createState() => _EzberScreenState();
}

class _EzberScreenState extends State<EzberScreen> {
  SharedPreferences? _p;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((v) {
      if (mounted) setState(() => _p = v);
    });
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final p = _p;
    final kategoriler = <String>[];
    for (final d in kEzberDualari) {
      if (!kategoriler.contains(d.kategori)) kategoriler.add(d.kategori);
    }
    final dueCount =
        p == null ? 0 : kEzberDualari.where((d) => EzberPrefs.dueToday(p, d.id)).length;
    final ustalik = p == null
        ? 0
        : kEzberDualari.fold<int>(0, (a, d) => a + EzberPrefs.level(p, d.id));
    final maxUstalik = kEzberDualari.length * 5;

    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Ezber')),
      body: p == null
          ? const Center(child: CircularProgressIndicator(color: QC.greenMain))
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _ozet(dueCount, ustalik, maxUstalik),
                if (dueCount > 0) ...[
                  const SizedBox(height: 14),
                  _tekrarButonu(dueCount),
                ],
                const SizedBox(height: 20),
                for (final kat in kategoriler) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
                    child: Row(children: [
                      Container(width: 4, height: 16, color: QC.gold),
                      const SizedBox(width: 8),
                      Text(kat,
                          style: GoogleFonts.lora(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: QC.greenDark)),
                    ]),
                  ),
                  ...kEzberDualari
                      .where((d) => d.kategori == kat)
                      .map((d) => _duaTile(p, d)),
                ],
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _ozet(int due, int ustalik, int max) {
    final pct = max == 0 ? 0.0 : ustalik / max;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [QC.greenMain, QC.greenDark]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Ezber Ustalığı',
            style: GoogleFonts.lora(
                fontSize: 16, fontWeight: FontWeight.w700, color: QC.goldLight)),
        const SizedBox(height: 4),
        Text('${kEzberDualari.length} dua · bugün tekrar: $due',
            style: GoogleFonts.lora(fontSize: 12, color: QC.greenPale)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: Colors.black.withAlpha(60),
            valueColor: const AlwaysStoppedAnimation(QC.gold),
          ),
        ),
        const SizedBox(height: 6),
        Text('%${(pct * 100).round()} ustalık',
            style: GoogleFonts.lora(fontSize: 11, color: QC.greenPale)),
      ]),
    );
  }

  Widget _tekrarButonu(int due) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final list = kEzberDualari.where((d) => EzberPrefs.dueToday(_p!, d.id)).toList();
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EzberPracticeScreen(dualar: list)));
          if (mounted) {
            _p = await SharedPreferences.getInstance();
            _refresh();
          }
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [QC.gold, QC.goldLight]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(children: [
            const Icon(Icons.play_circle_fill_rounded, color: QC.greenDark),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Bugünün tekrarına başla ($due)',
                  style: GoogleFonts.lora(
                      fontSize: 14.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
            ),
            const Icon(Icons.chevron_right_rounded, color: QC.greenDark),
          ]),
        ),
      ),
    );
  }

  Widget _duaTile(SharedPreferences p, EzberDua d) {
    final lv = EzberPrefs.level(p, d.id);
    final due = EzberPrefs.dueToday(p, d.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: QC.greenPale.withAlpha(150)),
      ),
      child: ListTile(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => EzberPracticeScreen(dualar: [d])));
          if (mounted) {
            _p = await SharedPreferences.getInstance();
            _refresh();
          }
        },
        title: Text(d.ad,
            style: GoogleFonts.lora(
                fontSize: 14.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
        subtitle: Row(children: [
          for (var i = 0; i < 5; i++)
            Icon(i < lv ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 15, color: i < lv ? QC.gold : QC.greenPale),
          const SizedBox(width: 8),
          if (due)
            Text('tekrar zamanı',
                style: GoogleFonts.lora(
                    fontSize: 10.5, color: QC.gold, fontWeight: FontWeight.w700)),
        ]),
        trailing: Icon(lv >= 5 ? Icons.verified_rounded : Icons.chevron_right_rounded,
            color: lv >= 5 ? QC.greenMid : QC.gold),
      ),
    );
  }
}

// ── Pratik (oyunlaştırılmış kelime gizleme) ──
class EzberPracticeScreen extends StatefulWidget {
  final List<EzberDua> dualar;
  const EzberPracticeScreen({super.key, required this.dualar});
  @override
  State<EzberPracticeScreen> createState() => _EzberPracticeScreenState();
}

class _EzberPracticeScreenState extends State<EzberPracticeScreen> {
  int _i = 0;
  int _level = 0;
  bool _started = false; // "Ezbere Başla" basıldı mı
  int _revealed = 0; // açılan kelime sayısı

  @override
  void initState() {
    super.initState();
    _loadLevel();
  }

  Future<void> _loadLevel() async {
    final p = await SharedPreferences.getInstance();
    if (mounted) setState(() => _level = EzberPrefs.level(p, widget.dualar[_i].id));
  }

  Future<void> _rate(bool bildim) async {
    await EzberPrefs.record(widget.dualar[_i].id, bildim);
    if (_i + 1 >= widget.dualar.length) {
      if (mounted) Navigator.pop(context);
      return;
    }
    setState(() {
      _i++;
      _started = false;
      _revealed = 0;
    });
    _loadLevel();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.dualar[_i];
    final words = d.latin.split(RegExp(r'\s+'));
    final total = words.length;
    final allRevealed = _started && _revealed >= total;

    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        title: Text(d.ad),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: (_i + 1) / widget.dualar.length,
            minHeight: 3,
            backgroundColor: QC.greenDark,
            valueColor: const AlwaysStoppedAnimation(QC.gold),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Text('Seviye ', style: GoogleFonts.lora(fontSize: 12, color: QC.greenMid)),
            for (var i = 0; i < 5; i++)
              Icon(i < _level ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 16, color: i < _level ? QC.gold : QC.greenPale),
            const Spacer(),
            Text('${_i + 1}/${widget.dualar.length}',
                style: GoogleFonts.lora(fontSize: 12, color: QC.greenMid)),
          ]),
          const SizedBox(height: 14),
          // Arapça (her zaman görünür — yardımcı)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: QC.greenMain.withAlpha(22),
                borderRadius: BorderRadius.circular(14)),
            child: Text(d.arabic,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    fontFamily: QC.arabicFont,
                    fontSize: 22,
                    height: 1.9,
                    color: QC.greenDark)),
          ),
          const SizedBox(height: 16),
          Text(
              !_started
                  ? 'Okunuş — önce tamamını oku ve ezberle'
                  : (allRevealed
                      ? 'Okunuş — tamamı açıldı'
                      : 'Okunuş — $_revealed / $total kelime açık'),
              style: GoogleFonts.lora(
                  fontSize: 12, fontWeight: FontWeight.w700, color: QC.gold)),
          const SizedBox(height: 8),
          if (!_started)
            // Öğrenme aşaması: tam metin görünür
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: QC.greenPale.withAlpha(160))),
              child: Text(d.latin,
                  style: GoogleFonts.lora(fontSize: 16, height: 1.7, color: QC.greenDark)),
            )
          else
            // Ezber aşaması: kelimeler tek tek açılır
            Wrap(
              spacing: 6,
              runSpacing: 8,
              children: [
                for (var w = 0; w < words.length; w++)
                  _wordChip(words[w], w >= _revealed),
              ],
            ),
          const SizedBox(height: 18),
          // Türkçe anlam (yardımcı)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: QC.greenPale.withAlpha(150))),
            child: Text(d.turkish,
                style: GoogleFonts.lora(
                    fontSize: 13.5, height: 1.5, color: QC.greenDark)),
          ),
          const SizedBox(height: 24),
          if (!_started)
            _btn('Ezbere Başla', QC.greenMain,
                () => setState(() {
                      _started = true;
                      _revealed = 1;
                    }),
                icon: Icons.play_arrow_rounded)
          else if (!allRevealed)
            Row(children: [
              Expanded(
                child: _btn('Devam — sonraki kelime', QC.gold,
                    () => setState(() => _revealed = (_revealed + 1).clamp(0, total)),
                    icon: Icons.arrow_forward_rounded, dark: true),
              ),
              const SizedBox(width: 10),
              _iconBtn(Icons.restart_alt_rounded, () => setState(() => _revealed = 1)),
            ])
          else
            Row(children: [
              Expanded(
                  child: _btn('Tekrar gerek', QC.brownDark, () => _rate(false),
                      icon: Icons.refresh_rounded)),
              const SizedBox(width: 12),
              Expanded(
                  child: _btn('Bildim', QC.greenMain, () => _rate(true),
                      icon: Icons.check_rounded)),
            ]),
          const SizedBox(height: 10),
          Text(
              !_started
                  ? 'Hazır olunca "Ezbere Başla"ya bas — kelimeler tek tek açılır.'
                  : (allRevealed
                      ? 'Bildim → seviye artar, tekrar aralığı uzar. Tekrar gerek → yakında yine sorulur.'
                      : 'Her "Devam"da bir kelime daha açılır; sıradakini hatırlamaya çalış.'),
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(fontSize: 10.5, color: QC.greenMid)),
        ],
      ),
    );
  }

  Widget _wordChip(String word, bool hidden) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: hidden ? QC.gold.withAlpha(30) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: hidden ? QC.gold.withAlpha(140) : QC.greenPale.withAlpha(160)),
      ),
      child: Text(
        hidden ? '·' * word.replaceAll(RegExp(r'[^A-Za-zçğıöşüÇĞİÖŞÜ]'), '').length.clamp(2, 12) : word,
        style: GoogleFonts.lora(
            fontSize: 14.5,
            height: 1.3,
            color: hidden ? QC.gold : QC.greenDark,
            fontWeight: hidden ? FontWeight.w800 : FontWeight.w500),
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback onTap,
      {IconData? icon, bool dark = false}) {
    final fg = dark ? QC.greenDark : Colors.white;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) ...[Icon(icon, color: fg, size: 19), const SizedBox(width: 7)],
            Text(label,
                style: GoogleFonts.lora(
                    fontSize: 14.5, fontWeight: FontWeight.w700, color: fg)),
          ]),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: QC.greenMain.withAlpha(30),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: QC.greenMain, size: 20),
        ),
      ),
    );
  }
}
