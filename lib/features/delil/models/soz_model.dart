class Soz {
  final String id;
  final String category;
  final String person;
  final String whoIs;
  final String title;
  final String quoteOriginalOrView;
  final String quoteTurkish;
  final String quoteType;
  final String whatItSupports;
  final String source;
  final String sourceReliabilityNote;
  final String detailedExplanation;
  final String whyRelevant;
  final List<String> tags;

  const Soz({
    required this.id,
    required this.category,
    this.person = '',
    this.whoIs = '',
    this.title = '',
    required this.quoteOriginalOrView,
    this.quoteTurkish = '',
    this.quoteType = '',
    this.whatItSupports = '',
    this.source = '',
    this.sourceReliabilityNote = '',
    this.detailedExplanation = '',
    this.whyRelevant = '',
    this.tags = const [],
  });
}
