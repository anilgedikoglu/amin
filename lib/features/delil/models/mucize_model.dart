class MucizeDetailedExplanation {
  final String detayliAciklama;
  final String nedenVayBeDedirtiyor;
  final String kaynakNotu;
  final String ihtiyatNotu;

  const MucizeDetailedExplanation({
    this.detayliAciklama = '',
    this.nedenVayBeDedirtiyor = '',
    this.kaynakNotu = '',
    this.ihtiyatNotu = '',
  });
}

class Mucize {
  final String id;
  final String title;
  final String mainCategory;
  final String subcategory;
  final String sourceRef;
  final String originalExpression;
  final String claim;
  final String miracleType;
  final String strengthOrCaution;
  final String shortExplanation;
  final MucizeDetailedExplanation? detailedExplanation;
  final List<String> tags;
  final List<String> sources;

  const Mucize({
    required this.id,
    required this.title,
    required this.mainCategory,
    this.subcategory = '',
    this.sourceRef = '',
    this.originalExpression = '',
    required this.claim,
    this.miracleType = '',
    this.strengthOrCaution = '',
    required this.shortExplanation,
    this.detailedExplanation,
    this.tags = const [],
    this.sources = const [],
  });
}
