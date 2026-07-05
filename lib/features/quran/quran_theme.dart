// Kur'an feature — paylaşılan tema sabitleri.
// Amin ana uygulamasının renk paletini (AC) birebir korur.
import 'package:flutter/material.dart';

/// Uygulama geneli arka plan teması (Ayarlar'dan değiştirilir).
/// Sadece "sayfa arka planı" değişir; içerik kartları beyaz kaldığı için
/// tüm temalarda metin okunur. `notifier` değişince AminApp tüm ağacı tazeler.
class AppBgTheme {
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  static const List<String> adlar = [
    'Zümrüt Yeşil',
    'Sıcak Kum',
    'Gök Mavisi',
    'Gece (Okuma)',
  ];
  // Her tema: sayfa arka planı. Varsayılan: sıcak fildişi (yeşil hâkimiyetini
  // azaltmak ve bembeyaz göz yorgunluğunu gidermek için).
  static const List<Color> arkaplan = [
    Color(0xFFF3EEE3), // 0 sıcak fildişi (varsayılan)
    Color(0xFFf3ead6), // 1 sıcak kum
    Color(0xFFdbe7f2), // 2 gök mavisi
    Color(0xFF11201a), // 3 gece (siyaha yakın)
  ];

  static int get index => notifier.value.clamp(0, arkaplan.length - 1);
  static Color get bg => arkaplan[index];
  static bool get isDark => index == 3;
}

class QC {
  static const greenDark = Color(0xFF1a4731);
  static const greenMain = Color(0xFF2d6a4f);
  static const greenMid = Color(0xFF40916c);
  static const greenLight = Color(0xFF74c69d);
  static const greenPale = Color(0xFFb7e4c7);
  static Color get greenBg => AppBgTheme.bg;
  static const gold = Color(0xFFc9a84c);
  static const goldLight = Color(0xFFf0d080);
  static const brownDark = Color(0xFF5C3A1E);

  // Arapça Kur'an metni için gömülü font (offline garanti)
  static const arabicFont = 'AmiriQuran';
}
