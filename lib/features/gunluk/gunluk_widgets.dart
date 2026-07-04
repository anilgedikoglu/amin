// Ana ekran günlük içerik kartları: Günün Ayeti, Tarihte Bugün, Günün İsimleri.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';
import 'gunluk_data.dart';

int _dayOfYear() {
  final now = DateTime.now();
  return now.difference(DateTime(now.year, 1, 1)).inDays;
}

// ── Günün Ayeti ──
class DailyAyahCard extends StatelessWidget {
  const DailyAyahCard({super.key});
  @override
  Widget build(BuildContext context) {
    final a = kGununAyetleri[_dayOfYear() % kGununAyetleri.length];
    return Container(
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
          const Icon(Icons.menu_book_rounded, color: QC.goldLight, size: 18),
          const SizedBox(width: 8),
          Text('GÜNÜN AYETİ',
              style: GoogleFonts.lora(
                  fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w700, color: QC.goldLight)),
        ]),
        const SizedBox(height: 10),
        Text('“${a.metin}”',
            style: GoogleFonts.lora(
                fontSize: 15, height: 1.7, color: Colors.white, fontStyle: FontStyle.italic)),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text('— ${a.kaynak}',
              style: GoogleFonts.lora(
                  fontSize: 12, fontWeight: FontWeight.w700, color: QC.greenPale)),
        ),
      ]),
    );
  }
}

// ── Tarihte Bugün ──
class TarihteBugunCard extends StatelessWidget {
  const TarihteBugunCard({super.key});
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final key =
        '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final olaylar = kTarihteBugun[key];
    final tarihStr =
        '${now.day} ${_aylar[now.month - 1]}';
    return Container(
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
          const Icon(Icons.history_edu_rounded, color: QC.goldLight, size: 18),
          const SizedBox(width: 8),
          Text('TARİHTE BUGÜN · $tarihStr',
              style: GoogleFonts.lora(
                  fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w700, color: QC.goldLight)),
        ]),
        const SizedBox(height: 10),
        if (olaylar == null)
          Text('Bugüne dair kayıtlı özel bir olay bulunmuyor. Her günü hayır ve dua ile değerlendirmek en güzel tarihtir.',
              style: GoogleFonts.lora(fontSize: 13.5, height: 1.65, color: Colors.white))
        else
          for (final o in olaylar)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6, right: 8),
                  child: Icon(Icons.circle, size: 6, color: QC.goldLight),
                ),
                Expanded(
                  child: Text(o,
                      style: GoogleFonts.lora(fontSize: 13.5, height: 1.65, color: Colors.white)),
                ),
              ]),
            ),
      ]),
    );
  }
}

const List<String> _aylar = [
  'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
  'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
];

// ── Günün İsimleri ──
class GununIsimleriCard extends StatelessWidget {
  const GununIsimleriCard({super.key});
  @override
  Widget build(BuildContext context) {
    final d = _dayOfYear();
    final kiz = kKizIsimleri[d % kKizIsimleri.length];
    final erkek = kErkekIsimleri[d % kErkekIsimleri.length];
    return Container(
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
          const Icon(Icons.badge_rounded, color: QC.goldLight, size: 18),
          const SizedBox(width: 8),
          Text('GÜNÜN İSİMLERİ',
              style: GoogleFonts.lora(
                  fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w700, color: QC.goldLight)),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const IsimlerScreen())),
            child: Text('Tümü ›',
                style: GoogleFonts.lora(
                    fontSize: 12, fontWeight: FontWeight.w700, color: QC.goldLight)),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _isimKutu(context, 'Kız', kiz)),
          const SizedBox(width: 10),
          Expanded(child: _isimKutu(context, 'Erkek', erkek)),
        ]),
      ]),
    );
  }

  Widget _isimKutu(BuildContext context, String etiket, Isim isim) {
    return GestureDetector(
      onTap: () => _anlamGoster(context, isim),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: QC.goldLight.withAlpha(90)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(etiket.toUpperCase(),
              style: GoogleFonts.lora(
                  fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700, color: QC.goldLight)),
          const SizedBox(height: 4),
          Text(isim.isim,
              style: GoogleFonts.lora(
                  fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.touch_app_rounded, size: 12, color: QC.goldLight),
            const SizedBox(width: 4),
            Text('anlamı için dokun',
                style: GoogleFonts.lora(fontSize: 10.5, color: QC.greenPale)),
          ]),
        ]),
      ),
    );
  }

  void _anlamGoster(BuildContext context, Isim isim) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(isim.isim,
            style: GoogleFonts.lora(fontWeight: FontWeight.w800, color: QC.greenDark)),
        content: Text(isim.anlam,
            style: GoogleFonts.lora(fontSize: 14.5, height: 1.6, color: const Color(0xFF374151))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat',
                style: GoogleFonts.lora(color: QC.greenMain, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ── İsimler tarayıcı (kız/erkek + arama) ──
class IsimlerScreen extends StatefulWidget {
  const IsimlerScreen({super.key});
  @override
  State<IsimlerScreen> createState() => _IsimlerScreenState();
}

class _IsimlerScreenState extends State<IsimlerScreen> {
  bool _kiz = true;
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final q = _q.trim().toLowerCase();
    final kaynak = _kiz ? kKizIsimleri : kErkekIsimleri;
    final list = q.isEmpty
        ? kaynak
        : kaynak
            .where((i) =>
                i.isim.toLowerCase().contains(q) || i.anlam.toLowerCase().contains(q))
            .toList();
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Müslüman İsimleri')),
      body: Column(children: [
        Container(
          color: QC.greenMain.withAlpha(24),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(children: [
            Row(children: [
              Expanded(child: _seg('Kız İsimleri', _kiz, () => setState(() => _kiz = true))),
              const SizedBox(width: 8),
              Expanded(child: _seg('Erkek İsimleri', !_kiz, () => setState(() => _kiz = false))),
            ]),
            const SizedBox(height: 8),
            TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'İsim veya anlam ara…',
                prefixIcon: const Icon(Icons.search_rounded, color: QC.greenMid),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: QC.greenPale.withAlpha(160))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: QC.greenPale.withAlpha(160))),
              ),
            ),
          ]),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: QC.greenPale.withAlpha(150)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(list[i].isim,
                    style: GoogleFonts.lora(
                        fontSize: 16, fontWeight: FontWeight.w800, color: QC.greenDark)),
                const SizedBox(height: 4),
                Text(list[i].anlam,
                    style: GoogleFonts.lora(
                        fontSize: 13, height: 1.5, color: const Color(0xFF4b5563))),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _seg(String label, bool aktif, VoidCallback onTap) {
    return Material(
      color: aktif ? QC.greenMain : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: QC.greenPale.withAlpha(160))),
          child: Text(label,
              style: GoogleFonts.lora(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: aktif ? Colors.white : QC.greenDark)),
        ),
      ),
    );
  }
}
