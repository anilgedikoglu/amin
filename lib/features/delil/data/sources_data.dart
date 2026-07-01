// ignore_for_file: lines_longer_than_80_chars
import '../models/delil_model.dart';

// ── DELİLLER kaynakları ───────────────────────────────────────────────────────
const List<DelilSource> _delilSources = [
  DelilSource(
    code: 'SEP-KOZMOLOJIK',
    module: 'DELİLLER',
    title: 'Stanford Encyclopedia of Philosophy: Cosmological Argument',
    url: 'https://plato.stanford.edu/entries/cosmological-argument/',
    description: 'Hudus ve Kalam kozmolojik delillerinin akademik analizi.',
  ),
  DelilSource(
    code: 'SEP-TELEOLOJIK',
    module: 'DELİLLER',
    title: 'Stanford Encyclopedia of Philosophy: Teleological Arguments',
    url: 'https://plato.stanford.edu/entries/teleological-arguments/',
    description: 'Tasarım ve gaye delillerinin kapsamlı felsefe kaynağı.',
  ),
  DelilSource(
    code: 'SEP-FINE-TUNING',
    module: 'DELİLLER',
    title: 'Stanford Encyclopedia of Philosophy: Fine-Tuning',
    url: 'https://plato.stanford.edu/entries/fine-tuning/',
    description: 'Evrenin ince ayarı argümanının akademik değerlendirmesi.',
  ),
  DelilSource(
    code: 'SEP-AHLAK',
    module: 'DELİLLER',
    title: 'Stanford Encyclopedia of Philosophy: Moral Arguments for God',
    url: 'https://plato.stanford.edu/entries/moral-arguments-god/',
    description: 'Ahlak delilinin felsefi çerçevesi.',
  ),
  DelilSource(
    code: 'IEP-ONTOLOJIK',
    module: 'DELİLLER',
    title: 'Internet Encyclopedia of Philosophy: Anselm\'s Ontological Argument',
    url: 'https://iep.utm.edu/anselm-ontological-argument/',
    description: 'Ontolojik delilin tarihsel gelişimi ve eleştirileri.',
  ),
  DelilSource(
    code: 'ROUTLEDGE',
    module: 'DELİLLER',
    title: 'Routledge Encyclopedia of Philosophy: Arguments for God\'s Existence',
    url: 'https://www.rep.routledge.com/articles/thematic/god-arguments-for-the-existence-of/v-1',
    description: 'Tanrı\'nın varlığına ilişkin argümanların ansiklopedik derlemesi.',
  ),
  DelilSource(
    code: 'TASLAMAN-12',
    module: 'DELİLLER',
    title: 'Caner Taslaman: Allah\'ın Varlığının 12 Delili',
    url: 'https://www.canertaslaman.com/wp-content/uploads/2019/09/allahın-varlığının-12-delili.pdf',
    description: 'Türkçe kapsamlı apologetik özet, bilimsel ve felsefi deliller.',
  ),
  DelilSource(
    code: 'RIS-AKAID',
    module: 'DELİLLER',
    title: 'Risale-i Nur\'da Allah\'ın Varlığı Bahisleri',
    url: 'https://www.yeniasya.com.tr/enstitu/allah-in-varligi-hakkinda-risale-i-nur-da-gecen-bahisler_127410',
    description: 'Said Nursî\'nin fıtrat ve kâinat merkezli delil yaklaşımı.',
  ),
  DelilSource(
    code: 'ISLAM-HUDUS',
    module: 'DELİLLER',
    title: 'İhtira ve Hudus Delili Açıklaması',
    url: 'https://sorularlaislamiyet.com/allahin-varliginin-delili-icin-soylenen-ihtira-ve-hudus-delili-arasinda-fark-var-mi',
    description: 'İslam kelâmındaki hudus ve ihtira delillerinin karşılaştırması.',
  ),
  DelilSource(
    code: 'YARAN-ISLAM',
    module: 'DELİLLER',
    title: 'Cafer Sadık Yaran: Islamic Thought on the Existence of God',
    url: 'https://www.crvp.org/publications/Series-IIA/IIA-16-Contents.pdf',
    description: 'İslam felsefesinde Allah\'ın varlığı meselesine akademik yaklaşım.',
  ),
  DelilSource(
    code: 'NASA-WMAP',
    module: 'DELİLLER',
    title: 'NASA WMAP Overview',
    url: 'https://science.nasa.gov/mission/wmap/wmap-overview/',
    description: 'Kozmik mikrodalga arka plan radyasyonu verileri; evrenin başlangıcına dair.',
  ),
  DelilSource(
    code: 'PLANCK-2018',
    module: 'DELİLLER',
    title: 'Planck 2018 Results: Cosmological Parameters',
    url: 'https://arxiv.org/abs/1807.06209',
    description: 'Evrenin yaşı ve genişlemesine ilişkin en güncel kozmoloji verileri.',
  ),
  DelilSource(
    code: 'BGV-2003',
    module: 'DELİLLER',
    title: 'Borde, Guth, Vilenkin: Inflationary Spacetimes Are Incomplete in Past Directions',
    url: 'https://link.aps.org/doi/10.1103/PhysRevLett.90.151301',
    description: 'Evrenin geçmişte mutlak bir başlangıcı olduğunu kanıtlayan BGV teoremi.',
  ),
];

