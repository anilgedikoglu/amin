class CevapDetailedExplanation {
  final List<String> orijinalMetinler;
  final String cevabinDayanagi;
  final String detayliAciklama;
  final String ornek;
  final String ihtiyatNotu;

  const CevapDetailedExplanation({
    this.orijinalMetinler = const [],
    this.cevabinDayanagi = '',
    this.detayliAciklama = '',
    this.ornek = '',
    this.ihtiyatNotu = '',
  });
}

class Cevap {
  final String id;
  final String section;
  final String sectionDescription;
  final String title;
  final String question;
  final String askerProfile;
  final String difficulty;
  final String shortAnswer;
  final String answer;
  final CevapDetailedExplanation? detailedExplanation;
  final List<String> sources;
  final List<String> tags;

  const Cevap({
    required this.id,
    required this.section,
    this.sectionDescription = '',
    required this.title,
    required this.question,
    this.askerProfile = '',
    this.difficulty = '',
    required this.shortAnswer,
    required this.answer,
    this.detailedExplanation,
    this.sources = const [],
    this.tags = const [],
  });
}
