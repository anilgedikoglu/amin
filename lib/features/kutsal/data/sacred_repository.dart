import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/sacred_models.dart';
import 'term_bridge.dart';

/// Kayıt defteri: uygulamadaki kutsal metinler.
/// `asset` doğrudan dosyadan; `from`+`bookRange` ise başka metnin alt kümesi (sanal).
class SacredEntry {
  final String id, name, religion;
  final String? asset;
  final String? from; // sanal metin için kaynak id
  final List<int>? bookRange; // [start, end) — from içindeki kitap aralığı
  final String? overrideLicense;
  final String? hakkinda; // metnin tarihçesi/açıklaması (okuyucuda üstte)
  const SacredEntry({
    required this.id,
    required this.name,
    required this.religion,
    this.asset,
    this.from,
    this.bookRange,
    this.overrideLicense,
    this.hakkinda,
  });
}

const List<SacredEntry> kSacredRegistry = [
  SacredEntry(
      id: 'quran',
      name: "Kur'an-ı Kerim",
      religion: 'İslam',
      asset: 'assets/sacred/quran.json',
      hakkinda:
          'Kur\'an-ı Kerim, İslam inancına göre Allah tarafından Cebrail (Cibrîl) meleği aracılığıyla Hz. Muhammed\'e (s.a.v.) vahyedilen ilahî kitaptır. İlk vahiy, 610 yılında Mekke yakınlarındaki Hira Mağarası\'nda "Oku!" (İkra) emriyle inmeye başlamış, vahiy süreci Peygamber\'in vefatına kadar yaklaşık 23 yıl sürmüştür.\n\nKur\'an bir defada değil, olaylara ve ihtiyaçlara göre parça parça (âyet âyet, sûre sûre) indirilmiştir. Bu tedricî iniş, hükümlerin topluma yavaş yavaş yerleşmesini sağlamıştır. Vahyin yaklaşık üçte biri Mekke\'de (iman, ahiret, tevhid ağırlıklı kısa sûreler), geri kalanı Medine\'de (hukuk, toplum, ibadet düzeni) inmiştir.\n\nKur\'an 114 sûre ve 6236 âyetten oluşur. En uzun sûre Bakara (286 âyet), en kısa sûre Kevser\'dir (3 âyet). Metin, indiği andan itibaren hem ezberlenerek (hafızlık geleneği) hem de yazılarak korunmuştur. Hz. Ebû Bekir döneminde tek bir cilt (mushaf) hâline getirilmiş, Hz. Osman döneminde çoğaltılıp İslam beldelerine gönderilerek metin birliği sağlanmıştır.\n\nKur\'an, indiği Arapça diliyle 14 asırdır tek bir harfi bile değişmeden korunan yegâne kutsal metin kabul edilir. Müslümanlar için sadece bir kitap değil; okunan, ezberlenen, hükümleriyle yaşanan ve tilavetiyle ibadet edilen bir rehberdir.\n\n(Bu uygulamadaki metin Diyanet İşleri meâlidir — Arapça aslın Türkçe anlam çevirisidir.)'),
  SacredEntry(
      id: 'tao',
      name: 'Tao Te Ching',
      religion: 'Taoizm',
      asset: 'assets/sacred/tao.json',
      hakkinda:
          'Tao Te Ching (Dào Dé Jīng — "Yol ve Erdem Kitabı"), Taoizm\'in temel metnidir. Geleneğe göre MÖ 6. yüzyılda yaşadığı söylenen bilge Lao Tzu (Laozi) tarafından yazıldığı kabul edilir; ancak birçok araştırmacı metnin MÖ 4.–3. yüzyıllarda birden çok elden şekillendiğini düşünür.\n\nRivayete göre Lao Tzu, içinde yaşadığı toplumun bozulmasından usanıp bir manda sırtında batıya, ülkeyi terk etmek üzere yola çıkar. Sınır bekçisi Yin Xi, bu bilgeden bilgeliğini yazıya dökmesini rica eder; Lao Tzu da 81 kısa bölümden oluşan bu metni yazıp bırakır ve bir daha görülmez.\n\nKitap 81 kısa şiirsel bölümden oluşur ve iki ana kavram üzerine kuruludur: "Tao" (Yol) — evrenin ardındaki adlandırılamaz, kendiliğinden akan ilke; ve "Te" (Erdem) — bu Yol\'a uygun yaşamanın gücü. Merkezî öğreti "wu wei"dir: zorlamadan, doğanın akışına uyarak eylemek.\n\nTao Te Ching, dünyada Kutsal Kitap\'tan sonra en çok dile çevrilen metinlerden biridir. Bu uygulamadaki Türkçe çeviri, kamu malı (public domain) James Legge İngilizce çevirisinden yapılmış özgün bir çeviridir.'),
  SacredEntry(
      id: 'dhammapada',
      name: 'Dhammapada',
      religion: 'Budizm',
      asset: 'assets/sacred/dhammapada.json',
      hakkinda:
          'Dhammapada ("Erdem/Öğreti Yolu"), Budizm\'in en tanınmış ve en çok okunan metnidir. Buddha\'nın (Siddhartha Gautama, MÖ 6.–5. yüzyıl) çeşitli vesilelerle söylediği özlü sözlerin derlemesidir. Pali dilindeki Budist kanonun (Tipitaka) "Khuddaka Nikaya" bölümünde yer alır.\n\nMetnin, Buddha\'nın vefatından sonra sözlü gelenekle aktarılan öğretilerinin, yaklaşık MÖ 3. yüzyılda yazıya geçirildiği kabul edilir. Sözlerin, dinleyicilerin hayatındaki somut olaylar üzerine söylendiği ve her birinin bir hikâyeye bağlı olduğu rivayet edilir.\n\nDhammapada 423 kısa dizeden (âyetten) oluşur ve 26 bölüme ayrılır: İkilikler, Uyanıklık, Zihin, Çiçekler, Öfke, Mutluluk gibi başlıklar taşır. Temel öğretisi zihnin arındırılması, öfke ve arzunun aşılması, şefkat ve farkındalıkla yaşamaktır. "Her şey zihinden doğar" düşüncesi metnin özüdür.\n\nBu uygulamadaki Türkçe çeviri, kamu malı (public domain) Max Müller İngilizce çevirisinden yapılmış özgün bir çeviridir.'),
  SacredEntry(
      id: 'bible',
      name: 'İncil (Kutsal Kitap)',
      religion: 'Hristiyanlık',
      asset: 'assets/sacred/bible.json',
      hakkinda:
          'Kutsal Kitap (Bible), Hristiyanlığın temel metnidir ve iki ana bölümden oluşur: Eski Ahit (Tevrat, Zebur ve peygamber kitapları — Yahudilikle ortak) ve Yeni Ahit (İncil — İsa Mesih\'in hayatı, öğretileri ve ilk kilisenin yazıları). Toplam 66 kitaptan meydana gelir.\n\nEski Ahit büyük ölçüde İbranice, Yeni Ahit ise Grekçe (Koine Yunancası) yazılmıştır. Metinler, MÖ ~1200\'lerden MS ~100\'e kadar uzanan geniş bir zaman diliminde, farklı peygamber, kral ve havariler tarafından kaleme alınmıştır. Yeni Ahit\'in dört İncil\'i (Matta, Markos, Luka, Yuhanna) İsa\'nın hayatını anlatır.\n\nİslam inancına göre İncil, Allah\'ın Hz. İsa\'ya indirdiği ilahî kitaptır; ancak Müslümanlar mevcut metinlerin zamanla değişikliğe (tahrif) uğradığına inanır. Kur\'an, İncil ve Tevrat\'ı "önceki kitaplar" olarak anar.\n\nBu uygulamadaki Türkçe metin, "Yorumsuz Türkçe Çeviri" (YTC) çevirisidir; kamu malı World English Bible esas alınarak İsmail Serinken ve eBible.org tarafından hazırlanmıştır.\n\nTelif: © 2023–2025 İsmail Serinken & eBible.org — Creative Commons Atıf-Türetilemez 4.0 (CC BY-ND 4.0) lisansıyla, metin değiştirilmeden kullanılmıştır.'),
  SacredEntry(
      id: 'torah',
      name: 'Tevrat (Tora)',
      religion: 'Yahudilik',
      from: 'bible',
      bookRange: [0, 5],
      overrideLicense: 'Yorumsuz Türkçe Çeviri (YTC) © 2023–2025 İsmail Serinken & eBible.org — CC BY-ND 4.0',
      hakkinda:
          'Tevrat (Tora — "Öğreti, Kanun"), Yahudiliğin en kutsal metnidir ve Kutsal Kitap\'ın (Eski Ahit) ilk beş kitabından oluşur: Yaratılış, Mısır\'dan Çıkış, Levililer, Çölde Sayım ve Yasa\'nın Tekrarı. Bu beş kitaba birlikte "Pentateuk" (Beş Kitap) da denir.\n\nYahudi geleneğine göre Tevrat, Hz. Musa\'ya (Moşe) Sina Dağı\'nda vahyedilmiştir. İçinde evrenin ve insanın yaratılışı, peygamber kıssaları, İsrailoğulları\'nın tarihi ve Yahudi hukukunun temeli olan emirler (mitzvot, On Emir dâhil) yer alır.\n\nİslam inancına göre Tevrat, Allah\'ın Hz. Musa\'ya indirdiği ilahî kitaptır; Kur\'an onu sıkça anar. Müslümanlar mevcut metinlerin zamanla değişikliğe uğradığına inanır.\n\nBu bölüm, Türkçe "Yorumsuz Türkçe Çeviri" (YTC) Kutsal Kitap\'ının ilk beş kitabıdır. Telif: © 2023–2025 İsmail Serinken & eBible.org — CC BY-ND 4.0.'),
  SacredEntry(
      id: 'gita',
      name: 'Bhagavad Gita',
      religion: 'Hinduizm',
      asset: 'assets/sacred/gita.json',
      hakkinda:
          'Bhagavad Gita ("Rabbin Ezgisi"), Hinduizmin en sevilen ve en etkili metnidir. Büyük destan Mahabharata\'nın içinde yer alan, 18 bölümden ve yaklaşık 700 beyitten oluşan felsefî bir şiirdir. Yaklaşık MÖ 2.–MS 2. yüzyıllar arasında bugünkü hâlini aldığı düşünülür.\n\nMetin, Kurukshetra Savaşı\'nın hemen öncesinde, savaşçı prens Arjuna ile arabacısı (ve tanrı Krishna\'nın tecellisi) arasında geçen bir diyalog biçimindedir. Arjuna, akrabalarına karşı savaşmanın ıstırabıyla sarsılırken, Krishna ona görev (dharma), eylem (karma), adanmışlık (bhakti) ve nefsin hakikati üzerine öğütler verir.\n\nGita\'nın merkezî öğretisi; sonuçlara bağlanmadan, görevini özverili bir ruhla yerine getirmek ve iç huzura ulaşmaktır. Gandhi başta olmak üzere birçok düşünürü derinden etkilemiştir.\n\nBu uygulamadaki metin, kamu malı (public domain) Sir Edwin Arnold çevirisi "The Song Celestial" (1885) İngilizce şiir çevirisidir.'),
  SacredEntry(
      id: 'analects',
      name: 'Konfüçyüs — Analektler',
      religion: 'Konfüçyüsçülük',
      asset: 'assets/sacred/analects.json',
      hakkinda:
          'Analektler (Lún Yǔ — "Seçme Sözler"), Çin bilgesi Konfüçyüs\'ün (MÖ 551–479) öğretilerini, sözlerini ve öğrencileriyle diyaloglarını içeren temel metindir. Konfüçyüsçülüğün en önemli klasiğidir ve iki bin yıldan fazla süre Çin düşüncesini, ahlakını ve devlet anlayışını şekillendirmiştir.\n\nMetin, Konfüçyüs\'ün kendisi tarafından değil, vefatından sonra öğrencileri ve onların öğrencileri tarafından, yaklaşık MÖ 5.–3. yüzyıllarda derlenmiştir. 20 "kitap" (bölüm) hâlinde düzenlenmiş kısa pasajlardan oluşur; her pasaj çoğunlukla "Üstat dedi ki…" diye başlar.\n\nAnalektler\'in özü; erdem (ren — insanlık/şefkat), doğruluk, âdâb (li), aileye ve topluma karşı sorumluluk, ve "kendine yapılmasını istemediğini başkasına yapma" ilkesidir. Bilgelik, öğrenme ve ahlaki olgunluk sürekli vurgulanır.\n\nBu uygulamadaki metin, kamu malı (public domain) James Legge çevirisi (1893) İngilizcesidir.'),
];

