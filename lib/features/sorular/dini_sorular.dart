// Dini Sorular — 1000 popüler İslami soru-cevap. Kategoriye göre + arama;
// soruya dokun → cevap; cevabı okununca tamamlanma tiki.
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../quran/quran_theme.dart';

class Soru {
  final String kategori, soru, cevap, detay;
  const Soru(this.kategori, this.soru, this.cevap, this.detay);
}

List<Soru> _parse(String raw) {
  final list = jsonDecode(raw) as List;
  return list
      .map((e) => Soru(e['k'] as String? ?? 'Genel', e['s'] as String? ?? '',
          e['c'] as String? ?? '', e['d'] as String? ?? ''))
      .toList();
}

String _fold(String s) => s
    .toLowerCase()
    .replaceAll('ı', 'i')
    .replaceAll('İ', 'i')
    .replaceAll('ş', 's')
    .replaceAll('ğ', 'g')
    .replaceAll('ç', 'c')
    .replaceAll('ü', 'u')
    .replaceAll('ö', 'o');

class DiniSorularRepo {
  DiniSorularRepo._();
  static final DiniSorularRepo instance = DiniSorularRepo._();

  List<Soru>? _all;
  final Set<int> _read = {};
  bool _readLoaded = false;

  Future<List<Soru>> all() async {
    if (_all != null) return _all!;
    final raw = await rootBundle.loadString('assets/data/dini_sorular.json');
    _all = await compute(_parse, raw);
    return _all!;
  }

  Future<void> _ensureRead() async {
    if (_readLoaded) return;
    final p = await SharedPreferences.getInstance();
    _read
      ..clear()
      ..addAll((p.getStringList('soru_read') ?? []).map(int.parse));
    _readLoaded = true;
  }

  bool isRead(int i) => _read.contains(i);

  Future<void> markRead(int i) async {
    await _ensureRead();
    if (_read.add(i)) {
      final p = await SharedPreferences.getInstance();
      await p.setStringList('soru_read', _read.map((e) => e.toString()).toList());
    }
  }

  Future<void> init() async {
    await all();
    await _ensureRead();
  }
}

// ── Kategori listesi (giriş) ──
class DiniSorularScreen extends StatefulWidget {
  const DiniSorularScreen({super.key});
  @override
  State<DiniSorularScreen> createState() => _DiniSorularScreenState();
}

class _DiniSorularScreenState extends State<DiniSorularScreen> {
  final _repo = DiniSorularRepo.instance;
  List<Soru> _all = [];
  bool _ready = false;
  String _q = '';