// ── MUCİZELER kaynakları ──────────────────────────────────────────────────────
const List<DelilSource> _mucizeSources = [
  DelilSource(
    code: 'BUCAILLE-BQS',
    module: 'MUCİZELER',
    title: 'Maurice Bucaille: The Bible, The Quran and Science',
    url: 'https://www.kalamullah.com/Books/The%20Bible%20The%20Quran%20and%20Science.pdf',
    description: 'Fransız cerrahın Kur\'an\'daki bilimsel ifadeleri tıp gözüyle incelediği klasik eser.',
  ),
  DelilSource(
    code: 'ZAGHLOUL-SUNNAH',
    module: 'MUCİZELER',
    title: 'Zaghloul El-Naggar: Scientific Miracles in the Sunnah',
    url: 'https://www.noor-book.com/en/book-Scientific-Miracles-in-the-Sunnah-pdf',
    description: 'Mısırlı jeolog ve bilim adamının hadislerdeki bilimsel mucizelere dair araştırması.',
  ),
  DelilSource(
    code: 'NAIK-SCIENCE',
    module: 'MUCİZELER',
    title: 'Zakir Naik: The Quran and Modern Science — Compatible or Incompatible?',
    url: 'https://www.irf.net/downloads/books/en/The_Quran_and_Modern_Science_Compatible_or_Incompatible.pdf',
    description: 'Kur\'an ifadeleri ile modern bilim bulgularının karşılaştırmalı analizi.',
  ),
  DelilSource(
    code: 'TZORTZIS-QURAN',
    module: 'MUCİZELER',
    title: 'Hamza Tzortzis: The Qur\'an: A Hebron Study',
    url: 'https://www.hamzatzortzis.com/the-quran-a-hebron-study/',
    description: 'Kur\'an\'ın dil mucizesi ve bilimsel işaretlerine dair analitik çalışma.',
  ),
  DelilSource(
    code: 'DERVEZE-TEFSIR',
    module: 'MUCİZELER',
    title: 'Diyanet İşleri: Kur\'an Yolu Tefsiri',
    url: 'https://kuranvemeali.com/tefsir/',
    description: 'Türkiye Diyanet Vakfı\'nın kapsamlı Kur\'an tefsiri.',
  ),
  DelilSource(
    code: 'BUCAILLE-EMBRYO',
    module: 'MUCİZELER',
    title: 'Keith Moore: The Developing Human — Islamic Additions',
    url: 'https://www.islamicity.org/5853/the-embryo-in-the-quran/',
    description: 'Embriyolog Keith Moore\'un Kur\'an\'daki embriyoloji ifadelerine dair notları.',
  ),
  DelilSource(
    code: 'IMSAK-ASTRONOMY',
    module: 'MUCİZELER',
    title: 'Islam and Astronomy: Historical and Scientific Perspectives',
    url: 'https://www.islamicstudies.info/reference/astronomy.php',
    description: 'İslam astronomisi ve Kur\'an\'daki kozmolojik referanslar.',
  ),
  DelilSource(
    code: 'IJAZ-INIMITABILITY',
    module: 'MUCİZELER',
    title: 'SEP: İ\'caz — Inimitability of the Quran',
    url: 'https://plato.stanford.edu/entries/arabic-islamic-language/#QuranLing',
    description: 'Kur\'an\'ın dil mucizesinin (i\'caz) akademik felsefe çerçevesinde ele alınışı.',
  ),
];

