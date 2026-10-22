// Din Felsefesi (Teoloji) — öğretici, derlenmiş kelam ve din felsefesi içerikleri.
// Aranabilir, kategorili; dokununca tam açıklama.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';

class TeolojiKonu {
  final String baslik, kategori, ozet, metin;
  const TeolojiKonu(this.baslik, this.kategori, this.ozet, this.metin);
}

const List<TeolojiKonu> kTeolojiKonulari = [
  TeolojiKonu(
    'Hudûs Delili',
    'Allah\'ın Varlığı',
    'Sonradan var olan âlem, kendisini var eden bir Yaratıcıyı gerektirir.',
    'Hudûs delili, kâinatın ezelî olmadığı, yani bir başlangıcı bulunduğu fikrinden hareket eder. Var olmaya başlayan her şeyin bir sebebe ihtiyacı vardır; çünkü "yok" kendini "var" edemez. Âlem değişen, oluşan ve bozulan varlıklardan meydana geldiğine göre kendisi de sonradan olmadır (hâdis). Sonradan olan bu bütünün, varlığı zorunlu (Vâcibü\'l-vücûd) bir İlk Sebebe dayanması aklen gereklidir. İslam kelamcıları (özellikle Mâtürîdî ve Eş\'arî gelenek) bu delili merkeze almıştır. Modern kozmolojideki "evrenin bir başlangıcı vardır" verisi de bu klasik akıl yürütmeyle örtüşür.',
  ),
  TeolojiKonu(
    'İmkân Delili',
    'Allah\'ın Varlığı',
    'Var olması da olmaması da mümkün olan âlem, varlığını zorunlu bir Varlığa borçludur.',
    'İmkân (kontenjans) delili İbn Sînâ ile sistemleşmiştir. Varlıklar ikiye ayrılır: varlığı zorunlu olan (Vâcib) ve varlığı ile yokluğu eşit ihtimalde olan (mümkin). Mümkin bir varlık, var olmak için kendi dışında bir sebebe muhtaçtır; çünkü özünde var olmayı gerektiren bir şey yoktur. Sebepler zinciri sonsuza gidemez (teselsül imkânsızdır); bu zincir, varlığı başkasından olmayan, özü gereği var olan Zorunlu Varlıkta son bulmalıdır. İşte O, Allah\'tır. Bu delil, "neden hiçbir şey yerine bir şeyler var?" sorusuna verilen en güçlü felsefî cevaplardandır.',
  ),
  TeolojiKonu(
    'Gaye ve Nizam Delili',
    'Allah\'ın Varlığı',
    'Evrendeki ince düzen ve amaçlılık, bilen ve dileyen bir Düzenleyiciye işaret eder.',
    'Teleolojik delil olarak da bilinir. Kâinattaki hassas dengeler — fizik sabitlerinin yaşamı mümkün kılacak şekilde ayarlanması, canlılardaki organların amaca uygunluğu, ekosistemlerin uyumu — rastlantıyla açıklanamayacak bir tasarım sergiler. Düzen, düzenleyiciye; amaç, amaç koyana delâlet eder. Kur\'an sürekli olarak göklerin, yerin, gece-gündüzün ve canlıların yaratılışındaki âyetlere (işaretlere) dikkat çeker. Çağdaş "ince ayar" (fine-tuning) tartışması bu klasik delilin bilimsel diliyle yeniden ifadesidir.',
  ),
  TeolojiKonu(
    'Fıtrat Delili',
    'Allah\'ın Varlığı',
    'İnsanın doğasında bir Yaratıcıya inanma ve sığınma eğilimi vardır.',
    'Fıtrat delili, Allah inancının insanın yaratılışına yerleştirilmiş bir eğilim olduğunu savunur. Zor anlarda, çaresizlikte insanın içten içe bir yüce güce yönelmesi, hiçbir toplumun tümüyle "kutsalsız" olmaması bunun göstergesidir. Kur\'an "Yüzünü dosdoğru dine, Allah\'ın insanları üzerinde yarattığı fıtrata çevir" (Rûm 30) buyurur. Bu delil rasyonel bir ispattan çok, inancın insanî tecrübedeki köklülüğüne işaret eder.',
  ),
  TeolojiKonu(
    'İlahî Sıfatlar (Zâtî ve Sübûtî)',
    'Tevhid',
    'Allah\'ın zâtına ait ve fiilleriyle bilinen sıfatların özeti.',
    'Kelam ilmi Allah\'ın sıfatlarını başlıca ikiye ayırır. Zâtî (selbî) sıfatlar, O\'nun ne OLMADIĞINI bildirir: Vücûd (var olmak), Kıdem (başlangıcının olmaması), Bekâ (sonunun olmaması), Vahdâniyet (bir olması), Muhâlefetün lil-havâdis (yaratılmışlara benzememesi), Kıyâm bi-nefsihî (varlığının kendinden olması). Sübûtî sıfatlar ise O\'nun kemâl niteliklerini bildirir: Hayât, İlim, Semî\' (işitme), Basar (görme), İrâde, Kudret, Kelâm, Tekvîn (yaratma). Tevhid, bu sıfatların yalnız Allah\'a ait ve O\'nunla kâim olduğunu kabul etmektir.',
  ),
  TeolojiKonu(
    'Kader ve Cüz\'î İrade',
    'Kader',
    'İlahî takdir ile insanın sorumluluğu nasıl bağdaşır?',
    'Kader, Allah\'ın her şeyi ezelî ilmiyle bilmesi ve takdir etmesidir. Ancak Allah\'ın bir fiili önceden BİLMESİ, o fiili kulun iradesi dışında ZORLA yaptırması anlamına gelmez; bilgi, bilinen şeye tâbidir. İnsana verilen "cüz\'î irade" (seçme gücü) ile fiillerini tercih eder, Allah da o tercihe göre fiili yaratır (Mâtürîdî görüşü). Böylece sorumluluk insana, yaratma Allah\'a aittir. Bu denge, ne her şeyi kadere yükleyen cebriyeciliğe ne de kulu kendi fiilinin tek yaratıcısı sayan aşırılığa düşer.',
  ),
  TeolojiKonu(
    'Kötülük Problemi',
    'Din Felsefesi',
    'İyi ve kâdir bir Tanrı varken neden kötülük ve acı var?',
    'Felsefenin en eski sorularından biridir (theodicy). İslam düşüncesinde birkaç cevap öne çıkar: (1) Kötülüğün çoğu, iyiliğin bilinmesi için zorunlu bir karşıtlıktır; ışık ancak karanlıkla anlaşılır. (2) Ahlakî kötülük, insana verilen özgür iradenin bir bedelidir; sınav ancak tercih imkânıyla anlamlıdır. (3) İnsanın sınırlı bakışı, bütünün hikmetini kavrayamaz; lokal görünen "şer", küllî planda hayra hizmet edebilir. (4) Bu dünya bir imtihan yurdudur; mutlak adalet âhirette tecellî eder. Bu yaklaşımlar acıyı önemsizleştirmez, ona anlam çerçevesi sunar.',
  ),
  TeolojiKonu(
    'Akıl–Vahiy İlişkisi',
    'Din Felsefesi',
    'Akıl ile vahiy çatışır mı, yoksa birbirini tamamlar mı?',
    'İslam düşüncesinin ana çizgisi, akıl ile vahyin aynı hakikatin iki kaynağı olduğu, dolayısıyla gerçekte çatışmayacağıdır. Akıl, vahyin doğruluğunu (Yaratıcının ve nübüvvetin imkânını) temellendirir; vahiy ise aklın tek başına ulaşamayacağı gayb bilgisini (âhiret, ibadetlerin biçimi) bildirir. Görünürde bir çelişki varsa, ya nakil yanlış yorumlanmıştır ya akıl yürütme hatalıdır. Mâtürîdî gelenek akla geniş yer verirken, bazı ekoller vahyin önceliğini vurgular; ancak ikisini büsbütün karşı karşıya koymak İslamî düşüncenin ana damarına aykırıdır.',
  ),
  TeolojiKonu(
    'Nübüvvetin Gerekliliği',
    'Nübüvvet',
    'İnsanın yalnız akılla yetinmeyip peygambere ihtiyacı vardır.',
    'Akıl, Yaratıcının varlığını ve genel ahlakî ilkeleri kavrayabilir; ancak ibadetin nasıl yapılacağı, âhiretin ayrıntıları, hayatın nihai amacı gibi konularda tek başına kesin bilgiye ulaşamaz. Üstelik insanların akılları, arzuları ve çıkarları farklı yönlere çeker. Peygamberler, vahiyle gelen sahih bilgiyi getirip insanlığa örnek bir hayat sunarak bu boşluğu doldurur. Mucizeler, peygamberin davasını doğrulayan ilahî tasdiktir. Böylece nübüvvet, ilahî rahmetin ve hidayetin zorunlu bir halkasıdır.',
  ),
  TeolojiKonu(
    'Mucize Nedir?',
    'Din Felsefesi',
    'Tabiat kanunlarının Yaratıcısı, onları aşan olaylar da yaratabilir.',
    'Mucize, peygamberlik iddiasına delil olmak üzere, âdetlerin (tabiat kanunlarının) Allah tarafından olağanüstü biçimde değiştirilmesidir. Felsefî açıdan kilit nokta şudur: Tabiat kanunları zorunlu değil, Allah\'ın "âdeti"dir (sünnetullah); onları koyan irade, dilediğinde istisna da yaratabilir. Mucize bir "kuralsızlık" değil, kuralın sahibinin imzasıdır. Mucize ile sihir/şarlatanlık arasındaki fark, mucizenin bir hak davayı desteklemesi ve meydan okumaya karşı taklit edilememesidir.',
  ),
  TeolojiKonu(
    'İman ve Bilgi',
    'Din Felsefesi',
    'İman kör bir kabul mü, yoksa delile dayalı bir teslimiyet mi?',
    'İslam düşüncesinde iman, delilsiz bir inanç sıçraması değildir; aklî ve fıtrî delillerle temellenen, ardından kalbî bir tasdik ve teslimiyetle tamamlanan bir bütündür. Bilgi (ilim) imanın zeminini hazırlar, fakat iman salt bilgiye indirgenmez; çünkü şeytan da Allah\'ın varlığını "biliyordu" ama teslim olmadı. İman, bilinen hakikate gönülden bağlanmak ve onun gereğince yaşamaktır. Bu yönüyle iman; akıl, kalp ve irade boyutlarını birleştirir.',
  ),
  TeolojiKonu(
    'Ruh ve Ölümsüzlük',
    'Âhiret',
    'İnsan yalnız bedenden mi ibarettir, yoksa kalıcı bir hakikati mi vardır?',
    'İslam düşüncesi insanı beden ve ruhun birliği olarak görür. Ruh, maddî olmayan, idrak ve iradenin merkezi olan bir hakikattir; bedenin ölümüyle yok olmaz, berzah âleminde varlığını sürdürür ve âhirette yeniden bedenle birleşir. Düşünme, "ben" bilinci, ahlakî sorumluluk gibi olgular, insanın salt maddeye indirgenemeyeceğine işaret eder. Ölümsüzlük inancı, ahlakın ve adaletin nihai bir temele oturması açısından da merkezîdir: Bu dünyada karşılığını bulmayan iyilik ve kötülük, âhirette tam karşılığını görür.',
  ),
  TeolojiKonu(
    'Tevhid: Birliğin Anlamı',
    'Tevhid',
    'Tevhid yalnızca "Tanrı bir" demek değil, bütün bir varlık tasavvurudur.',
    'Tevhid üç boyutta anlaşılır: (1) Rubûbiyet tevhidi — yaratan, yaşatan, rızık veren tek varlığın Allah olması. (2) Ulûhiyet tevhidi — yalnız O\'na ibadet edilmesi, kulluğun başka hiçbir varlığa yöneltilmemesi. (3) Esmâ ve sıfat tevhidi — kemâl sıfatlarının yalnız O\'na ait kılınması. Tevhid, kâinatı parçalı ve çatışan güçler yığını olarak değil, tek bir iradenin eseri olan anlamlı bir bütün olarak görmeyi sağlar. Bu bakış, insanı hem korkulardan hem de sahte ilahlara kullukten özgürleştirir.',
  ),
  TeolojiKonu(
    'İslam Ahlak Felsefesi',
    'Ahlak',
    'İyi ve kötünün ölçüsü nedir; erdem nasıl kazanılır?',
    'İslam ahlakı, iyiyi ve kötüyü hem vahyin bildirmesine hem de aklın kavrayışına dayandırır. Gazâlî gibi düşünürler, ahlakı "nefsin, fiilleri kolayca ve düşünmeden ortaya koyduğu yerleşik bir hâl (meleke)" olarak tanımlar; yani erdem, tekrar ve terbiye ile karakter hâline gelen iyiliktir. Amaç, aşırılık ve eksiklik arasındaki dengeyi (i\'tidâl) yakalamaktır: cesaret korkaklık ile atılganlık arasında, cömertlik cimrilik ile israf arasındadır. Nihaî gaye, güzel ahlakla Allah\'ın ahlakıyla ahlaklanmak ve kalbi arındırmaktır.',
  ),
];

