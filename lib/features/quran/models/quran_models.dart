// Kur'an feature — veri modelleri
// Surah: sure üst bilgisi (asset surahs.json'dan)
// Ayah: tek bir ayetin Arapça metni + Türkçe meali

class Surah {
  final int id;
  final String arabicName; // الفاتحة
  final String turkishName; // Fâtiha
  final String englishName; // Al-Fatihah
  final int ayahCount;
  final String revelation; // "Mekki" | "Medeni"
  final int revelationOrder;
  final bool bismillahPre; // başında besmele ayrı gösterilsin mi

  const Surah({
    required this.id,
    required this.arabicName,
    required this.turkishName,
    required this.englishName,
    required this.ayahCount,
    required this.revelation,
    required this.revelationOrder,
    required this.bismillahPre,
  });

  factory Surah.fromJson(Map<String, dynamic> j) => Surah(
        id: j['id'] as int,
        arabicName: j['ar'] as String,
        turkishName: j['tr'] as String,
        englishName: j['en'] as String,
        ayahCount: j['ayah'] as int,
        revelation: j['rev'] as String,
        revelationOrder: j['order'] as int,
        bismillahPre: (j['bism'] as bool?) ?? false,
      );
}

class Ayah {
  final int surahId;
  final int number; // sure içinde 1..ayahCount
  final String arabic;
  final String okunus; // Latin harfli Türkçe okunuş
  // Seçili meal(ler): çevirmen id → meal metni (sıralı)
  final Map<String, String> translations;

  const Ayah({
    required this.surahId,
    required this.number,
    required this.arabic,
    required this.okunus,
    required this.translations,
  });

  // Geriye dönük uyum: ilk seçili meal
  String get turkish =>
      translations.isEmpty ? '' : translations.values.first;

  // Favori / son okunan için benzersiz anahtar
  String get key => '$surahId:$number';
}
