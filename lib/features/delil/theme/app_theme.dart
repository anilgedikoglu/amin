import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // AMIN yeşil/altın paletine uyarlandı (koyu yeşil tema).
  static const background = Color(0xFF123524); // koyu orman yeşili
  static const surface = Color(0xFF1A4731);    // amin greenDark
  static const cardBg = Color(0xFF1F5038);
  static const cardBorder = Color(0xFF2D6A4F); // amin greenMain

  static const gold = Color(0xFFC9A84C);       // amin gold
  static const goldLight = Color(0xFFF0D080);  // amin goldLight
  static const goldDim = Color(0xFF8A6A10);

  static const textPrimary = Color(0xFFF1FBF4);
  static const textSecondary = Color(0xFFB7E4C7); // amin greenPale
  static const textMuted = Color(0xFF7FB79A);

  // Primary aksan mordan yeşile çevrildi (amin markası)
  static const purple = Color(0xFF40916C);       // amin greenMid
  static const purpleLight = Color(0xFF74C69D);   // amin greenLight
  static const teal = Color(0xFF3A9B8C);
  static const green = Color(0xFF4E9A60);
  static const red = Color(0xFFB05050);
  static const blue = Color(0xFF2E8B74);   // amin uyumu: yeşil-teal
  static const amber = Color(0xFFD4851A);

  static const rose    = Color(0xFFB06A4A); // amin uyumu: bakır-gül
  static const indigo  = Color(0xFF2F7D6B); // amin uyumu: koyu teal
  static const copper  = Color(0xFFA0603A);
  static const lime    = Color(0xFF4A9A3A);
  static const cyan    = Color(0xFF2A8A9A);
  static const orange  = Color(0xFFB07020);

  static const tealLight = Color(0xFF4AB8A8);

  static const Map<String, Color> categoryColors = {
    'Felsefi ve Kelâmî Deliller':                      purple,
    'Bilimsel ve Doğa Üzerinden Deliller':             teal,
    'İman Hakikatleri ve Risale-i Nur Tarzı Deliller': amber,
    'Fıtrat, Ahlak ve İnsan Delilleri':                green,
    'İtirazlar ve Cevap Kartları':                     red,
    'Kâinat ve Günlük Hayat Delilleri':                blue,
    'Matematiksel ve Mantıksal Deliller':              orange,
    'Biyolojik Deliller':                              lime,
    'Fizik ve Kozmoloji Delilleri':                    cyan,
    'Astronomi Delilleri':                             indigo,
    'Estetik ve Anlam Delilleri':                      rose,
    'Tarihî Deliller':                                 copper,
    'Zihin ve Bilinç Delilleri':                       tealLight,
  };

  static const Map<String, Color> categoryColorsDim = {
    'Felsefi ve Kelâmî Deliller':                      Color(0xFF3D2F6A),
    'Bilimsel ve Doğa Üzerinden Deliller':             Color(0xFF1D4D46),
    'İman Hakikatleri ve Risale-i Nur Tarzı Deliller': Color(0xFF6A420D),
    'Fıtrat, Ahlak ve İnsan Delilleri':                Color(0xFF234D30),
    'İtirazlar ve Cevap Kartları':                     Color(0xFF582828),
    'Kâinat ve Günlük Hayat Delilleri':                Color(0xFF1D3758),
    'Matematiksel ve Mantıksal Deliller':              Color(0xFF583810),
    'Biyolojik Deliller':                              Color(0xFF234D1D),
    'Fizik ve Kozmoloji Delilleri':                    Color(0xFF15454D),
    'Astronomi Delilleri':                             Color(0xFF1D2558),
    'Estetik ve Anlam Delilleri':                      Color(0xFF502035),
    'Tarihî Deliller':                                 Color(0xFF50301D),
    'Zihin ve Bilinç Delilleri':                       Color(0xFF1D4A48),
  };

  static Color forCategory(String cat) =>
      categoryColors[cat] ?? purple;
  // Tile arka planı: aksan rengi yeşil zemine harmanlanır (amin uyumu).
  static Color dimForCategory(String cat) =>
      Color.alphaBlend(forCategory(cat).withOpacity(0.20), background);
}

