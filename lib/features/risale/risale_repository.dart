// Risale-i Nur Külliyatı — tam metin okuyucu + arama + lügatçe.
// Veri: assets/risale/index.json + <kitap>.json (kitap başına bölümler) + lugatce.json
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class RisaleSection {
  final String title, text;
  const RisaleSection(this.title, this.text);
}

class RisaleBook {
  final String id, name;
  final List<RisaleSection> sections;
  const RisaleBook(this.id, this.name, this.sections);
}

class RisaleBookInfo {
  final String id, name;
  final int count;
  const RisaleBookInfo(this.id, this.name, this.count);
}

class RisaleHit {
  final String bookId, bookName, sectionTitle, snippet;
  final int sectionIndex;
  const RisaleHit(this.bookId, this.bookName, this.sectionIndex,
      this.sectionTitle, this.snippet);
}

RisaleBook _parseBook(String raw) {
  final j = jsonDecode(raw) as Map<String, dynamic>;
  final secs = (j['sections'] as List)
      .map((s) => RisaleSection(s['n'] as String, s['t'] as String))
      .toList();
  return RisaleBook(j['id'] as String, j['name'] as String, secs);
}

String risaleFold(String s) {
  final b = StringBuffer();
  for (final r in s.toLowerCase().runes) {
    switch (r) {
      case 0x131:
      case 0x130:
        b.writeCharCode(0x69);
        break;
      case 0x15F:
        b.writeCharCode(0x73);
        break;
      case 0x11F:
        b.writeCharCode(0x67);
        break;
      case 0xE7:
        b.writeCharCode(0x63);
        break;
      case 0xFC:
        b.writeCharCode(0x75);
        break;
      case 0xF6:
        b.writeCharCode(0x6F);
        break;
      default:
        b.writeCharCode(r);
    }
  }
  return b.toString();
}

class RisaleRepository {
  RisaleRepository._();
  static final RisaleRepository instance = RisaleRepository._();

  List<RisaleBookInfo>? _index;
  final Map<String, RisaleBook> _books = {};
  Map<String, String>? _lugatce;

  Future<List<RisaleBookInfo>> index() async {
    if (_index != null) return _index!;
    final raw = await rootBundle.loadString('assets/risale/index.json');
    final list = (jsonDecode(raw) as List)
        .map((e) => RisaleBookInfo(
            e['id'] as String, e['name'] as String, e['count'] as int))
        .toList();
    _index = list;
    return list;
  }

  Future<RisaleBook> book(String id) async {
    if (_books.containsKey(id)) return _books[id]!;
    final raw = await rootBundle.loadString('assets/risale/$id.json');
    final b = await compute(_parseBook, raw);
    _books[id] = b;
    return b;
  }

  Future<Map<String, String>> lugatce() async {
    if (_lugatce != null) return _lugatce!;
    final raw = await rootBundle.loadString('assets/risale/lugatce.json');
    _lugatce =
        (jsonDecode(raw) as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String));
    return _lugatce!;
  }

  /// Bir bölüm metninde geçen lügatçe terimlerini (bulunanları) döndürür.
  Future<List<MapEntry<String, String>>> terimlerInSection(String text) async {
    final lug = await lugatce();
    final folded = risaleFold(text);
    final found = <MapEntry<String, String>>[];
    for (final e in lug.entries) {
      final t = risaleFold(e.key);
      // kelime başı eşleşme: "acz" → "aczini" yakalar
      if (RegExp('(^|[^a-z0-9])${RegExp.escape(t)}').hasMatch(folded)) {
        found.add(e);
      }
    }
    found.sort((a, b) => a.key.compareTo(b.key));
    return found;
  }

  /// Tüm külliyatta arama. İlk aramada tüm kitaplar yüklenir (cache).
  Future<List<RisaleHit>> search(String query, {int limit = 200}) async {
    final q = risaleFold(query.trim());
    if (q.length < 3) return [];
    final re = RegExp('(^|[^a-z0-9])${RegExp.escape(q)}');
    final idx = await index();
    final hits = <RisaleHit>[];
    for (final info in idx) {
      final b = await book(info.id);
      for (var si = 0; si < b.sections.length; si++) {
        final sec = b.sections[si];
        final folded = risaleFold(sec.text);
        if (!re.hasMatch(folded)) continue;
        // snippet: eşleşme çevresi
        final pos = folded.indexOf(q);
        final start = (pos - 45).clamp(0, sec.text.length);
        final end = (pos + 90).clamp(0, sec.text.length);
        var snip = sec.text.substring(start, end).replaceAll('\n', ' ').trim();
        if (start > 0) snip = '…$snip';
        if (end < sec.text.length) snip = '$snip…';
        hits.add(RisaleHit(info.id, info.name, si, sec.title, snip));
        if (hits.length >= limit) return hits;
      }
    }
    return hits;
  }
}
