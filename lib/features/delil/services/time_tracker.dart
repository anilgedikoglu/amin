import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Modül bazında okuma süresini (ms) takip eder.
/// Singleton; [init]'i uygulama başlangıcında bir kez çağır.
class TimeTracker {
  TimeTracker._();
  static final TimeTracker instance = TimeTracker._();

  static const _prefix = 'read_time_';

  /// Her modülün toplam okuma süresi (ms).
  final timeMs = ValueNotifier<Map<String, int>>({
    'delil':  0,
    'mucize': 0,
    'cevap':  0,
    'soz':    0,
  });

  // Açık oturumlar: modül adı → başlangıç timestamp (ms)
  final _starts = <String, int>{};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    timeMs.value = {
      'delil':  prefs.getInt('${_prefix}delil')  ?? 0,
      'mucize': prefs.getInt('${_prefix}mucize') ?? 0,
      'cevap':  prefs.getInt('${_prefix}cevap')  ?? 0,
      'soz':    prefs.getInt('${_prefix}soz')    ?? 0,
    };
  }

  /// Bir kart açıldığında çağrılır.
  void startSession(String module) {
    _starts[module] = DateTime.now().millisecondsSinceEpoch;
  }

  /// Kart kapandığında (dispose) çağrılır; 3 sn altı yoksayılır.
  Future<void> endSession(String module) async {
    final start = _starts.remove(module);
    if (start == null) return;
    final elapsed = DateTime.now().millisecondsSinceEpoch - start;
    if (elapsed < 3000) return; // tesadüfi dokunuşları say ma

    final next = Map<String, int>.from(timeMs.value);
    next[module] = (next[module] ?? 0) + elapsed;
    timeMs.value = next;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${_prefix}$module', next[module]!);
  }
}
