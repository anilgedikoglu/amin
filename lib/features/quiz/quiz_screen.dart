// Bilgi Yarışması — 10 soruluk turlar (3 kolay + 3 orta + 4 çok zor).
// 10 sn geri sayım; süre biterse yanlış sayılır, doğru gösterilir, 3 sn sonra
// sonraki soru. Tur sonunda X/10 + istatistikler.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart' show AdManager;
import '../quran/quran_theme.dart';
import 'quiz_data.dart';

class QuizStats {
  final int played, totalQ, correct, perfect;
  const QuizStats(this.played, this.totalQ, this.correct, this.perfect);

  static Future<QuizStats> load() async {
    final p = await SharedPreferences.getInstance();
    return QuizStats(
      p.getInt('quiz_played') ?? 0,
      p.getInt('quiz_total_q') ?? 0,
      p.getInt('quiz_correct') ?? 0,
      p.getInt('quiz_perfect') ?? 0,
    );
  }

  static Future<void> record(int correctInRound, int totalInRound) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('quiz_played', (p.getInt('quiz_played') ?? 0) + 1);
    await p.setInt('quiz_total_q', (p.getInt('quiz_total_q') ?? 0) + totalInRound);
    await p.setInt('quiz_correct', (p.getInt('quiz_correct') ?? 0) + correctInRound);
    if (correctInRound == totalInRound) {
      await p.setInt('quiz_perfect', (p.getInt('quiz_perfect') ?? 0) + 1);
    }
  }
}

// Tur için soru seç: 3 kolay + 3 orta + 4 çok zor, rastgele, zorluk sırasıyla.
List<QuizQ> _pickRound() {
  final easy = kQuizBank.where((q) => q.zorluk == 0).toList()..shuffle();
  final med = kQuizBank.where((q) => q.zorluk == 1).toList()..shuffle();
  final hard = kQuizBank.where((q) => q.zorluk == 2).toList()..shuffle();
  return [
    ...easy.take(3),
    ...med.take(3),
    ...hard.take(4),
  ];
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuizStats? _stats;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    final s = await QuizStats.load();
    if (mounted) setState(() => _stats = s);
  }

  @override
  Widget build(BuildContext context) {
    final s = _stats;
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Bilgi Yarışması')),
      body: s == null
          ? const Center(child: CircularProgressIndicator(color: QC.greenMain))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [QC.greenMain, QC.greenDark]),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: QC.gold.withAlpha(120), width: 1.3),
                  ),
                  child: Column(children: [
                    const Icon(Icons.emoji_events_rounded, color: QC.goldLight, size: 44),
                    const SizedBox(height: 10),
                    Text('Dinî Bilgi Yarışması',
                        style: GoogleFonts.lora(
                            fontSize: 19, fontWeight: FontWeight.w700, color: Color(0xFFFAF7F0))),
                    const SizedBox(height: 6),
                    Text('10 soru · her soru için 10 saniye',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lora(fontSize: 12.5, height: 1.5, color: QC.greenPale)),
                  ]),
                ),
                const SizedBox(height: 18),
                Material(
                  color: QC.gold,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => QuizGameScreen(sorular: _pickRound())));
                      _reload();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.play_arrow_rounded, color: QC.greenDark),
                        const SizedBox(width: 8),
                        Text('Yarışmaya Başla',
                            style: GoogleFonts.lora(
                                fontSize: 16, fontWeight: FontWeight.w700, color: QC.greenDark)),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text('İSTATİSTİKLER',
                    style: GoogleFonts.lora(
                        fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w700, color: QC.gold)),
                const SizedBox(height: 10),
                _statRow('Kaç kez oynandı', '${s.played}'),
                _statRow('Toplam soru', '${s.totalQ}'),
                _statRow('Toplam doğru', '${s.correct}'),
                _statRow('Başarı oranı',
                    s.totalQ == 0 ? '—' : '%${(s.correct * 100 / s.totalQ).round()}'),
                _statRow('10/10 yapılan tur', '${s.perfect}'),
              ],
            ),
    );
  }

  Widget _statRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: QC.greenPale.withAlpha(150)),
      ),
      child: Row(children: [
        Expanded(
            child: Text(label,
                style: GoogleFonts.lora(fontSize: 14, color: QC.greenDark))),
        Text(value,
            style: GoogleFonts.lora(
                fontSize: 16, fontWeight: FontWeight.w700, color: QC.greenMain)),
      ]),
    );
  }
}

// ── Oyun ekranı ──
class QuizGameScreen extends StatefulWidget {
  final List<QuizQ> sorular;
  const QuizGameScreen({super.key, required this.sorular});
  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  static const int _saniye = 10;
  int _i = 0;
  int _dogruSayisi = 0;
  int? _secilen; // kullanıcının seçtiği şık (null = henüz)
  bool _kilitli = false; // cevap verildi/süre bitti
  bool _bitti = false;
  Timer? _timer;
  double _kalan = _saniye.toDouble();

  @override
  void initState() {
    super.initState();
    // Yarışma sırasında tıklamalar sayılmasın (reklam/pop-up çıkmasın).
    AdManager.instance.pauseTaps = true;
    _baslatTimer();
  }