/// compute() içinde çalışır — ağır JSON parse arka plan isolate'inde.
SacredText _parse(String raw) =>
    SacredText.fromJson(jsonDecode(raw) as Map<String, dynamic>);

/// Türkçe-duyarsız eşleştirme için sadeleştirme (büyük/küçük + aksan).
String _fold(String s) {
  final b = StringBuffer();
  for (final r in s.toLowerCase().runes) {
    switch (r) {
      case 0x131: // ı
      case 0x130: // İ
        b.writeCharCode(0x69); // i
        break;
      case 0x15F: // ş
        b.writeCharCode(0x73); // s
        break;
      case 0x11F: // ğ
        b.writeCharCode(0x67); // g
        break;
      case 0xE7: // ç
        b.writeCharCode(0x63); // c
        break;
      case 0xFC: // ü
        b.writeCharCode(0x75); // u
        break;
      case 0xF6: // ö
        b.writeCharCode(0x6F); // o
        break;
      default:
        b.writeCharCode(r);
    }
  }
  return b.toString();
}

class SacredRepository {
  SacredRepository._();
  static final SacredRepository instance = SacredRepository._();

  final Map<String, SacredText> _cache = {};

  SacredEntry entry(String id) =>
      kSacredRegistry.firstWhere((e) => e.id == id);

