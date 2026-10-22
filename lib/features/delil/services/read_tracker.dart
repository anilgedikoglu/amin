import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks which Delil cards the user has opened/read.
/// Singleton; call [init] once at app startup.
class ReadTracker {
  ReadTracker._();
  static final ReadTracker instance = ReadTracker._();

  static const _key = 'read_ids';

  /// Notifier so widgets can reactively rebuild when a card is marked read.
  final readIds = ValueNotifier<Set<String>>({});

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];
    readIds.value = Set<String>.from(saved);
  }

  bool isRead(String id) => readIds.value.contains(id);

  Future<void> markRead(String id) async {
    if (readIds.value.contains(id)) return;
    final updated = <String>{...readIds.value, id};
    readIds.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, updated.toList());
  }
}
