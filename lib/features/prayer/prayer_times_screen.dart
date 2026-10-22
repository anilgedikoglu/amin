// Namaz Vakitleri ekranı — şehir seçimi, sıradaki namaza canlı geri sayım,
// herhangi bir güne (2026-2036) gezinme.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';
import 'prayer_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});
  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final _svc = PrayerService.instance;
  bool _ready = false;
  DateTime _day = DateTime.now();
  Timer? _timer;

  static const _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  // Vakitler gün/şehir değişince hesaplanır; timer sadece geri sayımı tıklar.
  DailyPrayers? _p;
  ({String name, DateTime time, Duration remaining})? _next;

  @override
  void initState() {
    super.initState();
    _init();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_isToday && (_next == null || _svc.remainingTo(_next!.time).isNegative)) {
        _recompute();
      }
      setState(() {});
    });
  }

  Future<void> _init() async {
    await _svc.ensureLoaded();
    _recompute();
    if (mounted) setState(() => _ready = true);
  }

  void _recompute() {
    _p = _svc.timesFor(DateTime(_day.year, _day.month, _day.day));
    _next = _isToday ? _svc.nextPrayer() : null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _isToday {
    final n = DateTime.now();
    return _day.year == n.year && _day.month == n.month && _day.day == n.day;
  }

  Future<void> _pickCity() async {
    final c = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: QC.greenBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _CityPicker(svc: _svc),
    );
    if (c == true && mounted) setState(() => _recompute());
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return Scaffold(
        backgroundColor: QC.greenBg,
        body: const Center(child: CircularProgressIndicator(color: QC.greenMain)),
      );
    }
    final p = _p ?? _svc.timesFor(DateTime(_day.year, _day.month, _day.day));
    final next = _next;
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text("Namaz Vakitleri", style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
        actions: [
          TextButton.icon(
            onPressed: _pickCity,
            icon: const Icon(Icons.location_on_rounded, color: QC.goldLight, size: 18),
            label: Text(_svc.selected.name,
                style: const TextStyle(color: QC.goldLight, fontSize: 13)),
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 28), children: [
        // Sıradaki namaz + geri sayım
        if (next != null) _countdownCard(next),
        const SizedBox(height: 14),
        // Tarih gezinme
        _dateBar(),
        const SizedBox(height: 14),
        ...p.list.asMap().entries.map((e) {
          final isNext = next != null && next.name == e.value.key;
          return _PrayerRow(
            name: e.value.key,
            time: e.value.value,
            highlight: isNext,
          );
        }),
        const SizedBox(height: 16),
        Text(
            "Vakitler ${_svc.selected.name} için Diyanet (Türkiye) yöntemiyle hesaplanmıştır. Yurt dışı şehirlerde yaz saati uygulamasına göre ±1 saat sapma olabilir.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: QC.greenMid, height: 1.5, fontStyle: FontStyle.italic)),
      ]),
    );
  }

  Widget _countdownCard(({String name, DateTime time, Duration remaining}) next) {
    final r = _svc.remainingTo(next.time);
    final h = r.inHours.toString().padLeft(2, '0');
    final m = (r.inMinutes % 60).toString().padLeft(2, '0');
    final s = (r.inSeconds % 60).toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [QC.greenMain, QC.greenDark]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: QC.gold.withAlpha(140), width: 1.4),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      child: Column(children: [
        Text("SIRADAKİ VAKİT",
            style: TextStyle(fontSize: 10, letterSpacing: 2, color: QC.greenPale.withAlpha(200))),
        const SizedBox(height: 6),
        Text(next.name,
            style: GoogleFonts.lora(fontSize: 26, fontWeight: FontWeight.w700, color: QC.goldLight)),
        const SizedBox(height: 2),
        Text(_hhmm(next.time), style: const TextStyle(fontSize: 13, color: QC.greenPale)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.black.withAlpha(50), borderRadius: BorderRadius.circular(12)),
          child: Text("$h : $m : $s",
              style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFFFAF7F0), letterSpacing: 2)),
        ),
        const SizedBox(height: 4),
        const Text("kaldı", style: TextStyle(fontSize: 11, color: QC.greenPale)),
      ]),
    );
  }

  Widget _dateBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QC.greenPale, width: 1.2),
      ),
      child: Row(children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: QC.greenMain),
          onPressed: () => setState(() { _day = _day.subtract(const Duration(days: 1)); _recompute(); }),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _day,
                firstDate: DateTime(2026, 1, 1),
                lastDate: DateTime(2036, 12, 31),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(primary: QC.greenMain, onPrimary: Color(0xFFFAF7F0)),
                  ),
                  child: child!,
                ),
              );
              if (d != null) setState(() { _day = d; _recompute(); });
            },
            child: Column(children: [
              Text("${_day.day} ${_months[_day.month - 1]} ${_day.year}",
                  style: GoogleFonts.lora(fontSize: 15, fontWeight: FontWeight.w700, color: QC.greenDark)),
              Text(_isToday ? "Bugün · değiştirmek için dokun" : "Tarih seç",
                  style: const TextStyle(fontSize: 10, color: QC.greenMid)),
            ]),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded, color: QC.greenMain),
          onPressed: () => setState(() { _day = _day.add(const Duration(days: 1)); _recompute(); }),
        ),
      ]),
    );
  }

  String _hhmm(DateTime t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
}

