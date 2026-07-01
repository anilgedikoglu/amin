// Kur'an feature — kullanıcı durumu (favoriler, son okunan, ayarlar).
// SharedPreferences ile kalıcı; mevcut Amin uygulamasıyla aynı yöntem.
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'meal_registry.dart';

class QuranPrefs extends ChangeNotifier {
  QuranPrefs._();
  static final QuranPrefs instance = QuranPrefs._();

  static const _kFavs = 'quran_favs';
  static const _kLastSurah = 'quran_last_surah';
  static const _kLastAyah = 'quran_last_ayah';
  static const _kFontScale = 'quran_font_scale';
  static const _kShowArabic = 'quran_show_arabic';
  static const _kShowOkunus = 'quran_show_okunus';
  static const _kShowMeal = 'quran_show_meal';
  static const _kMeals = 'quran_meals';

  SharedPreferences? _p;
  final Set<String> _favs = {};
  int? _lastSurah;
  int? _lastAyah;
  double _fontScale = 1.0;
  bool _showArabic = true;
  bool _showOkunus = true;
  bool _showMeal = true;
  List<String> _meals = const [kDefaultMeal];

  Future<void> ensureLoaded() async {
    if (_p != null) return;
    _p = await SharedPreferences.getInstance();
    _favs
      ..clear()
      ..addAll(_p!.getStringList(_kFavs) ?? const []);
    _lastSurah = _p!.getInt(_kLastSurah);
    _lastAyah = _p!.getInt(_kLastAyah);
    _fontScale = _p!.getDouble(_kFontScale) ?? 1.0;
    _showArabic = _p!.getBool(_kShowArabic) ?? true;
    _showOkunus = _p!.getBool(_kShowOkunus) ?? true;
    _showMeal = _p!.getBool(_kShowMeal) ?? true;
    final savedMeals = _p!.getStringList(_kMeals);
    if (savedMeals != null && savedMeals.isNotEmpty) {
      _meals = savedMeals.where((m) => kMeals.any((k) => k.id == m)).toList();
      if (_meals.isEmpty) _meals = const [kDefaultMeal];
    }
    notifyListeners();
  }

  // ── Favoriler ──
  List<String> get favorites => _favs.toList();
  bool isFavorite(String key) => _favs.contains(key);

  Future<void> toggleFavorite(String key) async {
    if (!_favs.add(key)) _favs.remove(key);
    await _p?.setStringList(_kFavs, _favs.toList());
    notifyListeners();
  }

  // ── Son okunan yer ──
  int? get lastSurah => _lastSurah;
  int? get lastAyah => _lastAyah;
  bool get hasLastRead => _lastSurah != null;

  Future<void> setLastRead(int surahId, int ayah) async {
    if (_lastSurah == surahId && _lastAyah == ayah) return;
    _lastSurah = surahId;
    _lastAyah = ayah;
    await _p?.setInt(_kLastSurah, surahId);
    await _p?.setInt(_kLastAyah, ayah);
    notifyListeners();
  }

  // ── Font ölçeği ──
  double get fontScale => _fontScale;
  Future<void> setFontScale(double v) async {
    _fontScale = v.clamp(0.8, 1.8);
    await _p?.setDouble(_kFontScale, _fontScale);
    notifyListeners();
  }

  Future<void> bumpFont(double delta) => setFontScale(_fontScale + delta);

  // ── Görünürlük toggle'ları ──
  bool get showArabic => _showArabic;
  bool get showOkunus => _showOkunus;
  bool get showMeal => _showMeal;

  Future<void> setShowArabic(bool v) async {
    if (!v && !(_showOkunus || _showMeal)) return; // en az biri açık kalsın
    _showArabic = v;
    await _p?.setBool(_kShowArabic, v);
    notifyListeners();
  }

  Future<void> setShowOkunus(bool v) async {
    if (!v && !(_showArabic || _showMeal)) return;
    _showOkunus = v;
    await _p?.setBool(_kShowOkunus, v);
    notifyListeners();
  }

  Future<void> setShowMeal(bool v) async {
    if (!v && !(_showArabic || _showOkunus)) return;
    _showMeal = v;
    await _p?.setBool(_kShowMeal, v);
    notifyListeners();
  }

  // ── Seçili meal(ler) ──
  List<String> get selectedMeals => List.unmodifiable(_meals);
  bool isMealSelected(String id) => _meals.contains(id);

  Future<void> toggleMeal(String id) async {
    final next = List<String>.from(_meals);
    if (next.contains(id)) {
      if (next.length == 1) return; // en az bir meal kalsın
      next.remove(id);
    } else {
      next.add(id);
    }
    await setMeals(next);
  }

  Future<void> setMeals(List<String> ids) async {
    _meals = ids.isEmpty ? const [kDefaultMeal] : ids;
    await _p?.setStringList(_kMeals, _meals);
    notifyListeners();
  }
}
