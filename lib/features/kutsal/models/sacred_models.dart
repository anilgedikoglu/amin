// Kutsal Metinler — ortak veri modeli (Kur'an, İncil, Tevrat, Gita...).

class SacredBook {
  final String name; // Türkçe ad
  final String? en; // orijinal İngilizce ad (varsa)
  final List<List<String>> chapters; // bölüm -> ayet listesi
  const SacredBook({required this.name, this.en, required this.chapters});

  factory SacredBook.fromJson(Map<String, dynamic> j) => SacredBook(
        name: j['n'] as String,
        en: j['en'] as String?,
        chapters: (j['c'] as List)
            .map<List<String>>(
                (ch) => (ch as List).map((v) => v as String).toList())
            .toList(),
      );

  bool get singleChapter => chapters.length == 1;
}

class SacredText {
  final String id;
  final String name; // "Kur'an-ı Kerim"
  final String religion; // "İslam"
  final String lang; // "tr" | "en"
  final String license;
  final List<SacredBook> books;
  const SacredText({
    required this.id,
    required this.name,
    required this.religion,
    required this.lang,
    required this.license,
    required this.books,
  });

  factory SacredText.fromJson(Map<String, dynamic> j) => SacredText(
        id: j['id'] as String,
        name: j['name'] as String,
        religion: j['religion'] as String,
        lang: j['lang'] as String,
        license: j['license'] as String,
        books: (j['books'] as List)
            .map((b) => SacredBook.fromJson(b as Map<String, dynamic>))
            .toList(),
      );

  int get verseCount {
    var n = 0;
    for (final b in books) {
      for (final c in b.chapters) {
        n += c.length;
      }
    }
    return n;
  }
}

/// Arama sonucu — tıklayınca ilgili ayete gider.
class SacredHit {
  final String textId;
  final String textName;
  final String religion;
  final int bookIndex;
  final int chapterIndex;
  final int verseIndex;
  final String ref; // "Yuhanna 3:16"
  final String verse;
  const SacredHit({
    required this.textId,
    required this.textName,
    required this.religion,
    required this.bookIndex,
    required this.chapterIndex,
    required this.verseIndex,
    required this.ref,
    required this.verse,
  });
}