class _PrayerRow extends StatelessWidget {
  final String name;
  final DateTime time;
  final bool highlight;
  const _PrayerRow({required this.name, required this.time, required this.highlight});

  static const _icons = {
    'İmsak': Icons.nightlight_round, 'Güneş': Icons.wb_twilight_rounded,
    'Öğle': Icons.wb_sunny_rounded, 'İkindi': Icons.sunny_snowing,
    'Akşam': Icons.nights_stay_rounded, 'Yatsı': Icons.bedtime_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: highlight
            ? const LinearGradient(colors: [QC.gold, QC.goldLight])
            : null,
        color: highlight ? null : Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: highlight ? QC.gold : QC.greenPale, width: 1.2),
        boxShadow: [
          BoxShadow(
              color: (highlight ? QC.gold : QC.greenMain).withAlpha(highlight ? 70 : 16),
              blurRadius: highlight ? 14 : 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(children: [
        Icon(_icons[name] ?? Icons.access_time,
            color: highlight ? QC.greenDark : QC.greenMid, size: 24),
        const SizedBox(width: 14),
        Text(name,
            style: GoogleFonts.lora(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: highlight ? QC.greenDark : QC.greenDark)),
        const Spacer(),
        Text("${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
            style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 20, fontWeight: FontWeight.w700,
                color: highlight ? QC.greenDark : QC.greenMain)),
      ]),
    );
  }
}

class _CityPicker extends StatefulWidget {
  final PrayerService svc;
  const _CityPicker({required this.svc});
  @override
  State<_CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<_CityPicker> {
  String _q = '';
  @override
  Widget build(BuildContext context) {
    final list = _q.isEmpty
        ? widget.svc.cities
        : widget.svc.cities.where((c) => _norm(c.name).contains(_norm(_q))).toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(children: [
          const SizedBox(height: 10),
          Container(width: 44, height: 4,
              decoration: BoxDecoration(color: QC.greenMid, borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: "Şehir ara…",
                prefixIcon: const Icon(Icons.search, color: QC.greenMain),
                filled: true, fillColor: Color(0xFFFAF7F0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: QC.greenPale)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) {
                final c = list[i];
                final sel = c.name == widget.svc.selected.name;
                return ListTile(
                  leading: Icon(Icons.location_city_rounded,
                      color: sel ? QC.gold : QC.greenMid),
                  title: Text(c.name,
                      style: GoogleFonts.lora(
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: QC.greenDark)),
                  trailing: sel ? const Icon(Icons.check_circle, color: QC.gold) : null,
                  onTap: () async {
                    await widget.svc.selectCity(c);
                    if (context.mounted) Navigator.pop(context, true);
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  String _norm(String s) {
    s = s.toLowerCase();
    const m = {'ç': 'c', 'ğ': 'g', 'ı': 'i', 'i̇': 'i', 'ö': 'o', 'ş': 's', 'ü': 'u', 'â': 'a'};
    final b = StringBuffer();
    for (final c in s.split('')) {
      b.write(m[c] ?? c);
    }
    return b.toString();
  }
}