  bool isLoaded(String id) => _cache.containsKey(id);

  Future<SacredText> load(String id) async {
    if (_cache.containsKey(id)) return _cache[id]!;
    final e = entry(id);
    SacredText text;
    if (e.asset != null) {
      final raw = await rootBundle.loadString(e.asset!);
      text = await compute(_parse, raw);
    } else {
      // Sanal metin: kaynak metnin kitap aralığı.
      final base = await load(e.from!);
      final r = e.bookRange ?? [0, base.books.length];
      text = SacredText(
        id: e.id,
        name: e.name,
        religion: e.religion,
        lang: base.lang,
        license: e.overrideLicense ?? base.license,
        books: base.books.sublist(r[0], r[1]),
      );
    }
    _cache[id] = text;
    return text;
  }

  Future<void> ensureAll() async {
    for (final e in kSacredRegistry) {
      await load(e.id);
    }
  }

  /// Tüm (veya seçili) metinlerde birleşik arama. Terim köprüsüyle TR↔EN.
  Future<List<SacredHit>> search(String query,
      {List<String>? ids, int limitPerText = 60}) async {
    final q = query.trim();
    if (q.length < 2) return [];
    final targets = ids ?? kSacredRegistry.map((e) => e.id).toList();
    // Kelime-başı eşleşme: "aşk" → "aşkı/aşkın" yakalar ama "başka" yakalamaz.
    final terms = expandQuery(q)
        .map(_fold)
        .where((t) => t.length >= 2)
        .map((t) => RegExp('(^|[^a-z0-9])${RegExp.escape(t)}'))
        .toList();
    final hits = <SacredHit>[];

    for (final id in targets) {
      final text = await load(id);
      var count = 0;
      outer:
      for (var bi = 0; bi < text.books.length; bi++) {
        final book = text.books[bi];
        for (var ci = 0; ci < book.chapters.length; ci++) {
          final verses = book.chapters[ci];
          for (var vi = 0; vi < verses.length; vi++) {
            final folded = _fold(verses[vi]);
            var matched = false;
            for (final re in terms) {
              if (re.hasMatch(folded)) {
                matched = true;
                break;
              }
            }
            if (!matched) continue;
            final ref = book.singleChapter
                ? '${book.name} ${vi + 1}'
                : '${book.name} ${ci + 1}:${vi + 1}';
            hits.add(SacredHit(
              textId: id,
              textName: text.name,
              religion: text.religion,
              bookIndex: bi,
              chapterIndex: ci,
              verseIndex: vi,
              ref: ref,
              verse: verses[vi],
            ));
            if (++count >= limitPerText) break outer;
          }
        }
      }
    }
    return hits;
  }
}
