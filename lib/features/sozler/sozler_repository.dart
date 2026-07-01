// Hadis & Özlü Sözler — veri deposu. Offline asset.
import 'dart:convert';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;

class Soz {
  final bool isHadis; // true: hadis, false: özlü söz
  final String metin;
  final String kaynak;
  const Soz(this.isHadis, this.metin, this.kaynak);
}

// Büyük hadis kaynakları (Kütüb-i Sitte + öne çıkanlar). Sıra = öncelik.
const List<String> kHadisKaynaklari = [
  'Buhârî', 'Müslim', 'Tirmizî', 'Ebû Dâvûd', 'Nesâî', 'İbn Mâce',
  'Ahmed b. Hanbel', 'Diğer Kaynaklar',
];

// Bir hadisin kaynak metninden ana koleksiyonu belirler.
String hadisKaynagi(String kaynak) {
  if (kaynak.contains('Buhârî')) return 'Buhârî';
  if (kaynak.contains('Müslim')) return 'Müslim';
  if (kaynak.contains('Tirmizî')) return 'Tirmizî';
  if (kaynak.contains('Ebû Dâvûd')) return 'Ebû Dâvûd';
  if (kaynak.contains('Nesâî')) return 'Nesâî';
  if (kaynak.contains('İbn Mâce')) return 'İbn Mâce';
  if (kaynak.contains('Ahmed')) return 'Ahmed b. Hanbel';
  return 'Diğer Kaynaklar';
}

// Arka plan isolate'inde parse (açılışta ana thread'i bloklamaz)
List<Soz> _parseSozler(String raw) => (jsonDecode(raw) as List)
    .map((e) => Soz(e['t'] == 'h', e['m'] as String, e['k'] as String))
    .toList();

class SozlerRepository {
  SozlerRepository._();
  static final SozlerRepository instance = SozlerRepository._();

  List<Soz> _all = const [];
  bool get isLoaded => _all.isNotEmpty;
  List<Soz> get all => _all;

  Future<void>? _loading;
  Future<void> ensureLoaded() {
    if (isLoaded) return Future.value();
    return _loading ??= () async {
      final raw = await rootBundle.loadString('assets/data/sozler.json');
      _all = await compute(_parseSozler, raw);
    }();
  }

  // Günün sözü: tarihe göre deterministik (her gün aynı, her gün değişir)
  Soz ofDay([DateTime? date]) {
    final d = date ?? DateTime.now();
    final dayIndex = DateTime(d.year, d.month, d.day)
        .difference(DateTime(2000, 1, 1))
        .inDays;
    return _all[dayIndex % _all.length];
  }

  // Günün hadisi (sadece hadisler arasından)
  Soz hadisOfDay([DateTime? date]) {
    final hadisler = _all.where((s) => s.isHadis).toList();
    final d = date ?? DateTime.now();
    final dayIndex =
        DateTime(d.year, d.month, d.day).difference(DateTime(2000, 1, 1)).inDays;
    return hadisler[dayIndex % hadisler.length];
  }
}
