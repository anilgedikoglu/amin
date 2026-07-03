// Arapça Sözlük — Türkçe ↔ Arapça çift yönlü arama.
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

  // Türkçe-duyarsız sadeleştirme.
  String _fold(String s) => s
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('İ', 'i')
      .replaceAll('ş', 's')
      .replaceAll('ğ', 'g')
      .replaceAll('ç', 'c')
      .replaceAll('ü', 'u')
      .replaceAll('ö', 'o')
      .replaceAll('â', 'a')
      .replaceAll('î', 'i')
      .replaceAll('û', 'u')
      .replaceAll('\'', '');

  @override
  Widget build(BuildContext context) {
    final q = _fold(_q.trim());
    final list = q.isEmpty
        ? kSozluk
        : kSozluk
            .where((k) =>
                _fold(k.turkce).contains(q) ||
                _fold(k.okunus).contains(q) ||
                k.arabic.contains(_q.trim()))
            .toList();

    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Arapça Sözlük')),
      body: Column(children: [
        Container(
          color: QC.greenMain.withAlpha(24),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(children: [
            TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'Türkçe veya Arapça ara (ör. su / mâ)…',
                prefixIcon: const Icon(Icons.translate_rounded, color: QC.greenMid),
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
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('${list.length} kelime · Türkçe↔Arapça',
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

  Widget _kart(SozlukKelime k) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: QC.greenPale.withAlpha(150)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(k.turkce,
                style: GoogleFonts.lora(
                    fontSize: 15.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
            const SizedBox(height: 3),
            Text(k.okunus,
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