  @override
  void initState() {
    super.initState();
    _repo.init().then((_) {
      if (mounted) setState(() {
        _all = _repo._all!;
        _ready = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final searching = _q.trim().length >= 2;
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Dini Sorular')),
      body: !_ready
          ? const Center(child: CircularProgressIndicator(color: QC.greenMain))
          : Column(children: [
              Container(
                color: QC.greenDark,
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: TextField(
                  onChanged: (v) => setState(() => _q = v),
                  style: GoogleFonts.lora(color: Color(0xFFFAF7F0), fontSize: 14.5),
                  decoration: InputDecoration(
                    hintText: 'Soru ara (oruç, nazar, sakız, cin…)',
                    hintStyle: GoogleFonts.lora(color: QC.greenPale, fontSize: 13.5),
                    prefixIcon: const Icon(Icons.search_rounded, color: QC.goldLight),
                    filled: true,
                    fillColor: QC.greenMain.withAlpha(120),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  ),
                ),
              ),
              Expanded(child: searching ? _searchList() : _kategoriList()),
            ]),
    );
  }

  Widget _kategoriList() {
    final kats = <String>[];
    for (final s in _all) {
      if (!kats.contains(s.kategori)) kats.add(s.kategori);
    }
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Text('${_all.length} popüler soru · dokun, cevabı oku, tamamla',
            style: GoogleFonts.lora(fontSize: 12.5, color: QC.greenMid)),
        const SizedBox(height: 12),
        ...kats.map((k) {
          final list = _all.where((s) => s.kategori == k).length;
          final okunan = _all
              .asMap()
              .entries
              .where((e) => e.value.kategori == k && _repo.isRead(e.key))
              .length;
          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            decoration: BoxDecoration(
              color: Color(0xFFFAF7F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: QC.greenPale.withAlpha(160)),
            ),
            child: ListTile(
              leading: const Icon(Icons.help_outline_rounded, color: QC.gold),
              title: Text(k,
                  style: GoogleFonts.lora(
                      fontSize: 14.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
              subtitle: Text('$list soru · $okunan okundu',
                  style: GoogleFonts.lora(fontSize: 11.5, color: QC.greenMid)),
              trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DiniSorularKategoriScreen(kategori: k)));
                if (mounted) setState(() {});
              },
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _searchList() {
    final q = _fold(_q.trim());
    final hits = <int>[];
    for (var i = 0; i < _all.length; i++) {
      final s = _all[i];
      if (_fold(s.soru).contains(q) ||
          _fold(s.cevap).contains(q) ||
          _fold(s.kategori).contains(q)) {
        hits.add(i);
      }
    }
    if (hits.isEmpty) {
      return Center(
          child: Text('"$_q" için soru bulunamadı.',
              style: GoogleFonts.lora(color: QC.greenMid)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: hits.length + 1,
      itemBuilder: (_, idx) {
        if (idx == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            child: Text('${hits.length} sonuç',
                style: GoogleFonts.lora(
                    fontSize: 12.5, fontWeight: FontWeight.w600, color: QC.greenMid)),
          );
        }
        final i = hits[idx - 1];
        return _soruTile(i, showKat: true, onChanged: () => setState(() {}));
      },
    );
  }

  Widget _soruTile(int i, {bool showKat = false, required VoidCallback onChanged}) {
    final s = _all[i];
    final read = _repo.isRead(i);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: QC.greenPale.withAlpha(150)),
      ),
      child: ListTile(
        leading: Icon(
            read ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: read ? QC.greenMid : QC.greenPale),
        title: Text(s.soru,
            style: GoogleFonts.lora(
                fontSize: 13.5, fontWeight: FontWeight.w600, color: QC.greenDark)),
        subtitle: showKat
            ? Text(s.kategori, style: GoogleFonts.lora(fontSize: 11, color: QC.gold))
            : null,
        trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
        onTap: () async {
          await _showCevap(context, i);
          onChanged();
        },
      ),
    );
  }

  Future<void> _showCevap(BuildContext context, int i) async {
    await _repo.markRead(i);
    if (!context.mounted) return;
    final s = _all[i];
    await showModalBottomSheet(
      context: context,
      backgroundColor: QC.greenBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: QC.greenPale, borderRadius: BorderRadius.circular(4))),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                    color: QC.gold.withAlpha(40),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(s.kategori,
                    style: GoogleFonts.lora(
                        fontSize: 10.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
              ),
              const Spacer(),
              const Icon(Icons.check_circle_rounded, color: QC.greenMid, size: 20),
              const SizedBox(width: 4),
              Text('Okundu',
                  style: GoogleFonts.lora(
                      fontSize: 11.5, fontWeight: FontWeight.w700, color: QC.greenMid)),
            ]),
            const SizedBox(height: 14),
            Text(s.soru,
                style: GoogleFonts.lora(
                    fontSize: 18, fontWeight: FontWeight.w800, color: QC.greenDark, height: 1.35)),
            const SizedBox(height: 16),
            if (s.cevap.isNotEmpty) ...[
              Text('Kısa Cevap',
                  style: GoogleFonts.lora(
                      fontSize: 12, fontWeight: FontWeight.w700, color: QC.gold)),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: Color(0xFFFAF7F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: QC.greenPale.withAlpha(160))),
                child: Text(s.cevap,
                    style: GoogleFonts.lora(fontSize: 15, height: 1.55, color: QC.greenDark)),
              ),
            ],
            if (s.detay.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text('Açıklama',
                  style: GoogleFonts.lora(
                      fontSize: 12, fontWeight: FontWeight.w700, color: QC.gold)),
              const SizedBox(height: 5),
              Text(s.detay,
                  style: GoogleFonts.lora(fontSize: 14, height: 1.6, color: QC.greenDark)),
            ],
            const SizedBox(height: 16),
            Text(
                'Kısa içerik amaçlıdır; mezhep ve fetva farklılıkları olabilir. Detay için ehil bir hocaya/Diyanet\'e danışılmalıdır.',
                style: GoogleFonts.lora(
                    fontSize: 10.5, fontStyle: FontStyle.italic, color: QC.greenMid, height: 1.4)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Kategori içi soru listesi ──
class DiniSorularKategoriScreen extends StatefulWidget {
  final String kategori;
  const DiniSorularKategoriScreen({super.key, required this.kategori});
  @override
  State<DiniSorularKategoriScreen> createState() => _DiniSorularKategoriScreenState();
}

class _DiniSorularKategoriScreenState extends State<DiniSorularKategoriScreen> {
  final _repo = DiniSorularRepo.instance;

  @override
  Widget build(BuildContext context) {
    final all = _repo._all ?? [];
    final idxs = <int>[];
    for (var i = 0; i < all.length; i++) {
      if (all[i].kategori == widget.kategori) idxs.add(i);
    }
    final okunan = idxs.where(_repo.isRead).length;
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: Text(widget.kategori)),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: idxs.length + 1,
        itemBuilder: (_, k) {
          if (k == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
              child: Text('${idxs.length} soru · $okunan okundu',
                  style: GoogleFonts.lora(
                      fontSize: 12.5, fontWeight: FontWeight.w600, color: QC.greenMid)),
            );
          }
          final i = idxs[k - 1];
          final s = all[i];
          final read = _repo.isRead(i);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Color(0xFFFAF7F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: QC.greenPale.withAlpha(150)),
            ),
            child: ListTile(
              leading: Icon(
                  read ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: read ? QC.greenMid : QC.greenPale),
              title: Text(s.soru,
                  style: GoogleFonts.lora(
                      fontSize: 13.5, fontWeight: FontWeight.w600, color: QC.greenDark)),
              trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
              onTap: () async {
                await _showCevap(i);
                if (mounted) setState(() {});
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _showCevap(int i) async {
    // Aynı cevap sheet'ini ana ekrandaki mantıkla göster.
    await _repo.markRead(i);
    if (!mounted) return;
    final s = _repo._all![i];
    await showModalBottomSheet(
      context: context,
      backgroundColor: QC.greenBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.92,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: QC.greenPale, borderRadius: BorderRadius.circular(4))),
            ),
            const SizedBox(height: 14),
            Row(children: [
              const Icon(Icons.check_circle_rounded, color: QC.greenMid, size: 20),
              const SizedBox(width: 4),
              Text('Okundu',
                  style: GoogleFonts.lora(
                      fontSize: 11.5, fontWeight: FontWeight.w700, color: QC.greenMid)),
            ]),
            const SizedBox(height: 12),
            Text(s.soru,
                style: GoogleFonts.lora(
                    fontSize: 18, fontWeight: FontWeight.w800, color: QC.greenDark, height: 1.35)),
            const SizedBox(height: 16),
            if (s.cevap.isNotEmpty) ...[
              Text('Kısa Cevap',
                  style: GoogleFonts.lora(
                      fontSize: 12, fontWeight: FontWeight.w700, color: QC.gold)),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: Color(0xFFFAF7F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: QC.greenPale.withAlpha(160))),
                child: Text(s.cevap,
                    style: GoogleFonts.lora(fontSize: 15, height: 1.55, color: QC.greenDark)),
              ),
            ],
            if (s.detay.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text('Açıklama',
                  style: GoogleFonts.lora(
                      fontSize: 12, fontWeight: FontWeight.w700, color: QC.gold)),
              const SizedBox(height: 5),
              Text(s.detay,
                  style: GoogleFonts.lora(fontSize: 14, height: 1.6, color: QC.greenDark)),
            ],
            const SizedBox(height: 16),
            Text(
                'Kısa içerik amaçlıdır; mezhep ve fetva farklılıkları olabilir. Detay için ehil bir hocaya/Diyanet\'e danışılmalıdır.',
                style: GoogleFonts.lora(
                    fontSize: 10.5, fontStyle: FontStyle.italic, color: QC.greenMid, height: 1.4)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
