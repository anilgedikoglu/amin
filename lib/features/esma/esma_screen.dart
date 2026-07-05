// Esma-ül Hüsna — Allah'ın 99 güzel ismi.
// Arapça + Latin okunuş + Türkçe anlam + açıklama. Tamamen offline (asset).
import 'dart:convert';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';

class Esma {
  final int id;
  final String arabic, okunus, anlam, aciklama;
  const Esma(this.id, this.arabic, this.okunus, this.anlam, this.aciklama);
  factory Esma.fromJson(Map<String, dynamic> j) =>
      Esma(j['id'], j['ar'], j['tr'], j['anlam'], j['aciklama']);
}

List<Esma> _parse(String raw) =>
    (jsonDecode(raw) as List).map((e) => Esma.fromJson(e)).toList();

class EsmaScreen extends StatefulWidget {
  const EsmaScreen({super.key});
  @override
  State<EsmaScreen> createState() => _EsmaScreenState();
}

class _EsmaScreenState extends State<EsmaScreen> {
  List<Esma> _all = const [];
  String _q = '';
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw = await rootBundle.loadString('assets/data/esma.json');
    _all = await compute(_parse, raw);
    if (mounted) setState(() => _ready = true);
  }

  String _norm(String s) {
    s = s.toLowerCase();
    const m = {'â': 'a', 'î': 'i', 'û': 'u', 'ç': 'c', 'ğ': 'g', 'ı': 'i', 'ö': 'o', 'ş': 's', 'ü': 'u', "'": ''};
    final b = StringBuffer();
    for (final c in s.split('')) {
      b.write(m[c] ?? c);
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final list = _q.isEmpty
        ? _all
        : _all.where((e) => _norm(e.okunus).contains(_norm(_q)) || _norm(e.anlam).contains(_norm(_q))).toList();
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Esmâ-ül Hüsnâ", style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
          const Text("Allah'ın 99 güzel ismi",
              style: TextStyle(fontSize: 10, color: QC.greenPale, letterSpacing: .5)),
        ]),
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator(color: QC.greenMain))
          : Column(children: [
              Container(
                color: QC.greenDark,
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: TextField(
                  onChanged: (v) => setState(() => _q = v),
                  style: const TextStyle(color: Color(0xFFFAF7F0), fontSize: 14),
                  cursorColor: QC.goldLight,
                  decoration: InputDecoration(
                    hintText: "İsim veya anlam ara…",
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: QC.greenPale, size: 20),
                    filled: true,
                    fillColor: Color(0xFFFAF7F0).withAlpha(22),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: QC.gold.withAlpha(90))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: QC.gold)),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) => _EsmaTile(esma: list[i]),
                ),
              ),
            ]),
    );
  }
}

class _EsmaTile extends StatelessWidget {
  final Esma esma;
  const _EsmaTile({required this.esma});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => _EsmaSheet(esma: esma),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFFFAF7F0),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: QC.greenPale, width: 1.2),
          boxShadow: [BoxShadow(color: QC.greenMain.withAlpha(16), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [QC.greenMain, QC.greenDark]),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: QC.gold.withAlpha(150)),
            ),
            child: Center(
              child: Text('${esma.id}',
                  style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.w700, color: QC.goldLight)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(esma.okunus,
                  style: GoogleFonts.lora(fontSize: 15, fontWeight: FontWeight.w700, color: QC.greenDark)),
              const SizedBox(height: 2),
              Text(esma.anlam,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11.5, color: QC.greenMid, height: 1.3)),
            ]),
          ),
          const SizedBox(width: 8),
          Text(esma.arabic,
              style: const TextStyle(fontFamily: QC.arabicFont, fontSize: 24, color: QC.greenMain)),
        ]),
      ),
    );
  }
}

class _EsmaSheet extends StatelessWidget {
  final Esma esma;
  const _EsmaSheet({required this.esma});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [QC.greenDark, QC.greenMain]),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
      child: SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 44, height: 4,
            decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 24),
        Text(esma.arabic,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: QC.arabicFont, fontSize: 52, height: 1.5, color: QC.goldLight)),
        const SizedBox(height: 18),
        Text(esma.okunus,
            style: GoogleFonts.lora(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFFFAF7F0))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
              color: QC.gold.withAlpha(50), borderRadius: BorderRadius.circular(20)),
          child: Text(esma.anlam,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: QC.goldLight, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(0xFFFAF7F0).withAlpha(20),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: QC.gold.withAlpha(70))),
          child: Text(esma.aciklama,
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(fontSize: 14, height: 1.7, color: QC.greenPale)),
        ),
      ]),
      ),
    );
  }
}
