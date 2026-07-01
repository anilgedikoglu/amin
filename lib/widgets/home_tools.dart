// Ana ekran ek bileşenleri: sıradaki namaza geri sayım + İbadet & Araçlar grid.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/calendar/dini_gunler_screen.dart';
import '../features/esma/esma_screen.dart';
import '../features/prayer/prayer_service.dart';
import '../features/prayer/prayer_times_screen.dart';
import '../features/delil/screens/home_screen.dart';
import '../features/elifba/elifba_screen.dart';
import '../features/ezber/ezber_screen.dart';
import '../features/sosyal/sosyal_screen.dart';
import '../features/teoloji/teoloji_screen.dart';
import '../features/yeni_musluman/yeni_musluman_screen.dart';
import '../features/notifications/reminder_settings_screen.dart';
import '../features/qibla/qibla_screen.dart';
import '../features/quran/quran_theme.dart';
import '../features/risale/risale_screens.dart';
import '../features/sorular/dini_sorular.dart';
import '../features/sozler/sozler_repository.dart';
import '../features/sozler/sozler_screen.dart';

// ── Sıradaki namaza geri sayım (ana ekran banner) ──
class NextPrayerBanner extends StatefulWidget {
  const NextPrayerBanner({super.key});
  @override
  State<NextPrayerBanner> createState() => _NextPrayerBannerState();
}

class _NextPrayerBannerState extends State<NextPrayerBanner> {
  final _svc = PrayerService.instance;
  bool _ready = false;
  Timer? _timer;
  // Namaz vakti BİR KEZ hesaplanır; her saniye sadece geri sayım tıklar.
  ({String name, DateTime time, Duration remaining})? _next;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _svc.ensureLoaded();
    if (!mounted) return;
    _next = _svc.nextPrayer();
    setState(() => _ready = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      // Vakit geçtiyse yeniden hesapla; aksi halde sadece ekranı tazele.
      if (_next == null || _svc.remainingTo(_next!.time).isNegative) {
        _next = _svc.nextPrayer();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SizedBox(height: 0);
    final next = _next;
    if (next == null) return const SizedBox(height: 0);
    final r = _svc.remainingTo(next.time);
    final cd =
        "${r.inHours.toString().padLeft(2, '0')}:${(r.inMinutes % 60).toString().padLeft(2, '0')}:${(r.inSeconds % 60).toString().padLeft(2, '0')}";
    final hhmm =
        "${next.time.hour.toString().padLeft(2, '0')}:${next.time.minute.toString().padLeft(2, '0')}";
    // Buton değil, bilgi şeridi: sol altın aksan, düz bant, "NAMAZ VAKTİ" etiketi.
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const PrayerTimesScreen())),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black.withAlpha(55), Colors.white.withAlpha(8)]),
          borderRadius: BorderRadius.circular(10),
          border: const Border(left: BorderSide(color: QC.gold, width: 4)),
        ),
        child: Row(children: [
          const SizedBox(width: 13),
          const Icon(Icons.access_time_filled_rounded, color: QC.goldLight, size: 19),
          const SizedBox(width: 11),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("NAMAZ VAKTİ",
                    style: GoogleFonts.lora(
                        fontSize: 8.5,
                        color: QC.gold,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text("${_svc.selected.name} · Sıradaki ${next.name} · $hhmm",
                    style: GoogleFonts.lora(
                        fontSize: 12,
                        color: QC.greenPale,
                        fontWeight: FontWeight.w600)),
              ]),
          const Spacer(),
          Text(cd,
              style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: QC.goldLight,
                  letterSpacing: 1)),
          const SizedBox(width: 14),
        ]),
      ),
    );
  }
}

// ── Günün Hadisi kartı (ana ekran) ──
class DailyHadisCard extends StatefulWidget {
  const DailyHadisCard({super.key});
  @override
  State<DailyHadisCard> createState() => _DailyHadisCardState();
}

class _DailyHadisCardState extends State<DailyHadisCard> {
  final _repo = SozlerRepository.instance;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _repo.ensureLoaded().then((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SizedBox(height: 0);
    final s = _repo.hadisOfDay();
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const SozlerScreen())),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [QC.greenMain, QC.greenDark]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: QC.gold.withAlpha(120), width: 1.3),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(55), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.auto_stories_rounded, color: QC.goldLight, size: 18),
            const SizedBox(width: 8),
            Text("GÜNÜN HADİSİ",
                style: GoogleFonts.lora(
                    fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w700, color: QC.goldLight)),
            const Spacer(),
            const Icon(Icons.format_quote_rounded, color: Colors.white24, size: 26),
          ]),
          const SizedBox(height: 10),
          Text(s.metin,
              style: GoogleFonts.lora(fontSize: 14.5, height: 1.7, color: Colors.white)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text("— ${s.kaynak}",
                style: const TextStyle(fontSize: 12, color: QC.greenPale, fontStyle: FontStyle.italic)),
          ),
        ]),
      ),
    );
  }
}