// ── CEVAPLAR kaynakları ───────────────────────────────────────────────────────
const List<DelilSource> _cevapSources = [
  DelilSource(
    code: 'CRAIG-RF',
    module: 'CEVAPLAR',
    title: 'William Lane Craig: Reasonable Faith (3rd Ed.)',
    url: 'https://www.reasonablefaith.org/writings/popular-writings/existence-nature-of-god/what-is-the-kalam-cosmological-argument/',
    description: 'Kalam kozmolojik delili ve ateizm itirazlarına yönelik en kapsamlı apologetik kaynak.',
  ),
  DelilSource(
    code: 'PLANTINGA-WCF',
    module: 'CEVAPLAR',
    title: 'Alvin Plantinga: Where the Conflict Really Lies',
    url: 'https://global.oup.com/academic/product/where-the-conflict-really-lies-9780199812097',
    description: 'Bilim-din çatışması tezinin sistematik çürütmesi; doğalcılık ve teizm karşılaştırması.',
  ),
  DelilSource(
    code: 'SWINBURNE-EG',
    module: 'CEVAPLAR',
    title: 'Richard Swinburne: The Existence of God (2nd Ed.)',
    url: 'https://global.oup.com/academic/product/the-existence-of-god-9780199271672',
    description: 'Tanrı\'nın varlığına ilişkin tüm argümanların Bayesci analitik felsefe çerçevesinde değerlendirmesi.',
  ),
  DelilSource(
    code: 'LEWIS-MC',
    module: 'CEVAPLAR',
    title: 'C.S. Lewis: Mere Christianity',
    url: 'https://www.cslewis.com/us/books/mere-christianity/',
    description: 'Ahlak delili ve inanç savunusunun popüler klasiği.',
  ),
  DelilSource(
    code: 'TASLAMAN-EVRIM',
    module: 'CEVAPLAR',
    title: 'Caner Taslaman: Evrim Teorisi, Felsefe ve Tanrı',
    url: 'https://www.canertaslaman.com/kitaplar/evrim-teorisi-felsefe-ve-tanri/',
    description: 'Evrim teorisi ile teizmin çelişmediğini savunan Türkçe kapsamlı analiz.',
  ),
  DelilSource(
    code: 'TZORTZIS-DIVINE',
    module: 'CEVAPLAR',
    title: 'Hamza Tzortzis: The Divine Reality',
    url: 'https://www.hamzatzortzis.com/the-divine-reality/',
    description: 'Ateizm itirazlarına İslam perspektifinden sistematik cevaplar.',
  ),
  DelilSource(
    code: 'SEP-EVIL',
    module: 'CEVAPLAR',
    title: 'Stanford Encyclopedia of Philosophy: The Problem of Evil',
    url: 'https://plato.stanford.edu/entries/evil/',
    description: 'Kötülük problemi ve theodicy tartışmalarının akademik kaynağı.',
  ),
  DelilSource(
    code: 'SEP-FREEWILL',
    module: 'CEVAPLAR',
    title: 'Stanford Encyclopedia of Philosophy: Free Will',
    url: 'https://plato.stanford.edu/entries/freewill/',
    description: 'Özgür irade, determinizm ve ahlaki sorumluluk konusundaki akademik tartışma.',
  ),
  DelilSource(
    code: 'NASR-ISLAM-SCIENCE',
    module: 'CEVAPLAR',
    title: 'Seyyed Hossein Nasr: Islam and the Challenge of Modern Science',
    url: 'https://www.worldwisdom.com/public/authors/Seyyed-Hossein-Nasr.aspx',
    description: 'İslam bilim geleneği ve moderniteye dair felsefi bir yaklaşım.',
  ),
];