class AppIcons {
  static const Map<String, IconData> categoryIcons = {
    'Felsefi ve Kelâmî Deliller': Icons.auto_stories_outlined,
    'Bilimsel ve Doğa Üzerinden Deliller': Icons.science_outlined,
    'İman Hakikatleri ve Risale-i Nur Tarzı Deliller': Icons.menu_book_outlined,
    'Fıtrat, Ahlak ve İnsan Delilleri': Icons.favorite_border,
    'İtirazlar ve Cevap Kartları': Icons.balance_outlined,
    'Kâinat ve Günlük Hayat Delilleri': Icons.nature_outlined,
    'Matematiksel ve Mantıksal Deliller': Icons.calculate_outlined,
    'Biyolojik Deliller': Icons.biotech_outlined,
    'Fizik ve Kozmoloji Delilleri': Icons.bolt_outlined,
    'Astronomi Delilleri': Icons.nights_stay_outlined,
    'Estetik ve Anlam Delilleri': Icons.palette_outlined,
    'Tarihî Deliller': Icons.history_edu_outlined,
    'Zihin ve Bilinç Delilleri': Icons.psychology_outlined,
  };

  static IconData forCategory(String cat) =>
      categoryIcons[cat] ?? Icons.lightbulb_outline;
}

class MucizeColors {
  static const Map<String, Color> categoryColors = {
    'Kur\'an\'ın metin, belagat ve korunma mucizeleri':            AppColors.tealLight,
    'Astronomi ve kozmoloji mucizeleri':                           AppColors.indigo,
    'Fizik, kimya ve element mucizeleri':                          AppColors.orange,
    'Yerbilim, atmosfer, meteoroloji ve okyanus mucizeleri':       AppColors.cyan,
    'Biyoloji, embriyoloji, tıp ve insan bedeni mucizeleri':       AppColors.green,
    'Hayvanlar, bitkiler ve ekoloji mucizeleri':                   AppColors.lime,
    'Matematiksel, istatistiksel ve şifre mucizeleri':             AppColors.purple,
    'Tarihsel, arkeolojik ve haber mucizeleri':                    AppColors.copper,
    'Hadislerde gelecek haberleri ve sosyal-teknolojik işaretler': AppColors.amber,
    'İbadet, hüküm, ahlak ve yaşam hikmetleri':                   AppColors.rose,
  };

  static const Map<String, Color> categoryColorsDim = {
    'Kur\'an\'ın metin, belagat ve korunma mucizeleri':            Color(0xFF1D4A48),
    'Astronomi ve kozmoloji mucizeleri':                           Color(0xFF1D2558),
    'Fizik, kimya ve element mucizeleri':                          Color(0xFF583810),
    'Yerbilim, atmosfer, meteoroloji ve okyanus mucizeleri':       Color(0xFF15454D),
    'Biyoloji, embriyoloji, tıp ve insan bedeni mucizeleri':       Color(0xFF234D30),
    'Hayvanlar, bitkiler ve ekoloji mucizeleri':                   Color(0xFF234D1D),
    'Matematiksel, istatistiksel ve şifre mucizeleri':             Color(0xFF3D2F6A),
    'Tarihsel, arkeolojik ve haber mucizeleri':                    Color(0xFF50301D),
    'Hadislerde gelecek haberleri ve sosyal-teknolojik işaretler': Color(0xFF6A420D),
    'İbadet, hüküm, ahlak ve yaşam hikmetleri':                   Color(0xFF502035),
  };

  static const Map<String, IconData> categoryIcons = {
    'Kur\'an\'ın metin, belagat ve korunma mucizeleri':            Icons.menu_book_outlined,
    'Astronomi ve kozmoloji mucizeleri':                           Icons.nights_stay_outlined,
    'Fizik, kimya ve element mucizeleri':                          Icons.science_outlined,
    'Yerbilim, atmosfer, meteoroloji ve okyanus mucizeleri':       Icons.terrain_outlined,
    'Biyoloji, embriyoloji, tıp ve insan bedeni mucizeleri':       Icons.favorite_border,
    'Hayvanlar, bitkiler ve ekoloji mucizeleri':                   Icons.eco_outlined,
    'Matematiksel, istatistiksel ve şifre mucizeleri':             Icons.calculate_outlined,
    'Tarihsel, arkeolojik ve haber mucizeleri':                    Icons.history_edu_outlined,
    'Hadislerde gelecek haberleri ve sosyal-teknolojik işaretler': Icons.format_quote_outlined,
    'İbadet, hüküm, ahlak ve yaşam hikmetleri':                   Icons.self_improvement_outlined,
  };