// ── Delil & İman Hakikatleri — alt alta büyük yatay butonlar ──
class DelilGrid extends StatelessWidget {
  const DelilGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const _DelilButton(
        icon: Icons.verified_rounded,
        title: "Deliller",
        subtitle: "Allah'ın varlığının felsefî, bilimsel ve iman hakikatleri delilleri",
        tab: 0,
      ),
      const SizedBox(height: 12),
      const _DelilButton(
        icon: Icons.auto_awesome_rounded,
        title: "Mucizeler",
        subtitle: "Kur'an'ın ve Peygamber'in ilmî, edebî ve gaybî mucizeleri",
        tab: 1,
      ),
      const SizedBox(height: 12),
      const _DelilButton(
        icon: Icons.question_answer_rounded,
        title: "Cevaplar",
        subtitle: "İnanca dair itiraz, şüphe ve modern sorulara cevaplar",
        tab: 2,
      ),
      const SizedBox(height: 12),
      const _DelilButton(
        icon: Icons.format_quote_rounded,
        title: "Sözler",
        subtitle: "Filozof, bilim insanı ve âlimlerin imana dair sözleri",
        tab: 3,
      ),
      const SizedBox(height: 12),
      _DelilButton(
        icon: Icons.local_library_rounded,
        title: "Risale-i Nur Külliyatı",
        subtitle: "Tam metin · konu araması · sade lügatçe açıklamalı (15 kitap)",
        destination: () => const RisaleHomeScreen(),
      ),
    ]);
  }
}

class _DelilButton extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final int tab;
  final Widget Function()? destination;
  const _DelilButton(
      {required this.icon,
      required this.title,
      required this.subtitle,
      this.tab = 0,
      this.destination});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    destination != null ? destination!() : DelilHomeScreen(initialTab: tab))),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Colors.white.withAlpha(20), Colors.white.withAlpha(10)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: QC.gold.withAlpha(95), width: 1.2),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(55), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Row(children: [
              Container(
                width: 50, height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(center: Alignment(-0.3, -0.4), colors: [QC.goldLight, QC.gold]),
                ),
                child: Icon(icon, color: QC.greenDark, size: 25),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title,
                      style: GoogleFonts.lora(
                          fontSize: 17, fontWeight: FontWeight.w700, color: QC.goldLight)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: GoogleFonts.lora(fontSize: 11.5, height: 1.35, color: QC.greenPale)),
                ]),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: QC.gold),
            ]),
          ),
        ),
      ),
    );
  }
}

// ── İbadet & Araçlar grid ──
class ToolsGrid extends StatelessWidget {
  const ToolsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = <_Tool>[
      _Tool(Icons.access_time_filled_rounded, "Namaz\nVakitleri",
          () => const PrayerTimesScreen()),
      _Tool(Icons.explore_rounded, "Kıble\nPusulası", () => const QiblaScreen()),
      _Tool(Icons.calendar_month_rounded, "Dini\nGünler", () => const DiniGunlerScreen()),
      _Tool(Icons.celebration_rounded, "Sosyal\nKutlama", () => const SosyalScreen()),
      _Tool(Icons.volunteer_activism_rounded, "Yeni\nMüslüman",
          () => const YeniMuslumanScreen()),
      _Tool(Icons.auto_awesome_rounded, "Esmâ-ül\nHüsnâ", () => const EsmaScreen()),
      _Tool(Icons.menu_book_rounded, "Hadis &\nSözler", () => const SozlerScreen()),
      _Tool(Icons.quiz_rounded, "Dini\nSorular", () => const DiniSorularScreen()),
      _Tool(Icons.abc_rounded, "Arapça\nOkuma", () => const ElifbaScreen()),
      _Tool(Icons.psychology_alt_rounded, "Ezber", () => const EzberScreen()),
      _Tool(Icons.lightbulb_outline_rounded, "Din\nFelsefesi",
          () => const TeolojiScreen()),
      _Tool(Icons.notifications_active_rounded, "Günlük\nHatırlatma",
          () => const ReminderSettingsScreen()),
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.92,
      children: tools.map((t) => _ToolTile(tool: t)).toList(),
    );
  }
}

class _Tool {
  final IconData icon;
  final String label;
  final Widget Function() screen;
  _Tool(this.icon, this.label, this.screen);
}

class _ToolTile extends StatelessWidget {
  final _Tool tool;
  const _ToolTile({required this.tool});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => tool.screen())),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(16),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: QC.gold.withAlpha(75)),
        ),
        child: Column(children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  center: Alignment(-0.3, -0.4), colors: [QC.goldLight, QC.gold]),
            ),
            child: Icon(tool.icon, color: QC.greenDark, size: 24),
          ),
          const SizedBox(height: 10),
          Text(tool.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                  fontSize: 12, height: 1.2, fontWeight: FontWeight.w600, color: QC.goldLight)),
        ]),
      ),
    );
  }
}
