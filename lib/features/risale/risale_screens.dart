import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';
import 'risale_repository.dart';

// ── Ana ekran: arama + kitap listesi ──
class RisaleHomeScreen extends StatefulWidget {
  const RisaleHomeScreen({super.key});
  @override
  State<RisaleHomeScreen> createState() => _RisaleHomeScreenState();
}

class _RisaleHomeScreenState extends State<RisaleHomeScreen> {
  final _repo = RisaleRepository.instance;
  final _ctrl = TextEditingController();
  Timer? _debounce;
  String _q = '';
  bool _searching = false;
  List<RisaleHit> _results = [];
  List<RisaleBookInfo> _books = [];

  @override
  void initState() {
    super.initState();
    _repo.index().then((v) {
      if (mounted) setState(() => _books = v);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _q = v;
    _debounce?.cancel();
    if (v.trim().length < 3) {
      setState(() {
        _results = [];
        _searching = false;
      });
      return;
    }
    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      final hits = await _repo.search(v);
      if (!mounted || v != _q) return;
      setState(() {
        _results = hits;
        _searching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final searching = _q.trim().length >= 3;
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Risale-i Nur Külliyatı')),
      body: Column(children: [
        Container(
          color: QC.greenDark,
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: TextField(
            controller: _ctrl,
            onChanged: _onChanged,
            style: GoogleFonts.lora(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Konu/kelime ara (iman, haşir, ihlas…)',
              hintStyle: GoogleFonts.lora(color: QC.greenPale, fontSize: 13.5),
              prefixIcon: const Icon(Icons.search_rounded, color: QC.goldLight),
              suffixIcon: _q.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, color: QC.greenPale),
                      onPressed: () {
                        _ctrl.clear();
                        _onChanged('');
                      })
                  : null,
              filled: true,
              fillColor: QC.greenMain.withAlpha(120),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 2),
            ),
          ),
        ),
        Expanded(child: searching ? _resultsView() : _bookList()),
      ]),
    );
  }

  Widget _bookList() {
    if (_books.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: QC.greenMain));
    }
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Text('Bediüzzaman Said Nursî — Risale-i Nur Külliyatı',
            style: GoogleFonts.lora(
                fontSize: 14, fontWeight: FontWeight.w700, color: QC.greenDark)),
        const SizedBox(height: 4),
        Text('15 kitap · tam metin. Yukarıdan tüm külliyatta konu araması yapabilirsin.',
            style: GoogleFonts.lora(fontSize: 12, color: QC.greenMid, height: 1.4)),
        const SizedBox(height: 14),
        ..._books.asMap().entries.map((e) => _bookTile(e.key + 1, e.value)),
      ],
    );
  }

  Widget _bookTile(int no, RisaleBookInfo b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: QC.greenPale.withAlpha(160)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: QC.greenMain,
          child: Text('$no',
              style: GoogleFonts.lora(
                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
        ),
        title: Text(b.name,
            style: GoogleFonts.lora(
                fontSize: 15, fontWeight: FontWeight.w700, color: QC.greenDark)),
        subtitle: Text('${b.count} bölüm',
            style: GoogleFonts.lora(fontSize: 12, color: QC.greenMid)),
        trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => RisaleBookScreen(bookId: b.id))),
      ),
    );
  }

  Widget _resultsView() {
    if (_searching) {
      return const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircularProgressIndicator(color: QC.greenMain),
        SizedBox(height: 12),
        Text('Külliyat taranıyor…', style: TextStyle(color: QC.greenMid)),
      ]));
    }
    if (_results.isEmpty) {
      return Center(
          child: Text('"$_q" için sonuç bulunamadı.',
              style: GoogleFonts.lora(color: QC.greenMid)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _results.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
            child: Text('${_results.length} sonuç',
                style: GoogleFonts.lora(
                    fontSize: 12.5, fontWeight: FontWeight.w600, color: QC.greenMid)),
          );
        }
        final h = _results[i - 1];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: QC.greenPale.withAlpha(150)),
          ),
          child: ListTile(
            title: Text('${h.bookName} · ${h.sectionTitle}',
                style: GoogleFonts.lora(
                    fontSize: 12.5, fontWeight: FontWeight.w700, color: QC.greenMain)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(h.snippet,
                  style: GoogleFonts.lora(fontSize: 13, height: 1.4, color: QC.greenDark)),
            ),
            onTap: () async {
              final b = await _repo.book(h.bookId);
              if (!context.mounted) return;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RisaleSectionScreen(
                          book: b, index: h.sectionIndex)));
            },
          ),
        );
      },
    );
  }
}