  static Color forCategory(String cat) =>
      categoryColors[cat] ?? AppColors.tealLight;
  static Color dimForCategory(String cat) =>
      Color.alphaBlend(forCategory(cat).withOpacity(0.20), AppColors.background);
  static IconData iconForCategory(String cat) =>
      categoryIcons[cat] ?? Icons.star_outline_rounded;

  // miracleType badge rengi
  static Color forMiracleType(String t) {
    if (t.contains('asli'))        return AppColors.gold;
    if (t.contains('bilimsel'))    return AppColors.cyan;
    if (t.contains('edebi'))       return AppColors.purple;
    if (t.contains('gayb'))        return AppColors.green;
    if (t.contains('hadis') || t.contains('siyer')) return AppColors.teal;
    if (t.contains('hikmet'))      return AppColors.rose;
    if (t.contains('manevi'))      return AppColors.indigo;
    if (t.contains('kıssa'))       return AppColors.blue;
    if (t.contains('tartışmalı') || t.contains('numerik')) return AppColors.amber;
    return AppColors.textMuted;
  }

  // miracleType kısa etiket
  static String labelForMiracleType(String t) {
    if (t.contains('asli'))        return 'Asli Mucize';
    if (t.contains('bilimsel'))    return 'Bilimsel İşaret';
    if (t.contains('edebi'))       return 'Edebî Mucize';
    if (t.contains('gayb'))        return 'Gaybî Haber';
    if (t.contains('hadis') || t.contains('siyer')) return 'Hadis Mucizesi';
    if (t.contains('hikmet'))      return 'Hikmet';
    if (t.contains('manevi'))      return 'Manevî';
    if (t.contains('kıssa'))       return 'Kıssa';
    if (t.contains('tartışmalı') || t.contains('numerik')) return 'Tartışmalı';
    return t;
  }
}

// ── Cevaplar renk/ikon sistemi ────────────────────────────────────────────────
class CevapColors {
  static const Map<String, Color> sectionColors = {
    'Metafizik, Kozmoloji ve İlk Sebep':                             AppColors.purple,
    'Bilim, Fizik ve Kozmoloji İtirazları':                          AppColors.indigo,
    'Evrim, Biyoloji ve Canlılık Soruları':                          AppColors.green,
    'Kötülük, Acı, Doğal Afet ve Çocuk Soruları':                   AppColors.red,
    "Kur'an, Vahiy, Mucize ve Metin Eleştirisi":                     AppColors.tealLight,
    'Hadis, Sünnet, Peygamberlik ve Tarih':                          AppColors.amber,
    'Ahlak, Adalet, Özgür İrade ve Sorumluluk':                      AppColors.orange,
    'Dinler, Mezhepler, Çoğulculuk ve Kurtuluş':                     AppColors.copper,
    'Psikoloji, Dinî Tecrübe, Dua ve Fıtrat':                        AppColors.cyan,
    'Modern Şüpheler: Deizm, Ateizm, Simülasyon, Yapay Zekâ':       AppColors.lime,
  };

  static const Map<String, Color> sectionColorsDim = {
    'Metafizik, Kozmoloji ve İlk Sebep':                             Color(0xFF3D2F6A),
    'Bilim, Fizik ve Kozmoloji İtirazları':                          Color(0xFF1D2558),
    'Evrim, Biyoloji ve Canlılık Soruları':                          Color(0xFF234D30),
    'Kötülük, Acı, Doğal Afet ve Çocuk Soruları':                   Color(0xFF582828),
    "Kur'an, Vahiy, Mucize ve Metin Eleştirisi":                     Color(0xFF1D4A48),
    'Hadis, Sünnet, Peygamberlik ve Tarih':                          Color(0xFF6A420D),
    'Ahlak, Adalet, Özgür İrade ve Sorumluluk':                      Color(0xFF583810),
    'Dinler, Mezhepler, Çoğulculuk ve Kurtuluş':                     Color(0xFF50301D),
    'Psikoloji, Dinî Tecrübe, Dua ve Fıtrat':                        Color(0xFF15454D),
    'Modern Şüpheler: Deizm, Ateizm, Simülasyon, Yapay Zekâ':       Color(0xFF234D1D),
  };

