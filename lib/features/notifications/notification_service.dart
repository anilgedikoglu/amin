// Bildirim servisi — günlük hadis/söz push'u + (ileride) namaz hatırlatıcı.
// flutter_local_notifications + timezone ile zamanlanır.
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../prayer/prayer_service.dart';
import '../sozler/sozler_repository.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _inited = false;

  static const _kEnabled = 'notif_daily_enabled';
  static const _kHour = 'notif_daily_hour';
  static const _kMin = 'notif_daily_min';
  static const _kPrayer = 'notif_prayer_enabled';
  static const _dailyChannel = 'daily_quote';
  static const _prayerChannel = 'prayer_times';
  static const _dailyIdBase = 1000;
  static const _prayerIdBase = 2000;
  static const _religiousIdBase = 3000;
  static const _religiousChannel = 'religious_days';
  static const _kReligiousLast = 'notif_religious_last';

  // Dini özel günler → kutlama mesajları
  static const Map<String, String> _kutlama = {
    'Ramazan Bayramı':
        'Ramazan Bayramınız mübarek olsun! Gönlünüz huzurla, sofranız bereketle dolsun.',
    'Kurban Bayramı':
        'Kurban Bayramınız mübarek olsun! Kurbanlarınız kabul, gönlünüz tok olsun.',
    'Regaib Kandili':
        'Regaib Kandiliniz mübarek olsun. Rahmet kapıları açık; dualarınız kabul olsun.',
    'Mirac Kandili':
        'Mirac Kandiliniz mübarek olsun. Dualarınız arşa yükselsin, gönlünüz nurlansın.',
    'Berat Kandili':
        'Berat Kandiliniz mübarek olsun. Bu affedilme gecesinde tövbeleriniz kabul olsun.',
    'Kadir Gecesi':
        'Kadir Geceniz mübarek olsun. Bin aydan hayırlı bu gecede dualarınız makbul olsun.',
    'Mevlid Kandili':
        'Mevlid Kandiliniz mübarek olsun. Âlemlere rahmet Peygamberimize salât ü selam olsun.',
    'Aşure Günü':
        'Aşure Gününüz mübarek olsun. Paylaştıkça bereketlenen bir gün olsun.',
    'Hicri Yılbaşı':
        'Hicri yeni yılınız mübarek olsun. Yeni yıl hayır ve bereket getirsin.',
    'Üç Ayların Başlangıcı':
        'Üç aylar mübarek olsun. Receb, Şaban ve Ramazan; rahmet mevsimi hayırlı olsun.',
    'Ramazan Başlangıcı':
        'On bir ayın sultanı Ramazan mübarek olsun. Oruçlarınız kabul olsun.',
    'Arefe Günü':
        'Arefe Gününüz mübarek olsun. Bugün edilen dualar geri çevrilmez; bol bol dua edin.',
  };

  Future<void> init() async {
    if (_inited) return;
    tzdata.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios));
    _inited = true;
  }

  Future<bool> requestPermissions() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    bool granted = true;
    if (android != null) {
      granted = await android.requestNotificationsPermission() ?? false;
      await android.requestExactAlarmsPermission();
    }
    if (ios != null) {
      granted = await ios.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    return granted;
  }

  // ── Ayarlar ──
  Future<bool> isDailyEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kEnabled) ?? false;
  }

  Future<(int, int)> dailyTime() async {
    final p = await SharedPreferences.getInstance();
    return (p.getInt(_kHour) ?? 9, p.getInt(_kMin) ?? 0);
  }

  Future<void> setDailyEnabled(bool enabled, {int hour = 9, int minute = 0}) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kEnabled, enabled);
    await p.setInt(_kHour, hour);
    await p.setInt(_kMin, minute);
    if (enabled) {
      await scheduleDailyQuotes(hour, minute);
    } else {
      await cancelDaily();
    }
  }

  // Günlük farklı söz: önümüzdeki 30 günü tek tek planla.
  Future<void> scheduleDailyQuotes(int hour, int minute) async {
    await init();
    await cancelDaily();
    await SozlerRepository.instance.ensureLoaded();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _dailyChannel, 'Günün Hadisi',
        channelDescription: 'Her gün bir hadis veya özlü söz',
        importance: Importance.high, priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(),
    );
    final now = DateTime.now();
    for (var i = 0; i < 30; i++) {
      final day = DateTime(now.year, now.month, now.day, hour, minute)
          .add(Duration(days: i));
      if (day.isBefore(now)) continue;
      final soz = SozlerRepository.instance.ofDay(day);
      final title = soz.isHadis ? '🕌 Günün Hadisi' : '🕌 Günün Sözü';
      final body = '${soz.metin}\n— ${soz.kaynak}';
      try {
        await _plugin.zonedSchedule(
          _dailyIdBase + i,
          title,
          body,
          tz.TZDateTime.from(day, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        if (kDebugMode) debugPrint('schedule error: $e');
      }
    }
  }

  Future<void> cancelDaily() async {
    for (var i = 0; i < 31; i++) {
      await _plugin.cancel(_dailyIdBase + i);
    }
  }

  // ── Dini özel günler: 10 yıllık kutlama bildirimleri (sessizce) ──
  // Sabit hicri tarihler (ay, gün, isim)
  static const _dini = [
    [1, 1, 'Hicri Yılbaşı'],
    [1, 10, 'Aşure Günü'],
    [3, 12, 'Mevlid Kandili'],
    [7, 1, 'Üç Ayların Başlangıcı'],
    [7, 27, 'Mirac Kandili'],
    [8, 15, 'Berat Kandili'],
    [9, 1, 'Ramazan Başlangıcı'],
    [9, 27, 'Kadir Gecesi'],
    [10, 1, 'Ramazan Bayramı'],
    [12, 9, 'Arefe Günü'],
    [12, 10, 'Kurban Bayramı'],
  ];

  List<(DateTime, String)> _diniGunler(int fromYear, int toYear) {
    final out = <(DateTime, String)>[];
    final seen = <String>{};
    var d = DateTime(fromYear, 1, 1);
    final end = DateTime(toYear, 12, 31);
    final regaip = <int>{};
    while (!d.isAfter(end)) {
      final h = HijriCalendar.fromDate(d);
      for (final ev in _dini) {
        if (h.hMonth == ev[0] && h.hDay == ev[1]) {
          final key = '${ev[2]}-${h.hYear}';
          if (seen.add(key)) out.add((d, ev[2] as String));
        }
      }
      if (h.hMonth == 7 && d.weekday == DateTime.friday && !regaip.contains(h.hYear)) {
        regaip.add(h.hYear);
        out.add((d, 'Regaib Kandili'));
      }
      d = d.add(const Duration(days: 1));
    }
    out.sort((a, b) => a.$1.compareTo(b.$1));
    return out;
  }

  /// Önümüzdeki 10 yılın dini özel günlerini kutlama bildirimi olarak planlar.
  /// Ayda bir kendini tazeler (force ile hemen). Sessiz — kullanıcı işlemi gerekmez.
  Future<void> scheduleReligiousDays({bool force = false}) async {
    await init();
    final p = await SharedPreferences.getInstance();
    if (!force) {
      final last = p.getInt(_kReligiousLast) ?? 0;
      final gunFarki =
          (DateTime.now().millisecondsSinceEpoch - last) / 86400000.0;
      if (last > 0 && gunFarki < 25) return; // ayda bir yeniden planla
    }
    for (var i = 0; i < 220; i++) {
      await _plugin.cancel(_religiousIdBase + i);
    }
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _religiousChannel, 'Dini Özel Günler',
        channelDescription: 'Kandil ve bayram kutlama bildirimleri',
        importance: Importance.high, priority: Priority.high,
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(),
    );
    final now = DateTime.now();
    // iOS en fazla 64 bekleyen bildirim tutar; Android yüzlercesini.
    final cap = Platform.isIOS ? 60 : 200;
    final gunler = _diniGunler(now.year, now.year + 10);
    var idx = 0;
    for (final g in gunler) {
      if (idx >= cap) break;
      final at = DateTime(g.$1.year, g.$1.month, g.$1.day, 9, 0);
      if (!at.isAfter(now)) continue;
      final mesaj = _kutlama[g.$2] ?? '${g.$2} mübarek olsun.';
      try {
        await _plugin.zonedSchedule(
          _religiousIdBase + idx,
          '🌙 ${g.$2}',
          mesaj,
          tz.TZDateTime.from(at, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        idx++;
      } catch (e) {
        if (kDebugMode) debugPrint('dini gün schedule error: $e');
      }
    }
    await p.setInt(_kReligiousLast, DateTime.now().millisecondsSinceEpoch);
  }

  // ── Namaz vakti bildirimleri ──
  Future<bool> isPrayerEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kPrayer) ?? false;
  }

  Future<void> setPrayerEnabled(bool enabled) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kPrayer, enabled);
    if (enabled) {
      await schedulePrayerReminders();
    } else {
      await cancelPrayer();
    }
  }

  // Önümüzdeki 7 gün × 5 vakit (Güneş hariç) bildirim planla.
  Future<void> schedulePrayerReminders() async {
    await init();
    await cancelPrayer();
    final svc = PrayerService.instance;
    await svc.ensureLoaded();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _prayerChannel, 'Namaz Vakitleri',
        channelDescription: 'Namaz vakti girdiğinde hatırlatma',
        importance: Importance.high, priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    final city = svc.selected.name;
    final now = svc.cityNow();
    var id = _prayerIdBase;
    for (var d = 0; d < 7; d++) {
      final day = DateTime(now.year, now.month, now.day).add(Duration(days: d));
      final p = svc.timesFor(day);
      final vakitler = [
        MapEntry('İmsak', p.imsak), MapEntry('Öğle', p.ogle),
        MapEntry('İkindi', p.ikindi), MapEntry('Akşam', p.aksam),
        MapEntry('Yatsı', p.yatsi),
      ];
      for (final v in vakitler) {
        if (v.value.isBefore(now)) continue;
        try {
          await _plugin.zonedSchedule(
            id++,
            '🕌 ${v.key} Vakti',
            '$city için ${v.key} vakti girdi.',
            tz.TZDateTime.from(v.value, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        } catch (e) {
          if (kDebugMode) debugPrint('prayer schedule error: $e');
        }
        if (id - _prayerIdBase > 40) return; // güvenlik sınırı
      }
    }
  }

  Future<void> cancelPrayer() async {
    for (var i = 0; i < 45; i++) {
      await _plugin.cancel(_prayerIdBase + i);
    }
  }

  // Anında test bildirimi (ayarlar ekranında "Örnek gönder")
  Future<void> showTest() async {
    await init();
    await SozlerRepository.instance.ensureLoaded();
    final soz = SozlerRepository.instance.ofDay();
    await _plugin.show(
      999,
      soz.isHadis ? '🕌 Günün Hadisi' : '🕌 Günün Sözü',
      '${soz.metin}\n— ${soz.kaynak}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _dailyChannel, 'Günün Hadisi',
          channelDescription: 'Her gün bir hadis veya özlü söz',
          importance: Importance.high, priority: Priority.high,
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
