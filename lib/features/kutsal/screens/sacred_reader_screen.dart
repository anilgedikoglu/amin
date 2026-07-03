import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../quran/quran_theme.dart';
import '../models/sacred_models.dart';
import '../data/sacred_repository.dart';

class SacredReaderScreen extends StatefulWidget {
  final SacredText text;
  final int? initialBook;
  final int? initialChapter;
  final int? highlightVerse;
  const SacredReaderScreen({
    super.key,
    required this.text,
    this.initialBook,
    this.initialChapter,
    this.highlightVerse,
  });

  @override
  State<SacredReaderScreen> createState() => _SacredReaderScreenState();
}

class _SacredReaderScreenState extends State<SacredReaderScreen> {
  int? _book;
  int? _chapter;

  @override
  void initState() {
    super.initState();
    _book = widget.initialBook;
    _chapter = widget.initialChapter;
    // Tek bölümlü kitap (Kur'an sureleri) doğrudan ayetlere açılır.
    if (_book != null && _chapter == null && widget.text.books[_book!].singleChapter) {
      _chapter = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.text;
    String title = t.name;
    if (_book != null) {
      title = t.books[_book!].name;
      if (_chapter != null && !t.books[_book!].singleChapter) {
        title += ' ${_chapter! + 1}';
      }
    }

    Widget body;
    if (_book == null) {
      body = _BookList(text: t, onTap: (bi) {
        setState(() {
          _book = bi;
          _chapter = t.books[bi].singleChapter ? 0 : null;
        });
      });
    } else if (_chapter == null) {
      body = _ChapterGrid(
        book: t.books[_book!],
        onTap: (ci) => setState(() => _chapter = ci),
      );
    } else {
      body = _VerseList(
        book: t.books[_book!],
        chapterIndex: _chapter!,
        highlight: widget.highlightVerse,
      );
    }

    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis),
        leading: BackButton(onPressed: () {
          // İçeride bir kademe geri; en üstte ekrandan çık.
          if (_chapter != null && _book != null && !t.books[_book!].singleChapter) {
            setState(() => _chapter = null);
          } else if (_book != null) {
            setState(() {
              _book = null;
              _chapter = null;
            });
          } else {
            Navigator.pop(context);
          }
        }),
      ),
      body: body,
    );
  }
}

// ── Kitap listesi ──
class _BookList extends StatelessWidget {
  final SacredText text;
  final void Function(int) onTap;
  const _BookList({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String? hakkinda = kSacredRegistry
        .firstWhere((e) => e.id == text.id,
            orElse: () => const SacredEntry(id: '', name: '', religion: ''))
        .hakkinda;
    return Column(children: [
      _LicenseBar(text: text),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: text.books.length + (hakkinda != null ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, idx) {
            if (hakkinda != null && idx == 0) {
              return _HakkindaCard(name: text.name, hakkinda: hakkinda);
            }
            final i = hakkinda != null ? idx - 1 : idx;
            final b = text.books[i];
            final sub = b.singleChapter
                ? '${b.chapters[0].length} ayet'
                : '${b.chapters.length} bölüm';
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: QC.greenPale.withAlpha(160))),
                leading: CircleAvatar(
                  backgroundColor: QC.greenMain,
                  child: Text('${i + 1}',
                      style: GoogleFonts.lora(
                          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
                title: Text(b.name,
                    style: GoogleFonts.lora(
                        fontWeight: FontWeight.w700, color: QC.greenDark)),
                subtitle: Text(sub,
                    style: GoogleFonts.lora(fontSize: 12, color: QC.greenMid)),
                trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
                onTap: () => onTap(i),
              ),
            );
          },
        ),
      ),
    ]);
  }
}

// ── Bölüm ızgarası ──
class _ChapterGrid extends StatelessWidget {
  final SacredBook book;
  final void Function(int) onTap;
  const _ChapterGrid({required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10),
      itemCount: book.chapters.length,
      itemBuilder: (_, i) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTap(i),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: QC.greenPale.withAlpha(160))),
            alignment: Alignment.center,
            child: Text('${i + 1}',
                style: GoogleFonts.lora(
                    fontSize: 17, fontWeight: FontWeight.w700, color: QC.greenDark)),
          ),
        ),
      ),
    );
  }
}

// ── Ayet listesi ──
class _VerseList extends StatefulWidget {
  final SacredBook book;
  final int chapterIndex;
  final int? highlight;
  const _VerseList({required this.book, required this.chapterIndex, this.highlight});

  @override
  State<_VerseList> createState() => _VerseListState();
}

class _VerseListState extends State<_VerseList> {
  final _ctrl = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.highlight != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_ctrl.hasClients) return;
        // Yaklaşık konuma kaydır (her ayet ~96px).
        final off = (widget.highlight! * 96.0).clamp(0.0, _ctrl.position.maxScrollExtent);
        _ctrl.animateTo(off,
            duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verses = widget.book.chapters[widget.chapterIndex];
    return ListView.builder(
      controller: _ctrl,
      padding: const EdgeInsets.all(12),
      itemCount: verses.length,
      itemBuilder: (_, i) {
        final hl = widget.highlight == i;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: hl ? QC.goldLight.withAlpha(90) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: hl ? QC.gold : QC.greenPale.withAlpha(140),
                width: hl ? 1.6 : 1),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.only(right: 11, top: 1),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: QC.greenMain, borderRadius: BorderRadius.circular(20)),
              child: Text('${i + 1}',
                  style: GoogleFonts.lora(
                      color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
            Expanded(
              child: Text(verses[i],
                  style: GoogleFonts.lora(
                      fontSize: 15.5, height: 1.55, color: QC.greenDark)),
            ),
          ]),
        );
      },
    );
  }
}

// Metnin tarihçesini gösteren açılır kart (kitap listesinin en üstünde).
class _HakkindaCard extends StatelessWidget {
  final String name, hakkinda;
  const _HakkindaCard({required this.name, required this.hakkinda});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [QC.greenMain, QC.greenDark]),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: QC.goldLight,
          collapsedIconColor: QC.goldLight,
          leading: const Icon(Icons.auto_stories_rounded, color: QC.goldLight),
          title: Text('Hakkında — $name',
              style: GoogleFonts.lora(
                  fontSize: 14.5, fontWeight: FontWeight.w700, color: Colors.white)),
          subtitle: Text('Tarihçe · nasıl indirildi · kaç bölüm',
              style: GoogleFonts.lora(fontSize: 11.5, color: QC.greenPale)),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Text(hakkinda,
                  style: GoogleFonts.lora(
                      fontSize: 13.5, height: 1.7, color: const Color(0xFF374151))),
            ),
          ],
        ),
      ),
    );
  }
}

class _LicenseBar extends StatelessWidget {
  final SacredText text;
  const _LicenseBar({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: QC.greenMain.withAlpha(30),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Text('${text.religion} · ${text.license}',
          style: GoogleFonts.lora(fontSize: 11.5, color: QC.greenMid)),
    );
  }
}
