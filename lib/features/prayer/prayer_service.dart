// Namaz vakitleri servisi — adhan paketi ile TAMAMEN OFFLINE hesaplama.
// Konum izni GEREKMEZ: kullanıcı şehir seçer (assets/data/cities.json).
import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class City {
  final String name;
  final double lat, lng;
  final int utc; // sabit UTC offset (TR=+3)
  const City(this.name, this.lat, this.lng, this.utc);
  factory City.fromJson(Map<String, dynamic> j) =>
      City(j['n'], (j['lat'] as num).toDouble(), (j['lng'] as num).toDouble(), j['utc']);
}

class DailyPrayers {
  final DateTime imsak, gunes, ogle, ikindi, aksam, yatsi;
  const DailyPrayers(this.imsak, this.gunes, this.ogle, this.ikindi, this.aksam, this.yatsi);

  List<MapEntry<String, DateTime>> get list => [
        MapEntry('İmsak', imsak),
        MapEntry('Güneş', gunes),
        MapEntry('Öğle', ogle),
        MapEntry('İkindi', ikindi),
        MapEntry('Akşam', aksam),
        MapEntry('Yatsı', yatsi),
      ];
}

class PrayerService {
  PrayerService._();
  static final PrayerService instance = PrayerService._();

  static const _kCity = 'prayer_city';
  List<City> _cities = const [];
  City? _selected;

  List<City> get cities => _cities;
  City get selected => _selected ?? _cities.first;

  Future<void> ensureLoaded() async {
    if (_cities.isNotEmpty) return;
    final raw = await rootBundle.loadString('assets/data/cities.json');
    _cities = (jsonDecode(raw) as List).map((e) => City.fromJson(e)).toList();
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kCity);
    _selected = _cities.firstWhere((c) => c.name == saved,
        orElse: () => _cities.firstWhere((c) => c.name == 'İstanbul',
            orElse: () => _cities.first));
  }

  Future<void> selectCity(City c) async {
    _selected = c;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCity, c.name);
  }

  // Belirli gün için vakitler (seçili şehir, sabit UTC offset → şehir yerel saati)
  DailyPrayers timesFor(DateTime day, {City? city}) {
    final c = city ?? selected;
    final coords = Coordinates(c.lat, c.lng);
    final params = CalculationMethod.turkey.getParameters();
    final pt = PrayerTimes(
      coords,
      DateComponents.from(day),
      params,
      utcOffset: Duration(hours: c.utc),
    );
    // utcOffset verildiğinde saatler UTC+offset olarak döner; yerel gösterim
    // için offset'i çıkarıp "duvar saati"ni alıyoruz.
    DateTime wall(DateTime t) => DateTime(day.year, day.month, day.day,
        t.toUtc().hour, t.toUtc().minute);
    return DailyPrayers(
      wall(pt.fajr), wall(pt.sunrise), wall(pt.dhuhr),
      wall(pt.asr), wall(pt.maghrib), wall(pt.isha),
    );
  }

  // Şehrin yerel "duvar saati" şimdi (cihaz UTC + şehir offset)
  DateTime cityNow() {
    final c = selected;
    final n = DateTime.now().toUtc().add(Duration(hours: c.utc));
    return DateTime(n.year, n.month, n.day, n.hour, n.minute, n.second);
  }

  // Verilen vakte kalan süre (ucuz; her saniye çağrılabilir)
  Duration remainingTo(DateTime time) => time.difference(cityNow());

  // Bugün için "sıradaki namaz" ve kalan süre (seçili şehir saati baz alınır)
  ({String name, DateTime time, Duration remaining})? nextPrayer() {
    final nowWall = cityNow();
    for (var addDay = 0; addDay < 2; addDay++) {
      final day = nowWall.add(Duration(days: addDay));
      final p = timesFor(DateTime(day.year, day.month, day.day));
      for (final e in [
        MapEntry('İmsak', p.imsak), MapEntry('Güneş', p.gunes),
        MapEntry('Öğle', p.ogle), MapEntry('İkindi', p.ikindi),
        MapEntry('Akşam', p.aksam), MapEntry('Yatsı', p.yatsi),
      ]) {
        if (e.value.isAfter(nowWall)) {
          return (name: e.key, time: e.value, remaining: e.value.difference(nowWall));
        }
      }
    }
    return null;
  }
}
