class DetailedExplanation {
  final String kaynakYeri;
  final String kaynakMetniVeyaCekirdekFormulasyon;
  final String nedenDelildir;
  final String uygulamaNotu;

  const DetailedExplanation({
    this.kaynakYeri = '',
    this.kaynakMetniVeyaCekirdekFormulasyon = '',
    this.nedenDelildir = '',
    this.uygulamaNotu = '',
  });
}

class Delil {
  final String id;
  final String category;
  final String subcategory;
  final String title;
  final String short;
  final String expanded;
  final List<String> tags;
  final String strength;
  final List<String> sources;
  final String objection;
  final String reply;
  final DetailedExplanation? detailedExplanation;

  const Delil({
    required this.id,
    required this.category,
    required this.subcategory,
    required this.title,
    required this.short,
    required this.expanded,
    required this.tags,
    required this.strength,
    this.sources = const [],
    this.objection = '',
    this.reply = '',
    this.detailedExplanation,
  });

  bool get hasObjectionReply => objection.isNotEmpty && reply.isNotEmpty;

  int get strengthLevel {
    switch (strength) {
      case 'yüksek':
        return 3;
      case 'orta-yüksek':
        return 2;
      case 'orta':
        return 1;
      default:
        return 0;
    }
  }
}

class DelilSource {
  final String code;
  final String title;
  final String url;
  final String module; // 'DELİLLER' | 'MUCİZELER' | 'CEVAPLAR' | 'SÖZLER'
  final String description;

  const DelilSource({
    required this.code,
    required this.title,
    required this.url,
    this.module = 'DELİLLER',
    this.description = '',
  });
}
