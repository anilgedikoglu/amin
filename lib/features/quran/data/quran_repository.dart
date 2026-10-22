// Kur'an feature — veri deposu.
// Arapça + Türkçe okunuş gömülü (quran.json). Mealler (çeviriler) ayrı
// dosyalardan (trans/{id}.json) SEÇİME GÖRE lazy yüklenir. İnternet GEREKMEZ.
import 'dart:convert';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter/services.dart' show rootBundle;
import '../models/quran_models.dart';
import 'meal_registry.dart';

class SearchResult {
  final Surah surah;
  final Ayah ayah;
  final bool matchedArabic;
  final String matchedMeal; // eşleşen mealin id'si ('' = arapça/okunuş)
  const SearchResult(this.surah, this.ayah, this.matchedArabic, this.matchedMeal);
}

List<Surah> _parseSurahs(String raw) => (jsonDecode(raw) as List)
    .map((e) => Surah.fromJson(e as Map<String, dynamic>))
    .toList();

Map<String, dynamic> _parseJson(String raw) => jsonDecode(raw) as Map<String, dynamic>;

class QuranRepository {
  QuranRepository._();
  static final QuranRepository instance = QuranRepository._();

  List<Surah>? _surahs;
  Map<String, dynamic>? _core; // { "1": {"ar":[...], "ok":[...]} }
  final Map<String, Map<String, dynamic>> _trans = {}; // id → { "1": [...] }

  bool get isLoaded => _surahs != null && _core != null;

  Future<void>? _loading;
  Future<void> ensureLoaded() {
    if (isLoaded) return Future.value();
    return _loading ??= _doLoad();
  }

  Future<void> _doLoad() async {
    final sRaw = await rootBundle.loadString('assets/quran/surahs.json');
    final cRaw = await rootBundle.loadString('assets/quran/quran.json');
    _surahs = await compute(_parseSurahs, sRaw);
    _core = await compute(_parseJson, cRaw);
    // Varsayılan meal her zaman hazır olsun
    await ensureMeals(const [kDefaultMeal]);
  }

  // Seçili meal dosyalarını (yüklenmemişse) yükle
  final Map<String, Future<void>> _mealLoading = {};
  Future<void> ensureMeals(List<String> ids) async {
    await Future.wait(ids.map(_ensureMeal));
  }

  Future<void> _ensureMeal(String id) {
    if (_trans.containsKey(id)) return Future.value();
    return _mealLoading[id] ??= () async {
      try {
        final raw = await rootBundle.loadString('assets/quran/trans/$id.json');
        _trans[id] = await compute(_parseJson, raw);
      } catch (_) {
        _trans[id] = const {};
      }
    }();
  }

  List<Surah> get surahs => _surahs ?? const [];
  Surah surahById(int id) => surahs.firstWhere((s) => s.id == id);

  // Bir mealin belirli sure-ayet metni (yüklüyse)
  String _mealText(String id, int surahId, int i) {
    final block = _trans[id]?['$surahId'];
    if (block is List && i < block.length) return block[i] as String;
    return '';
  }

  Map<String, String> _translationsFor(int surahId, int i, List<String> meals) {
    final m = <String, String>{};
    for (final id in meals) {
      m[id] = _mealText(id, surahId, i);
    }
    return m;
  }

  List<Ayah> ayahsOf(int surahId, List<String> meals) {
    final block = _core?['$surahId'] as Map<String, dynamic>?;
    if (block == null) return const [];
    final ar = (block['ar'] as List).cast<String>();
    final ok = (block['ok'] as List?)?.cast<String>() ?? const [];
    return List.generate(
      ar.length,
      (i) => Ayah(
        surahId: surahId,
        number: i + 1,
        arabic: ar[i],
        okunus: i < ok.length ? ok[i] : '',
        translations: _translationsFor(surahId, i, meals),
      ),
    );
  }

  Ayah ayahAt(int surahId, int number, List<String> meals) {
    final block = _core!['$surahId'] as Map<String, dynamic>;
    final ar = (block['ar'] as List).cast<String>();
    final ok = (block['ok'] as List?)?.cast<String>() ?? const [];
    final i = number - 1;
    return Ayah(
      surahId: surahId,
      number: number,
      arabic: ar[i],
      okunus: i < ok.length ? ok[i] : '',
      translations: _translationsFor(surahId, i, meals),
    );
  }

  // Sure adı + seçili meal(ler) + okunuş + Arapça içinde arama.
  List<SearchResult> search(String query, List<String> meals, {int limit = 60}) {
    final q = _normalize(query.trim());
    if (q.isEmpty) return const [];
    final results = <SearchResult>[];

    for (final s in surahs) {
      if (_normalize(s.turkishName).contains(q) ||
          _normalize(s.englishName).contains(q)) {
        results.add(SearchResult(s, ayahAt(s.id, 1, meals), false, ''));
        if (results.length >= limit) return results;
      }
    }

    for (final s in surahs) {
      final block = _core!['${s.id}'] as Map<String, dynamic>;
      final ar = (block['ar'] as List).cast<String>();
      final ok = (block['ok'] as List?)?.cast<String>() ?? const [];
      for (var i = 0; i < ar.length; i++) {
        String matchedMeal = '';
        bool matched = false;
        // Seçili meallerde ara
        for (final id in meals) {
          final t = _mealText(id, s.id, i);
          if (t.isNotEmpty && _normalize(t).contains(q)) {
            matched = true;
            matchedMeal = id;
            break;
          }
        }
        bool inAr = false;
        if (!matched) {
          if (i < ok.length && _normalize(ok[i]).contains(q)) {
            matched = true;
          } else if (ar[i].contains(query.trim())) {
            matched = true;
            inAr = true;
          }
        }
        if (matched) {
          results.add(SearchResult(
              s, ayahAt(s.id, i + 1, meals), inAr, matchedMeal));
          if (results.length >= limit) return results;
        }
      }
    }
    return results;
  }

  String _normalize(String s) {
    s = s.toLowerCase();
    const map = {
      'â': 'a', 'î': 'i', 'û': 'u', 'ô': 'o', 'ê': 'e',
      'ç': 'c', 'ğ': 'g', 'ı': 'i', 'ö': 'o', 'ş': 's', 'ü': 'u',
    };
    final sb = StringBuffer();
    for (final ch in s.split('')) {
      sb.write(map[ch] ?? ch);
    }
    return sb.toString();
  }
}