// ── SÖZLER kaynakları ─────────────────────────────────────────────────────────
const List<DelilSource> _sozSources = [
  DelilSource(
    code: 'WIKIQUOTE-VER',
    module: 'SÖZLER',
    title: 'Wikiquote — Kayıtlı Alıntı Doğrulama',
    url: 'https://www.wikiquote.org/',
    description: 'Tanınmış kişilere atfedilen sözlerin kaynak doğrulaması için başvurulan Wiki platformu.',
  ),
  DelilSource(
    code: 'BRAINY-ATTR',
    module: 'SÖZLER',
    title: 'BrainyQuote — Atıf Doğrulama',
    url: 'https://www.brainyquote.com/',
    description: 'Geniş alıntı veritabanı; birincil kaynak referanslarıyla atıf doğrulaması.',
  ),
  DelilSource(
    code: 'GOODREADS-Q',
    module: 'SÖZLER',
    title: 'Goodreads Quotes',
    url: 'https://www.goodreads.com/quotes',
    description: 'Kitaplardan ve yazarlardan doğrudan alıntıların derlendiği geniş veritabanı.',
  ),
  DelilSource(
    code: 'STANFORD-PHILOSOPHERS',
    module: 'SÖZLER',
    title: 'Stanford Encyclopedia of Philosophy — Düşünür Biyografileri',
    url: 'https://plato.stanford.edu/',
    description: 'Filozofların özgün görüşlerine ve biyografik bilgilerine ilişkin birincil akademik kaynak.',
  ),
  DelilSource(
    code: 'OXFORD-QUOTATIONS',
    module: 'SÖZLER',
    title: 'Oxford Dictionary of Quotations',
    url: 'https://www.oxfordreference.com/display/10.1093/acref/9780199668700.001.0001/acref-9780199668700',
    description: 'Oxford\'ın editoryal denetimiyle hazırlanan alıntı referans sözlüğü.',
  ),
  DelilSource(
    code: 'ISLAMANSIKLO',
    module: 'SÖZLER',
    title: 'TDV İslam Ansiklopedisi',
    url: 'https://islamansiklopedisi.org.tr/',
    description: 'İslam âlimleri ve mütefekkirlerine ait görüşler için Türkiye Diyanet Vakfı\'nın temel akademik kaynağı.',
  ),
  DelilSource(
    code: 'QUOTESINVESTIGATOR',
    module: 'SÖZLER',
    title: 'Quote Investigator — Atıf Araştırması',
    url: 'https://quoteinvestigator.com/',
    description: 'Yanlış atfedilen ya da uydurma sözlerin araştırıldığı uzman doğrulama sitesi.',
  ),
];

// ── Tüm kaynaklar ─────────────────────────────────────────────────────────────
const List<DelilSource> allSources = [
  ..._delilSources,
  ..._mucizeSources,
  ..._cevapSources,
  ..._sozSources,
];

const List<String> sourceModules = [
  'DELİLLER',
  'MUCİZELER',
  'CEVAPLAR',
  'SÖZLER',
];

List<DelilSource> getSourcesByModule(String module) =>
    allSources.where((s) => s.module == module).toList();

DelilSource? findSource(String code) {
  try {
    return allSources.firstWhere((s) => s.code == code);
  } catch (_) {
    return null;
  }
}
