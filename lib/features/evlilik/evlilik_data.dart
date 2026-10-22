// Evlilikte mahremiyet — İslami fıkha dayalı, edepli bir dille hazırlanmış
// soru-cevaplar. Amaç: eşler arası ilişkiyi İslam'ın helal-haram ölçüleri ve
// karşılıklı hak/edep çerçevesinde bilgilendirmek.

class EvlilikSoru {
  final String kategori;
  final String soru;
  final String cevap;
  const EvlilikSoru(this.kategori, this.soru, this.cevap);
}

const List<EvlilikSoru> kEvlilikSorular = [
  // ── Temel Ölçüler ──
  EvlilikSoru('Temel Ölçüler',
      'İslam\'da eşler arası cinsellik nasıl değerlendirilir?',
      'İslam, evlilik içindeki cinselliği kirli veya ayıp bir şey olarak değil, meşru, temiz ve hatta sevap kazandıran bir nimet olarak görür. Peygamberimiz (s.a.v.), eşine helal yoldan yaklaşmanın bile sadaka (sevap) olduğunu bildirmiştir. Nikâh, bu ilişkiyi helal kılan meşru zemindir.'),
  EvlilikSoru('Temel Ölçüler',
      'Cinsellik sadece çocuk için mi, yoksa haz da meşru mudur?',
      'İslam\'da cinselliğin amacı yalnızca üreme değildir; eşlerin birbirinden helal yoldan haz alması, huzur bulması ve birbirine bağlanması da meşrudur ve teşvik edilir. Kur\'an eşleri birbirinin "elbisesi" (Bakara 187) olarak niteler; bu, örten, koruyan ve yakınlaştıran bir ilişkiye işaret eder.'),
  EvlilikSoru('Temel Ölçüler',
      'Eşler arasında mahremiyetin sınırı nedir?',
      'Kural olarak, karı-koca arasında bakma ve dokunmada geniş bir helallik vardır; birbirlerinin her yerine bakabilir ve dokunabilirler. Bunun istisnaları haram olan fiillerdir (arka yoldan ilişki, hayız/nifas hâlinde ilişki gibi). Bunun dışında karşılıklı rızayla pek çok yakınlık meşrudur.'),
  EvlilikSoru('Temel Ölçüler',
      'Eşler cinsellikte birbirini çıplak görebilir mi?',
      'Evet. Karı-koca birbirinin bedenini görebilir; bunda dinî bir sakınca yoktur. Ancak edep ve haya İslam\'ın genel bir ölçüsüdür; ölçü, karşılıklı rıza ve mahremiyetin korunmasıdır (üçüncü kişilere gösterilmemesi, kaydedilmemesi).'),

  // ── Haramlar ──
  EvlilikSoru('Haram Olanlar',
      'Hangi durumlarda eşle ilişki haramdır?',
      'Başlıca haramlar: (1) Kadının hayız (âdet) ve nifas (lohusalık) hâlinde ilişki; (2) arka yoldan (dübürden) ilişki — bu kesin haramdır; (3) oruçlu iken gündüz (Ramazan\'da) ilişki; (4) ihramlı iken (hac/umre) ilişki. Bunlar dışında eşler arası ilişki helaldir.'),
  EvlilikSoru('Haram Olanlar',
      'Âdet (hayız) hâlinde ilişki neden yasaktır?',
      'Kur\'an, hayız hâlinde ilişkiden uzak durulmasını emreder (Bakara 222). Bu bir eziyet/rahatsızlık hâli kabul edilir. Ancak ilişki dışında sarılmak, okşamak, birlikte olmak yasak değildir; yalnızca cinsel birleşme bu dönemde ertelenir. Kan kesilip gusledildikten sonra ilişki yeniden helal olur.'),
  EvlilikSoru('Haram Olanlar',
      'Arka yoldan ilişki hakkında İslam ne der?',
      'Arka yoldan (dübürden) ilişki İslam\'da açıkça haram kılınmıştır ve büyük günahlardan sayılır. Peygamberimiz bunu yasaklamıştır. Meşru olan, tabii yoldan ilişkidir.'),
  EvlilikSoru('Haram Olanlar',
      'Ramazan\'da gündüz eşle ilişki kurulursa ne olur?',
      'Ramazan orucu tutarken gündüz bilerek ilişkiye girmek orucu bozar ve keffâret gerektirir (art arda 60 gün oruç ya da gücü yetmezse 60 fakiri doyurmak). İftardan sonra (gece) ise ilişki helaldir. Sahura kadar helal olduğu Kur\'an\'da belirtilir (Bakara 187).'),

  // ── Temizlik ve Gusül ──
  EvlilikSoru('Temizlik & Gusül',
      'İlişkiden sonra gusül (boy abdesti) şart mıdır?',
      'Evet. Cinsel birleşme veya meninin gelmesiyle kişi "cünüp" olur ve namaz kılabilmek, Kur\'an\'a dokunabilmek için gusletmesi gerekir. Gusül; ağza-buruna su vermek ve tüm bedeni yıkamakla olur. İlişki sonrası hemen gusül şart değildir, ama namaz vakti girmeden veya uyumadan önce yapılması güzeldir.'),
  EvlilikSoru('Temizlik & Gusül',
      'Gusül almadan uyunabilir mi?',
      'Cünüp olarak uyumak câizdir, günah değildir. Ancak Peygamberimizin, uyumadan önce hiç değilse abdest almayı tavsiye ettiği rivayet edilir. En güzeli, imkân varsa gusletmektir; ama zorunlu değildir.'),
  EvlilikSoru('Temizlik & Gusül',
      'Tekrar ilişkiye girmeden önce ne yapılır?',
      'İki ilişki arasında yeniden gusül şart değildir; ancak arada abdest almak müstehaptır (tavsiye edilir), çünkü bu tekrar için canlılık verir. Nihai olarak namaz vaktinden önce bir kez gusül yeterlidir.'),

  // ── Karşılıklı Haklar ──
  EvlilikSoru('Karşılıklı Haklar',
      'Eşin cinsel ihtiyacını karşılamak dinî bir sorumluluk mudur?',
      'Evet. İslam, eşlerin birbirinin meşru ihtiyacını karşılamasını önemli bir hak sayar. Kadının da erkeğin de bu konuda hakkı vardır. Geçerli bir mazeret olmadan eşi sürekli reddetmek, evlilik hukukunda hoş karşılanmaz. Ölçü, karşılıklı sevgi, anlayış ve nezakettir.'),
  EvlilikSoru('Karşılıklı Haklar',
      'Kadının da cinsel hazza hakkı var mıdır?',
      'Kesinlikle evet. İslam âlimleri, erkeğin eşini tatmin etmeden aceleci davranmasını hoş görmemiş; ön sevginin (okşama, sevgi sözleri) önemine dikkat çekmişlerdir. Kadının duygusal ve bedensel tatmini gözetilmesi gereken bir haktır.'),
  EvlilikSoru('Karşılıklı Haklar',
      'Ön sevişme (mukaddime) hakkında İslam ne der?',
      'İslam âlimleri, doğrudan ilişkiye geçmeden önce sevgi sözleri, okşama ve yakınlaşmayı (mukaddime) tavsiye etmiştir. Bunun eşler arası sevgiyi artırdığı ve özellikle kadının hazzı için önemli olduğu belirtilir. Aceleci davranmak edebe aykırı görülür.'),
  EvlilikSoru('Karşılıklı Haklar',
      'Eş, ilişkiyi mazeretsiz reddedebilir mi?',
      'Geçerli bir mazeret (hastalık, aşırı yorgunluk, âdet hâli vb.) varsa elbette. Ancak sürekli ve sebepsiz reddetmek, karşı tarafa haksızlık ve evlilik bağını zayıflatan bir tutum olarak görülür. Çözüm; iletişim, anlayış ve karşılıklı fedakârlıktır.'),

  // ── Edep ve Mahremiyet ──
  EvlilikSoru('Edep & Mahremiyet',
      'İlişki mahremiyetini başkalarıyla paylaşmak câiz mi?',
      'Hayır. Peygamberimiz, eşler arası mahrem hayatı başkalarına anlatmayı en çirkin davranışlardan saymıştır. "Kıyamet günü Allah katında en kötü konumda olanlardan biri, eşiyle mahremiyetini yaşayıp sonra bunu ifşa eden kişidir" buyurmuştur. Bu, gizli tutulması gereken bir emanettir.'),
  EvlilikSoru('Edep & Mahremiyet',
      'İlişki anında dua veya besmele var mıdır?',
      'Evet. Peygamberimizin, eşe yaklaşırken "Bismillâh, Allâhümme cennibnâ\'ş-şeytân..." (Allah\'ım, bizi şeytandan uzak tut ve bize vereceğin çocuğu şeytandan koru) şeklinde dua etmeyi tavsiye ettiği rivayet edilir. Besmele ile başlamak bereket sayılır.'),
  EvlilikSoru('Edep & Mahremiyet',
      'İlişki sırasında görüntü/ses kaydı almak câiz mi?',
      'Hayır. Mahrem anların kaydedilmesi, sızma/ifşa riski taşıdığı ve mahremiyetin korunması emri gereği câiz görülmez. İslam, bu ilişkinin tümüyle gizli ve iki kişiye ait kalmasını ister.'),

  // ── Doğum Kontrolü ve Sağlık ──
  EvlilikSoru('Sağlık & Aile Planlaması',
      'İslam\'da doğum kontrolü (azil, korunma) câiz mi?',
      'Geçici korunma yöntemleri (azil ve benzeri), çoğu âlime göre eşlerin karşılıklı rızasıyla câizdir. Peygamber döneminde azil uygulanmış ve yasaklanmamıştır. Ancak kalıcı kısırlaştırma, meşru bir tıbbi zaruret olmadıkça uygun görülmez. Aile planlaması, eşlerin ortak kararıyla olmalıdır.'),
  EvlilikSoru('Sağlık & Aile Planlaması',
      'Kürtaj İslam\'da câiz midir?',
      'Kural olarak câiz değildir; ceninin canına kıymak büyük sorumluluktur. Ancak annenin hayatını tehdit eden gerçek bir tıbbi zaruret gibi istisnai durumlar, ehil âlim ve hekim görüşüyle ayrıca değerlendirilir. Bu, kişisel karar değil, ehline danışılacak bir meseledir.'),
  EvlilikSoru('Sağlık & Aile Planlaması',
      'Hamilelikte ilişki câiz mi?',
      'Evet, hamilelik döneminde ilişki câizdir ve anne-bebek için tıbbi bir engel yoksa sakıncası yoktur. Doktorun risk belirttiği özel durumlarda ise sağlık tavsiyesine uyulur.'),

  // ── Sık Sorulanlar ──
  EvlilikSoru('Sık Sorulanlar',
      'Eşler birbirine cinsel konuları konuşabilir mi?',
      'Evet. Eşlerin isteklerini, hoşlandıklarını ve rahatsızlıklarını edepli bir dille birbirine anlatması sağlıklı ve tavsiye edilen bir şeydir. Sağlıklı bir mahrem hayat, açık ama nazik iletişimle kurulur.'),
  EvlilikSoru('Sık Sorulanlar',
      'Cinsel isteksizlik yaşanırsa ne yapılmalı?',
      'İsteksizliğin bedensel (hormonal, yorgunluk, hastalık) veya duygusal (stres, kırgınlık, iletişimsizlik) sebepleri olabilir. Önce sebep anlaşılmalı; gerekirse doktora başvurulmalıdır. İslam, bu konuda sabrı, anlayışı ve birbirini suçlamadan çözüm aramayı öğütler.'),
  EvlilikSoru('Sık Sorulanlar',
      'Eşlerden biri diğerini bu konuda zorlayabilir mi?',
      'İlişki karşılıklı rıza ve sevgiyle olmalıdır. Sevgisiz zorlama, İslam\'ın öngördüğü "meveddet ve rahmet" (sevgi ve merhamet) ilkesine aykırıdır. Hak talep etmekle kaba kuvvet uygulamak farklıdır; esas olan nezaket ve karşılıklı gözetmedir.'),
  EvlilikSoru('Sık Sorulanlar',
      'Mahrem hayatta çeşitlilik (farklı pozisyonlar) câiz mi?',
      'Haram olan iki şey dışında (arka yoldan ilişki ve âdet hâlinde ilişki), eşlerin tabii yoldan olmak kaydıyla tercih ettikleri şekiller karşılıklı rızayla câizdir. Kur\'an "Eşlerinize dilediğiniz gibi yaklaşabilirsiniz" (Bakara 223) buyurur — bu, meşru sınırlar içinde genişlik tanır.'),
  EvlilikSoru('Sık Sorulanlar',
      'Cinsellikten sonra hemen konuşmak/uyumak mı gerekir?',
      'Bu tümüyle eşlerin tercihine kalmıştır; dinî bir kural yoktur. Ancak ilişki sonrası sevgi, şefkat ve yakınlığın sürdürülmesi (soğuk davranmamak) evlilik bağını güçlendirir ve güzel ahlakın bir parçasıdır.'),
  EvlilikSoru('Sık Sorulanlar',
      'Bu konuları öğrenmek/araştırmak ayıp mı?',
      'Hayır. İslam ilmi teşvik eder; sahabe hanımları Peygamberimize ve eşi Hz. Âişe\'ye mahrem konuları çekinmeden sorarlardı. "Haya, hakkı öğrenmeye engel değildir." Bilgiyle, edep ölçüsü içinde öğrenmek meşrudur.'),
];
