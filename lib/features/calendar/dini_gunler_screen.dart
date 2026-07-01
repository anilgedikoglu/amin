// Dini Günler — yıl yıl kandiller, bayramlar, mübarek günler.
// Hicri sabit tarihler, miladi yıla tarama yöntemiyle hesaplanır.
// Not: Diyanet'in resmî takvimi ±1 gün farklı olabilir.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import '../quran/quran_theme.dart';

class DiniGun {
  final DateTime date;
  final String isim;
  final String aciklama;
  final String emoji; // küçük simge yerine metin işaret
  const DiniGun(this.date, this.isim, this.aciklama, this.emoji);
}

class DiniGunlerScreen extends StatefulWidget {
  const DiniGunlerScreen({super.key});
  @override
  State<DiniGunlerScreen> createState() => _DiniGunlerScreenState();
}

class _DiniGunlerScreenState extends State<DiniGunlerScreen> {
  late int _year;
  static const _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];
  static const _days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
  static const _hicriAylar = [
    'Muharrem', 'Safer', 'Rebiülevvel', 'Rebiülahir', 'Cemaziyelevvel',
    'Cemaziyelahir', 'Recep', 'Şaban', 'Ramazan', 'Şevval', 'Zilkade', 'Zilhicce'
  ];

  @override
  void initState() {
    super.initState();
    _year = DateTime.now().year;
    if (_year < 2026) _year = 2026;
  }

  // Sabit hicri tarihler → (ay, gün, isim, açıklama)
  static const _fixed = [
    [1, 1, 'Hicri Yılbaşı', 'Muharrem ayının ilk günü, yeni hicri yılın başlangıcı.'],
    [1, 10, 'Aşure Günü', 'Muharrem\'in 10. günü; oruç tutulması müstehap olan mübarek gün.'],
    [3, 12, 'Mevlid Kandili', 'Hz. Muhammed (s.a.v.)\'in dünyaya teşrif ettiği gece.'],
    [7, 1, 'Üç Ayların Başlangıcı', 'Recep, Şaban ve Ramazan; rahmet ve mağfiret mevsimi.'],
    [7, 27, 'Mirac Kandili', 'Hz. Peygamber\'in Mirac mucizesinin yaşandığı mübarek gece.'],
    [8, 15, 'Berat Kandili', 'Affedilme ve beraat gecesi; günahlardan arınma fırsatı.'],
    [9, 1, 'Ramazan Başlangıcı', 'On bir ayın sultanı Ramazan ayının ilk günü, orucun başlangıcı.'],
    [9, 27, 'Kadir Gecesi', 'Bin aydan hayırlı, Kur\'an\'ın indirilmeye başladığı gece.'],
    [10, 1, 'Ramazan Bayramı', 'Ramazan Bayramı\'nın 1. günü; orucun tamamlanmasının sevinci.'],
    [12, 9, 'Arefe Günü', 'Kurban Bayramı öncesi; duaların kabul olduğu mübarek gün.'],
    [12, 10, 'Kurban Bayramı', 'Kurban Bayramı\'nın 1. günü; hac ve kurban ibadeti.'],
  ];

  List<DiniGun> _compute(int year) {
    final result = <DiniGun>[];
    final seen = <String>{};
    var d = DateTime(year, 1, 1);
    final end = DateTime(year, 12, 31);
    var regaipDone = <int>{}; // hYear bazında Regaip kaydı
    while (!d.isAfter(end)) {
      final h = HijriCalendar.fromDate(d);
      for (final ev in _fixed) {
        if (h.hMonth == ev[0] && h.hDay == ev[1]) {
          final key = '${ev[2]}-${h.hYear}';
          if (seen.add(key)) {
            result.add(DiniGun(d, ev[2] as String, ev[3] as String, '☾'));
          }
        }
      }
      // Regaip Kandili: Recep ayının ilk cuma gecesi (ilk perşembeyi akşamı)
      if (h.hMonth == 7 && d.weekday == DateTime.friday && !regaipDone.contains(h.hYear)) {
        regaipDone.add(h.hYear);
        result.add(DiniGun(d, 'Regaib Kandili',
            'Üç ayların ilk cuma gecesi; manevi bir dönüm noktası.', '☾'));
      }
      d = d.add(const Duration(days: 1));
    }
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final days = _compute(_year);
    final hijriNow = HijriCalendar.now();
    final today = DateTime.now();
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text("Dini Günler", style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
      ),
      body: Column(children: [
        // Bugünün hicri tarihi + yıl seçici
        Container(
          color: QC.greenDark,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: QC.gold.withAlpha(80))),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.today_rounded, color: QC.goldLight, size: 18),
                const SizedBox(width: 8),
                Text(
                    "Bugün: ${today.day} ${_months[today.month - 1]} ${today.year}  •  ${hijriNow.hDay} ${_hicriAylar[hijriNow.hMonth - 1]} ${hijriNow.hYear}",
                    style: const TextStyle(fontSize: 12, color: QC.greenPale)),
              ]),
            ),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _yrBtn(Icons.chevron_left_rounded, () {
                if (_year > 2026) setState(() => _year--);
              }, _year > 2026),
              Container(
                width: 110,
                alignment: Alignment.center,
                child: Text("$_year",
                    style: GoogleFonts.lora(
                        fontSize: 24, fontWeight: FontWeight.w700, color: QC.goldLight)),
              ),
              _yrBtn(Icons.chevron_right_rounded, () {
                if (_year < 2036) setState(() => _year++);
              }, _year < 2036),
            ]),
          ]),
        ),
        Expanded(child: Builder(builder: (ctx) {
          final todayMid = DateTime(today.year, today.month, today.day);
          final upcoming = days.where((g) => !g.date.isBefore(todayMid)).toList();
          final past = days.where((g) => g.date.isBefore(todayMid)).toList();
          final bothSections = upcoming.isNotEmpty && past.isNotEmpty;

          Widget card(DiniGun g, bool isPast) => _DiniGunCard(
              gun: g, dayLabel: _days[g.date.weekday - 1],
              monthLabel: _months[g.date.month - 1], isPast: isPast);

          return ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            children: [
              if (bothSections) _sectionHeader("YAKLAŞAN GÜNLER", QC.gold),
              ...upcoming.map((g) => card(g, false)),
              if (bothSections) ...[
                const SizedBox(height: 8),
                _sectionHeader("GEÇEN GÜNLER", QC.greenMid),
              ],
              ...past.map((g) => card(g, true)),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                    "Tarihler hicri takvime göre hesaplanmıştır; Diyanet'in resmî takvimi ile ±1 gün farklılık gösterebilir.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: QC.greenMid, height: 1.5, fontStyle: FontStyle.italic)),
              ),
            ],
          );
        })),
      ]),
    );
  }

  Widget _sectionHeader(String text, Color color) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 10),
        child: Row(children: [
          Container(width: 3, height: 16,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(text,
              style: GoogleFonts.lora(
                  fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: color.withAlpha(70))),
        ]),
      );

  Widget _yrBtn(IconData icon, VoidCallback onTap, bool enabled) => IconButton(
        onPressed: enabled ? onTap : null,
        icon: Icon(icon, color: enabled ? QC.goldLight : Colors.white24, size: 30),
      );
}

class _DiniGunCard extends StatelessWidget {
  final DiniGun gun;
  final String dayLabel, monthLabel;
  final bool isPast;
  const _DiniGunCard(
      {required this.gun, required this.dayLabel, required this.monthLabel, required this.isPast});
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isPast ? 0.55 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: QC.greenPale, width: 1.2),
          boxShadow: [BoxShadow(color: QC.greenMain.withAlpha(16), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(children: [
          Container(
            width: 56,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [QC.greenMain, QC.greenDark]),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: QC.gold.withAlpha(140)),
            ),
            child: Column(children: [
              Text('${gun.date.day}',
                  style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.w700, color: QC.goldLight)),
              Text(monthLabel.substring(0, 3),
                  style: const TextStyle(fontSize: 10, color: QC.greenPale)),
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(gun.isim,
                  style: GoogleFonts.lora(fontSize: 15, fontWeight: FontWeight.w700, color: QC.greenDark)),
              const SizedBox(height: 2),
              Text("$dayLabel günü",
                  style: const TextStyle(fontSize: 10.5, color: QC.gold, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(gun.aciklama,
                  style: const TextStyle(fontSize: 11.5, color: QC.greenMid, height: 1.4)),
            ]),
          ),
        ]),
      ),
    );
  }
}