  void _baslatTimer() {
    _timer?.cancel();
    _kalan = _saniye.toDouble();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (!mounted) return;
      setState(() => _kalan -= 0.1);
      if (_kalan <= 0) {
        t.cancel();
        _sureBitti();
      }
    });
  }

  void _sureBitti() {
    if (_kilitli) return;
    setState(() {
      _kilitli = true;
      _secilen = null; // seçmedi → yanlış
    });
    // Süre bitince doğru gösterilir, 3 sn beklenir.
    Future.delayed(const Duration(seconds: 3), _sonraki);
  }

  void _cevapla(int index) {
    if (_kilitli) return;
    _timer?.cancel();
    final dogru = index == widget.sorular[_i].dogru;
    setState(() {
      _secilen = index;
      _kilitli = true;
      if (dogru) _dogruSayisi++;
    });
    Future.delayed(Duration(seconds: dogru ? 1 : 3), _sonraki);
  }

  void _sonraki() {
    if (!mounted) return;
    if (_i + 1 >= widget.sorular.length) {
      _timer?.cancel();
      QuizStats.record(_dogruSayisi, widget.sorular.length);
      setState(() => _bitti = true);
      return;
    }
    setState(() {
      _i++;
      _secilen = null;
      _kilitli = false;
    });
    _baslatTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    AdManager.instance.pauseTaps = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bitti) return _sonucEkrani();
    final q = widget.sorular[_i];
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        title: Text('Soru ${_i + 1} / ${widget.sorular.length}'),
        automaticallyImplyLeading: false,
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Text('Doğru: $_dogruSayisi',
                style: GoogleFonts.lora(fontSize: 13, color: QC.goldLight)),
          )),
        ],
      ),
      body: Column(children: [
        // Geri sayım çubuğu (üstte)
        LinearProgressIndicator(
          value: (_kalan / _saniye).clamp(0.0, 1.0),
          minHeight: 6,
          backgroundColor: QC.greenPale.withAlpha(120),
          valueColor: AlwaysStoppedAnimation(
              _kalan < 3 ? const Color(0xFFD32F2F) : QC.gold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Icon(Icons.timer_outlined,
                size: 18, color: _kalan < 3 ? const Color(0xFFD32F2F) : QC.greenMid),
            const SizedBox(width: 4),
            Text('${_kalan.clamp(0, 10).ceil()} sn',
                style: GoogleFonts.lora(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _kalan < 3 ? const Color(0xFFD32F2F) : QC.greenMid)),
          ]),
        ),
        // Soru + şıklar dikeyde ortalı (gerekirse kaydırılır).
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFAF7F0),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: QC.greenPale.withAlpha(160)),
                    ),
                    child: Text(q.soru,
                        style: GoogleFonts.lora(
                            fontSize: 17, height: 1.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
                  ),
                  const SizedBox(height: 16),
                  for (var s = 0; s < q.secenekler.length; s++) _secenek(q, s),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _secenek(QuizQ q, int index) {
    Color bg = Color(0xFFFAF7F0);
    Color border = QC.greenPale.withAlpha(160);
    Color fg = QC.greenDark;
    IconData? ikon;
    if (_kilitli) {
      if (index == q.dogru) {
        bg = QC.greenMain.withAlpha(40);
        border = QC.greenMain;
        fg = QC.greenDark;
        ikon = Icons.check_circle_rounded;
      } else if (index == _secilen) {
        bg = const Color(0xFFD32F2F).withAlpha(30);
        border = const Color(0xFFD32F2F);
        ikon = Icons.cancel_rounded;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _kilitli ? null : () => _cevapla(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border, width: 1.4)),
            child: Row(children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: QC.greenPale.withAlpha(90),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(String.fromCharCode(65 + index),
                    style: GoogleFonts.lora(
                        fontSize: 13, fontWeight: FontWeight.w700, color: QC.greenDark)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(q.secenekler[index],
                    style: GoogleFonts.lora(fontSize: 14.5, height: 1.4, color: fg)),
              ),
              if (ikon != null)
                Icon(ikon,
                    color: index == q.dogru ? QC.greenMain : const Color(0xFFD32F2F), size: 22),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _sonucEkrani() {
    final n = widget.sorular.length;
    final perfect = _dogruSayisi == n;
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Sonuç'), automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(perfect ? Icons.workspace_premium_rounded : Icons.emoji_events_rounded,
                size: 84, color: QC.gold),
            const SizedBox(height: 16),
            Text('$_dogruSayisi / $n',
                style: GoogleFonts.lora(
                    fontSize: 46, fontWeight: FontWeight.w800, color: QC.greenDark)),
            const SizedBox(height: 8),
            Text(
                perfect
                    ? 'Mükemmel! Tam puan 🎉'
                    : _dogruSayisi >= n * 0.6
                        ? 'Çok iyi!'
                        : 'Biraz daha çalışmalı 📖',
                style: GoogleFonts.lora(
                    fontSize: 17, fontWeight: FontWeight.w600, color: QC.greenMain)),
            const SizedBox(height: 30),
            Row(children: [
              Expanded(
                child: Material(
                  color: QC.greenMain,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      // Yeni tur.
                      setState(() {
                        _i = 0;
                        _dogruSayisi = 0;
                        _secilen = null;
                        _kilitli = false;
                        _bitti = false;
                        widget.sorular
                          ..clear()
                          ..addAll(_pickRound());
                      });
                      _baslatTimer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text('Tekrar Oyna',
                            style: GoogleFonts.lora(
                                fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFFFAF7F0))),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Material(
                  color: QC.gold,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text('Bitir',
                            style: GoogleFonts.lora(
                                fontSize: 15, fontWeight: FontWeight.w700, color: QC.greenDark)),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
