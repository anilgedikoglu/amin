import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/sacred_models.dart';
import 'term_bridge.dart';

/// Kayıt defteri: uygulamadaki kutsal metinler.
/// `asset` doğrudan dosyadan; `from`+`bookRange` ise başka metnin alt kümesi (sanal).
class SacredEntry {
  final String id, name, religion;
  final String? asset;
  final String? from; // sanal metin için kaynak id
  final List<int>? bookRange; // [start, end) — from içindeki kitap aralığı
  final String? overrideLicense;
  const SacredEntry({
    required this.id,
    required this.name,
    required this.religion,
    this.asset,
    this.from,
    this.bookRange,
    this.overrideLicense,
  });
}

const List<SacredEntry> kSacredRegistry = [
  SacredEntry(
      id: 'quran',
      name: "Kur'an-ı Kerim",
      religion: 'İslam',
      asset: 'assets/sacred/quran.json'),
  SacredEntry(
      id: 'bible',
      name: 'İncil (Kitab-ı Mukaddes)',
      religion: 'Hristiyanlık',
      asset: 'assets/sacred/bible.json'),
  SacredEntry(
      id: 'tevrat',
      name: 'Tevrat (Tora)',
      religion: 'Yahudilik',
      from: 'bible',
      bookRange: [0, 5],
      overrideLicense: 'Public Domain — KJV (Tevrat: ilk beş kitap)'),
  SacredEntry(
      id: 'gita',
      name: 'Bhagavad Gita',
      religion: 'Hinduizm',
      asset: 'assets/sacred/gita.json'),
  SacredEntry(
      id: 'dhammapada',
      name: 'Dhammapada',
      religion: 'Budizm',
      asset: 'assets/sacred/dhammapada.json'),
  SacredEntry(
      id: 'tao',
      name: 'Tao Te Ching',
      religion: 'Taoizm',
      asset: 'assets/sacred/tao.json'),
  SacredEntry(
      id: 'analects',
      name: 'Konfüçyüs — Analektler',
      religion: 'Konfüçyüsçülük',
      asset: 'assets/sacred/analects.json'),
];

/// compute() içinde çalışır — ağır JSON parse arka plan isolate'inde.
SacredText _parse(String raw) =>
    SacredText.fromJson(jsonDecode(raw) as Map<String, dynamic>);

/// Türkçe-duyarsız eşleştirme için sadeleştirme (büyük/küçük + aksan).
String _fold(String s) {
  final b = StringBuffer();
  for (final r in s.toLowerCase().runes) {
    switch (r) {
      case 0x131: // ı
      case 0x130: // İ
        b.writeCharCode(0x69); // i
        break;
      case 0x15F: // ş
        b.writeCharCode(0x73); // s
        break;
      case 0x11F: // ğ
        b.writeCharCode(0x67); // g
        break;
      case 0xE7: // ç
        b.writeCharCode(0x63); // c
        break;
      case 0xFC: // ü
        b.writeCharCode(0x75); // u
        break;
      case 0xF6: // ö
        b.writeCharCode(0x6F); // o
        break;
      default:
        b.writeCharCode(r);
    }
  }
  return b.toString();
}

class SacredRepository {
  SacredRepository._();
  static final SacredRepository instance = SacredRepository._();

  final Map<String, SacredText> _cache = {};

  SacredEntry entry(String id) =>
      kSacredRegistry.firstWhere((e) => e.id == id);

  bool isLoaded(String id) => _cache.containsKey(id);

  Future<SacredText> load(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;
    final e = entry(id);
    SacredText text;
    if (e.asset != null) {
      final raw = await rootBundle.loadString(e.asset!);
      text = await compute(_parse, raw);
    } else {
      // Sanal metin: kaynak metnin kitap aralığı.
      final base = await load(e.from!);
      final r = e.bookRange ?? [0, base.books.length];
      text = SacredText(
        id: e.id,
        name: e.name,
        religion: e.religion,
        lang: base.lang,
        license: e.overrideLicense ?? base.license,
        books: base.books.sublist(r[0], r[1]),
      );
    }
    _cache[id] = text;
    return text;
  }

  Future<void> ensureAll() async {
    for (final e in kSacredRegistry) {
      await load(e.id);
    }
  }

  /// Tüm (veya seçili) metinlerde birleşik arama. Terim köprüsüyle TR↔EN.
  Future<List<SacredHit>> search(String query,
      {List<String>? ids, int limitPerText = 60}) async {
    final q = query.trim();
    if (q.length < 2) return [];
    final targets = ids ?? kSacredRegistry.map((e) => e.id).toList();
    // Kelime-başı eşleşme: "aşk" → "aşkı/aşkın" yakalar ama "başka" yakalamaz.
    final terms = expandQuery(q)
        .map(_fold)
        .where((t) => t.length >= 2)
        .map((t) => RegExp('(^|[^a-z0-9])${RegExp.escape(t)}'))
        .toList();
    final hits = <SacredHit>[];

    for (final id in targets) {
      final text = await load(id);
      var count = 0;
      outer:
      for (var bi = 0; bi < text.books.length; bi++) {
        final book = text.books[bi];
        for (var ci = 0; ci < book.chapters.length; ci++) {
          final verses = book.chapters[ci];
          for (var vi = 0; vi < verses.length; vi++) {
            final folded = _fold(verses[vi]);
            var matched = false;
            for (final re in terms) {
              if (re.hasMatch(folded)) {
                matched = true;
                break;
              }
            }
            if (!matched) continue;
            final ref = book.singleChapter
                ? '${book.name} ${vi + 1}'
                : '${book.name} ${ci + 1}:${vi + 1}';
            hits.add(SacredHit(
              textId: id,
              textName: text.name,
              religion: text.religion,
              bookIndex: bi,
              chapterIndex: ci,
              verseIndex: vi,
              ref: ref,
              verse: verses[vi],
            ));
            if (++count >= limitPerText) break outer;
          }
        }
      }
    }
    return hits;
  }
}