  static const Map<String, IconData> sectionIcons = {
    'Metafizik, Kozmoloji ve İlk Sebep':                             Icons.auto_awesome_outlined,
    'Bilim, Fizik ve Kozmoloji İtirazları':                          Icons.science_outlined,
    'Evrim, Biyoloji ve Canlılık Soruları':                          Icons.biotech_outlined,
    'Kötülük, Acı, Doğal Afet ve Çocuk Soruları':                   Icons.thunderstorm_outlined,
    "Kur'an, Vahiy, Mucize ve Metin Eleştirisi":                     Icons.menu_book_outlined,
    'Hadis, Sünnet, Peygamberlik ve Tarih':                          Icons.history_edu_outlined,
    'Ahlak, Adalet, Özgür İrade ve Sorumluluk':                      Icons.balance_outlined,
    'Dinler, Mezhepler, Çoğulculuk ve Kurtuluş':                     Icons.diversity_3_outlined,
    'Psikoloji, Dinî Tecrübe, Dua ve Fıtrat':                        Icons.psychology_outlined,
    'Modern Şüpheler: Deizm, Ateizm, Simülasyon, Yapay Zekâ':       Icons.computer_outlined,
  };

  static Color forSection(String s) =>
      sectionColors[s] ?? AppColors.purple;
  static Color dimForSection(String s) =>
      Color.alphaBlend(forSection(s).withOpacity(0.20), AppColors.background);
  static IconData iconForSection(String s) =>
      sectionIcons[s] ?? Icons.question_answer_outlined;

  // askerProfile badge rengi
  static Color forProfile(String p) {
    if (p.contains('ateist'))      return AppColors.red;
    if (p.contains('deist'))       return AppColors.orange;
    if (p.contains('agnostik'))    return AppColors.cyan;
    if (p.contains('çocuk'))       return AppColors.lime;
    if (p.contains('felsefe'))     return AppColors.purple;
    if (p.contains('Müslüman'))    return AppColors.tealLight;
    return AppColors.textMuted;
  }

  // difficulty badge rengi
  static Color forDifficulty(String d) {
    if (d.contains('çok zor'))     return AppColors.red;
    if (d.contains('hassas'))      return AppColors.rose;
    if (d.contains('ileri'))       return AppColors.purple;
    if (d.contains('tricky'))      return AppColors.amber;
    return AppColors.textMuted;
  }

  // difficulty kısa etiket
  static String labelForDifficulty(String d) {
    if (d.contains('çok zor'))     return 'Çok Zor';
    if (d.contains('hassas'))      return 'Hassas';
    if (d.contains('ileri'))       return 'İleri';
    if (d.contains('tricky'))      return 'Tricky';
    if (d.contains('zor'))         return 'Zor';
    return d;
  }

  // askerProfile kısa etiket
  static String labelForProfile(String p) {
    if (p.contains('ateist'))      return 'Ateist';
    if (p.contains('deist'))       return 'Deist';
    if (p.contains('agnostik'))    return 'Agnostik';
    if (p.contains('çocuk'))       return 'Çocuk/Ergen';
    if (p.contains('felsefe'))     return 'Felsefeci';
    if (p.contains('Müslüman'))    return 'Meraklı';
    return p;
  }
}

// ── Sözler renk/ikon sistemi ─────────────────────────────────────────────────
class SozColors {
  static const Map<String, Color> catColors = {
    'Filozoflar & Metafizikçiler':                          AppColors.purple,
    'Bilim İnsanları & Matematikçiler':                     AppColors.indigo,
    'İslam Âlimleri & Mütefekkirler':                       AppColors.tealLight,
    'Hristiyan-Yahudi Düşünürler & Apolojistler':           AppColors.amber,
    'Yazarlar, Şairler & Sanatçılar':                       AppColors.rose,
    'Siyasetçiler, Liderler & Toplum Önderleri':            AppColors.copper,
    'Eski Ateistler, Şüpheciler & Dönüşüm Hikâyeleri':     AppColors.red,
    'Sporcular & Popüler Kültür Figürleri':                 AppColors.lime,
    'Ahlak, Psikoloji & İnsan Doğası Üzerine Söyleyenler': AppColors.cyan,
    'Karşıt Sesler, Eleştirmenler & Düşündürenler':         AppColors.orange,
  };