// ── Kitap: bölüm listesi ──
class RisaleBookScreen extends StatelessWidget {
  final String bookId;
  const RisaleBookScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Bölümler')),
      body: FutureBuilder<RisaleBook>(
        future: RisaleRepository.instance.book(bookId),
        builder: (_, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator(color: QC.greenMain));
          }
          final b = snap.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: b.sections.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4, 6, 12),
                  child: Text(b.name,
                      style: GoogleFonts.lora(
                          fontSize: 18, fontWeight: FontWeight.w800, color: QC.greenDark)),
                );
              }
              final si = i - 1;
              return Container(
                margin: const EdgeInsets.only(bottom: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: QC.greenPale.withAlpha(150)),
                ),
                child: ListTile(
                  dense: true,
                  title: Text(b.sections[si].title,
                      style: GoogleFonts.lora(
                          fontSize: 14, fontWeight: FontWeight.w600, color: QC.greenDark)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RisaleSectionScreen(book: b, index: si))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ── Bölüm metni + Lügatçe (açıklama) ──
class RisaleSectionScreen extends StatefulWidget {
  final RisaleBook book;
  final int index;
  const RisaleSectionScreen({super.key, required this.book, required this.index});
  @override
  State<RisaleSectionScreen> createState() => _RisaleSectionScreenState();
}

class _RisaleSectionScreenState extends State<RisaleSectionScreen> {
  double _font = 16;
  bool _lugatceAcik = false;
  List<MapEntry<String, String>> _terimler = [];
  late int _index = widget.index;

  @override
  void initState() {
    super.initState();
    _loadTerimler();
  }

  Future<void> _loadTerimler() async {
    final t = await RisaleRepository.instance
        .terimlerInSection(widget.book.sections[_index].text);
    if (mounted) setState(() => _terimler = t);
  }

  void _goto(int i) {
    setState(() {
      _index = i;
      _lugatceAcik = false;
      _terimler = [];
    });
    _loadTerimler();
  }

  @override
  Widget build(BuildContext context) {
    final sec = widget.book.sections[_index];
    final hasPrev = _index > 0;
    final hasNext = _index < widget.book.sections.length - 1;
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        title: Text(sec.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
              tooltip: 'Yazıyı küçült',
              icon: const Icon(Icons.text_decrease_rounded),
              onPressed: () => setState(() => _font = (_font - 1).clamp(12, 26))),
          IconButton(
              tooltip: 'Yazıyı büyüt',
              icon: const Icon(Icons.text_increase_rounded),
              onPressed: () => setState(() => _font = (_font + 1).clamp(12, 26))),
        ],
      ),
      body: Column(children: [
        // Lügatçe / açıklama şeridi
        InkWell(
          onTap: _terimler.isEmpty ? null : () => setState(() => _lugatceAcik = !_lugatceAcik),
          child: Container(
            width: double.infinity,
            color: QC.greenMain.withAlpha(28),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            child: Row(children: [
              const Icon(Icons.menu_book_rounded, size: 17, color: QC.gold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    _terimler.isEmpty
                        ? 'Bu bölümde açıklanacak terim bulunamadı'
                        : 'Lügatçe · ${_terimler.length} kelimenin sade açıklaması',
                    style: GoogleFonts.lora(
                        fontSize: 12.5, fontWeight: FontWeight.w600, color: QC.greenDark)),
              ),
              if (_terimler.isNotEmpty)
                Icon(_lugatceAcik ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: QC.gold),
            ]),
          ),
        ),
        if (_lugatceAcik)
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            color: QC.greenBg,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                for (final e in _terimler)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: '${e.key}: ',
                            style: GoogleFonts.lora(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: QC.greenMain)),
                        TextSpan(
                            text: e.value,
                            style: GoogleFonts.lora(
                                fontSize: 13, color: QC.greenDark, height: 1.35)),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
            children: [
              SelectableText(
                sec.text,
                style: GoogleFonts.lora(
                    fontSize: _font, height: 1.75, color: QC.greenDark),
              ),
              const SizedBox(height: 20),
              Row(children: [
                if (hasPrev)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _goto(_index - 1),
                      icon: const Icon(Icons.chevron_left_rounded, size: 20),
                      label: const Text('Önceki'),
                    ),
                  ),
                if (hasPrev && hasNext) const SizedBox(width: 12),
                if (hasNext)
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: QC.greenMain, foregroundColor: Colors.white),
                      onPressed: () => _goto(_index + 1),
                      icon: const Icon(Icons.chevron_right_rounded, size: 20),
                      label: const Text('Sonraki'),
                    ),
                  ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}
