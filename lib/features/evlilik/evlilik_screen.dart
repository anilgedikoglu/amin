// Evlilikte Mahremiyet — İslami ölçülerle soru-cevap. Kategorili + arama.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';
import 'evlilik_data.dart';

class EvlilikScreen extends StatefulWidget {
  const EvlilikScreen({super.key});
  @override
  State<EvlilikScreen> createState() => _EvlilikScreenState();
}

class _EvlilikScreenState extends State<EvlilikScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final q = _q.trim().toLowerCase();
    final list = q.isEmpty
        ? kEvlilikSorular
        : kEvlilikSorular
            .where((e) =>
                e.soru.toLowerCase().contains(q) ||
                e.cevap.toLowerCase().contains(q) ||
                e.kategori.toLowerCase().contains(q))
            .toList();
    // Kategorilere göre grupla.
    final kategoriler = <String>[];
    for (final e in list) {
      if (!kategoriler.contains(e.kategori)) kategoriler.add(e.kategori);
    }

    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Evlilikte Mahremiyet')),
      body: Column(children: [
        Container(
          color: QC.greenMain.withAlpha(24),
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
          child: Column(children: [
            Text(
                'Eşler arası ilişkiyi İslam\'ın helal-haram ölçüleri ve karşılıklı hak/edep çerçevesinde ele alır. ${kEvlilikSorular.length} soru-cevap.',
                style: GoogleFonts.lora(fontSize: 11.5, height: 1.4, color: QC.greenMid)),
            const SizedBox(height: 8),
            TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'Ara (ör. gusül, âdet, haklar)…',
                prefixIcon: const Icon(Icons.search_rounded, color: QC.greenMid),
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
          ]),
        ),
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Text('Sonuç bulunamadı',
                      style: GoogleFonts.lora(color: QC.greenMid)))
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    for (final kat in kategoriler) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
                        child: Row(children: [
                          Container(width: 4, height: 15, color: QC.gold),
                          const SizedBox(width: 8),
                          Text(kat,
                              style: GoogleFonts.lora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: QC.greenDark)),
                        ]),
                      ),
                      ...list.where((e) => e.kategori == kat).map(_tile),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
        ),
      ]),
    );
  }

  Widget _tile(EvlilikSoru e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: QC.greenPale.withAlpha(150)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: QC.gold,
          collapsedIconColor: QC.gold,
          title: Text(e.soru,
              style: GoogleFonts.lora(
                  fontSize: 14.5, fontWeight: FontWeight.w600, height: 1.35, color: QC.greenDark)),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(e.cevap,
                style: GoogleFonts.lora(
                    fontSize: 14, height: 1.7, color: const Color(0xFF374151))),
          ],
        ),
      ),
    );
  }
}