  static const Map<String, Color> catColorsDim = {
    'Filozoflar & Metafizikçiler':                          Color(0xFF3D2F6A),
    'Bilim İnsanları & Matematikçiler':                     Color(0xFF1D2558),
    'İslam Âlimleri & Mütefekkirler':                       Color(0xFF1D4A48),
    'Hristiyan-Yahudi Düşünürler & Apolojistler':           Color(0xFF6A420D),
    'Yazarlar, Şairler & Sanatçılar':                       Color(0xFF5A2035),
    'Siyasetçiler, Liderler & Toplum Önderleri':            Color(0xFF50301D),
    'Eski Ateistler, Şüpheciler & Dönüşüm Hikâyeleri':     Color(0xFF582828),
    'Sporcular & Popüler Kültür Figürleri':                 Color(0xFF234D1D),
    'Ahlak, Psikoloji & İnsan Doğası Üzerine Söyleyenler': Color(0xFF15454D),
    'Karşıt Sesler, Eleştirmenler & Düşündürenler':         Color(0xFF583810),
  };

  static const Map<String, IconData> catIcons = {
    'Filozoflar & Metafizikçiler':                          Icons.auto_awesome_outlined,
    'Bilim İnsanları & Matematikçiler':                     Icons.science_outlined,
    'İslam Âlimleri & Mütefekkirler':                       Icons.menu_book_outlined,
    'Hristiyan-Yahudi Düşünürler & Apolojistler':           Icons.account_balance_outlined,
    'Yazarlar, Şairler & Sanatçılar':                       Icons.draw_outlined,
    'Siyasetçiler, Liderler & Toplum Önderleri':            Icons.how_to_vote_outlined,
    'Eski Ateistler, Şüpheciler & Dönüşüm Hikâyeleri':     Icons.change_circle_outlined,
    'Sporcular & Popüler Kültür Figürleri':                 Icons.emoji_events_outlined,
    'Ahlak, Psikoloji & İnsan Doğası Üzerine Söyleyenler': Icons.favorite_outline,
    'Karşıt Sesler, Eleştirmenler & Düşündürenler':         Icons.record_voice_over_outlined,
  };

  static Color forCategory(String c) =>
      catColors[c] ?? AppColors.purple;
  static Color dimForCategory(String c) =>
      Color.alphaBlend(forCategory(c).withOpacity(0.20), AppColors.background);
  static IconData iconForCategory(String c) =>
      catIcons[c] ?? Icons.format_quote_outlined;

  // quoteType badge
  static Color forQuoteType(String t) {
    if (t.contains('doğrudan')) return AppColors.green;
    if (t.contains('atfedilen')) return AppColors.amber;
    return AppColors.textMuted;
  }

  static String labelForQuoteType(String t) {
    if (t.contains('doğrudan')) return 'Alıntı';
    if (t.contains('atfedilen')) return 'Atıf';
    if (t.contains('görüş')) return 'Görüş';
    return t;
  }
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.gold,
      secondary: AppColors.purple,
      surface: AppColors.surface,
      onPrimary: AppColors.background,
      onSecondary: Color(0xFFFAF7F0),
      onSurface: AppColors.textPrimary,
    ),
    textTheme: GoogleFonts.notoSerifTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.notoSerif(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.goldLight,
        letterSpacing: 0.5,
      ),
      headlineMedium: GoogleFonts.notoSerif(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.notoSerif(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.notoSerif(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.notoSerif(
        fontSize: 15,
        height: 1.65,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.notoSerif(
        fontSize: 13,
        height: 1.55,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.notoSans(
        fontSize: 11,
        color: AppColors.textMuted,
        letterSpacing: 0.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      titleTextStyle: GoogleFonts.notoSerif(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.goldLight,
        letterSpacing: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.gold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.gold,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerColor: AppColors.cardBorder,
    cardColor: AppColors.cardBg,
  );
}