class TeolojiScreen extends StatefulWidget {
  const TeolojiScreen({super.key});
  @override
  State<TeolojiScreen> createState() => _TeolojiScreenState();
}

class _TeolojiScreenState extends State<TeolojiScreen> {
  String _q = '';

  String _fold(String s) => s
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('İ', 'i')
      .replaceAll('ş', 's')
      .replaceAll('ğ', 'g')
      .replaceAll('ç', 'c')
      .replaceAll('ü', 'u')
      .replaceAll('ö', 'o');

  @override
  Widget build(BuildContext context) {
    final q = _fold(_q.trim());
    final list = q.isEmpty
        ? kTeolojiKonulari
        : kTeolojiKonulari
            .where((k) =>
                _fold(k.baslik).contains(q) ||
                _fold(k.ozet).contains(q) ||
                _fold(k.metin).contains(q) ||
                _fold(k.kategori).contains(q))
            .toList();
    final kategoriler = <String>[];
    for (final k in list) {
      if (!kategoriler.contains(k.kategori)) kategoriler.add(k.kategori);
    }

    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Din Felsefesi')),
      body: Column(children: [
        Container(
          color: QC.greenDark,
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: TextField(
            onChanged: (v) => setState(() => _q = v),
            style: GoogleFonts.lora(color: Color(0xFFFAF7F0), fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Konu ara (delil, kader, ruh, ahlak…)',
              hintStyle: GoogleFonts.lora(color: QC.greenPale, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: QC.goldLight),
              filled: true,
              fillColor: QC.greenMain.withAlpha(120),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 2),
            ),
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Text('"$_q" için konu bulunamadı.',
                      style: GoogleFonts.lora(color: QC.greenMid)))
              : ListView(
                  padding: const EdgeInsets.all(14),
                  children: [
                    for (final kat in kategoriler) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                        child: Row(children: [
                          Container(width: 4, height: 16, color: QC.gold),
                          const SizedBox(width: 8),
                          Text(kat,
                              style: GoogleFonts.lora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: QC.greenDark)),
                        ]),
                      ),
                      ...list.where((k) => k.kategori == kat).map(_tile),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
        ),
      ]),
    );
  }

  Widget _tile(TeolojiKonu k) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: QC.greenPale.withAlpha(150)),
      ),
      child: ListTile(
        leading: const Icon(Icons.lightbulb_outline_rounded, color: QC.gold),
        title: Text(k.baslik,
            style: GoogleFonts.lora(
                fontSize: 14.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
        subtitle: Text(k.ozet,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lora(fontSize: 12, color: QC.greenMid, height: 1.3)),
        trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
        onTap: () => _detay(k),
      ),
    );
  }

  void _detay(TeolojiKonu k) {
    showModalBottomSheet(
      context: context,
      backgroundColor: QC.greenBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: QC.greenPale, borderRadius: BorderRadius.circular(4))),
            ),
            const SizedBox(height: 16),
            Text(k.kategori.toUpperCase(),
                style: GoogleFonts.lora(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                    color: QC.gold)),
            const SizedBox(height: 4),
            Text(k.baslik,
                style: GoogleFonts.lora(
                    fontSize: 21, fontWeight: FontWeight.w800, color: QC.greenDark)),
            const SizedBox(height: 14),
            Text(k.metin,
                style: GoogleFonts.lora(fontSize: 15, height: 1.65, color: QC.greenDark)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
