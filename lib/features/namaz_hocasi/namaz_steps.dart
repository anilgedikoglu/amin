// Namaz Hocası — namazın pozisyonları (adımları), açıklamaları ve
// her adımda okunan dualar (Arapça + okunuş + anlam).
// Görseller: assets/namaz_hocasi/ (kullanıcı tarafından sağlandı).

class NamazOkuma {
  final String ad; // duanın adı
  final String arapca;
  final String okunus;
  final String anlam;
  const NamazOkuma(this.ad, this.arapca, this.okunus, this.anlam);
}

class NamazAdim {
  final int id;
  final String baslik;
  final String aciklama; // pozisyon nasıl yapılır
  final String image; // asset adı (assets/namaz_hocasi/...)
  final List<NamazOkuma> okumalar;
  const NamazAdim({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.image,
    this.okumalar = const [],
  });
}

const String _kNamazAssetDir = 'assets/namaz_hocasi/';
String namazImage(String file) => '$_kNamazAssetDir$file';

const List<NamazAdim> kNamazAdimlari = [
  NamazAdim(
    id: 1,
    baslik: 'Niyet ve Hazırlık',
    aciklama:
        'Kıbleye yönelip ayakta, kollar yanda dururken kalben niyet edilir. '
        'Örneğin: "Niyet ettim Allah rızası için … namazını kılmaya."',
    image: 'namaz_01_normal_durus_hazirlik.png',
    okumalar: [
      NamazOkuma('Niyet', 'نَوَيْتُ',
          'Niyet ettim Allah rızası için bugünkü … namazını kılmaya.',
          'Namaza hangi vakit için durulduğu kalben kararlaştırılır.'),
    ],
  ),
  NamazAdim(
    id: 2,
    baslik: 'İftitah (Başlangıç) Tekbiri',
    aciklama:
        'Eller kulak hizasına kaldırılır (kadınlar omuz hizasına), '
        '"Allâhu Ekber" denilerek eller bağlanır ve namaza başlanır.',
    image: 'namaz_03_iftitah_tekbiri.png',
    okumalar: [
      NamazOkuma('Tekbir', 'اللَّهُ أَكْبَرُ', 'Allâhu Ekber',
          'Allah en büyüktür.'),
    ],
  ),
  NamazAdim(
    id: 3,
    baslik: 'Kıyam (Ayakta Duruş)',
    aciklama:
        'Eller göbek altında (kadınlar göğüs üzerinde) bağlı, gözler secde '
        'yerine bakar. Sübhâneke, Eûzü-Besmele, Fâtiha ve bir sûre okunur.',
    image: 'namaz_02_kiyam.png',
    okumalar: [
      NamazOkuma(
          'Sübhâneke',
          'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَى جَدُّكَ وَلَا إِلَٰهَ غَيْرُكَ',
          'Sübhânekellâhümme ve bi-hamdik ve tebârekesmük ve teâlâ ceddük ve lâ ilâhe ğayrük.',
          'Allah\'ım! Seni tenzih ederim, sana hamd ederim. Senin adın mübarektir, şanın yücedir, senden başka ilah yoktur.'),
      NamazOkuma('Eûzü-Besmele',
          'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          'Eûzü billâhi mineş-şeytânir-racîm. Bismillâhir-rahmânir-rahîm.',
          'Kovulmuş şeytandan Allah\'a sığınırım. Rahmân ve Rahîm olan Allah\'ın adıyla.'),
      NamazOkuma('Fâtiha Sûresi',
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ...',
          'Elhamdü lillâhi rabbil-âlemîn… (Fâtiha okunur)',
          'Hamd, âlemlerin Rabbi Allah\'a mahsustur… Ardından bir sûre (zamm-ı sûre) okunur.'),
    ],
  ),
  NamazAdim(
    id: 4,
    baslik: 'Rükû',
    aciklama:
        '"Allâhu Ekber" denilerek belden eğilinir; eller dizlere konur, '
        'sırt düz tutulur. Üç kez tesbih okunur.',
    image: 'namaz_04_ruk.png',
    okumalar: [
      NamazOkuma('Rükû Tesbihi', 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
          'Sübhâne Rabbiyel-azîm (3 kez)',
          'Yüce olan Rabbimi tenzih ederim.'),
    ],
  ),
  NamazAdim(
    id: 5,
    baslik: 'Kavme (Doğrulma)',
    aciklama: 'Rükûdan "Semiallâhü limen hamideh" diyerek tam ayağa kalkılır.',
    image: 'namaz_05_kavme.png',
    okumalar: [
      NamazOkuma('Tesmî', 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ',
          'Semiallâhü limen hamideh',
          'Allah, kendisine hamd edeni işitir.'),
      NamazOkuma('Tahmîd', 'رَبَّنَا لَكَ الْحَمْدُ', 'Rabbenâ lekel-hamd',
          'Rabbimiz! Hamd yalnız sanadır.'),
    ],
  ),
  NamazAdim(
    id: 6,
    baslik: 'Birinci Secde',
    aciklama:
        '"Allâhu Ekber" denilerek secdeye varılır; alın ve burun yere değer, '
        'eller baş hizasında, parmaklar kıbleye dönük. Üç kez tesbih okunur.',
    image: 'namaz_06_birinci_secde.png',
    okumalar: [
      NamazOkuma('Secde Tesbihi', 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
          'Sübhâne Rabbiyel-a\'lâ (3 kez)',
          'En yüce olan Rabbimi tenzih ederim.'),
    ],
  ),
  NamazAdim(
    id: 7,
    baslik: 'Celse (İki Secde Arası)',
    aciklama:
        '"Allâhu Ekber" denilerek doğrulup kısa bir süre oturulur, '
        'eller dizler üzerinde durur.',
    image: 'namaz_07_celse.png',
    okumalar: [
      NamazOkuma('Oturuş', 'اللَّهُ أَكْبَرُ', 'Allâhu Ekber',
          'İki secde arasında bir miktar beklenir (bir tesbih müddeti).'),
    ],
  ),
  NamazAdim(
    id: 8,
    baslik: 'İkinci Secde',
    aciklama:
        '"Allâhu Ekber" denilerek ikinci secdeye varılır; birinci secde ile '
        'aynı şekilde üç kez tesbih okunur.',
    image: 'namaz_08_ikinci_secde.png',
    okumalar: [
      NamazOkuma('Secde Tesbihi', 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
          'Sübhâne Rabbiyel-a\'lâ (3 kez)',
          'En yüce olan Rabbimi tenzih ederim.'),
    ],
  ),
  NamazAdim(
    id: 9,
    baslik: 'Tahiyyat (Ka\'de / Oturuş)',
    aciklama:
        'Son oturuşta sol ayak üzerine oturulur, eller dizler üzerine konur. '
        'Tahiyyat\'ta "lâ ilâhe" derken sağ işaret parmağı kaldırılır.',
    image: 'namaz_09_tahiyyat_kade.png',
    okumalar: [
      NamazOkuma('Ettehiyyâtü',
          'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ ...',
          'Ettehiyyâtü lillâhi vessalevâtü vettayyibât…',
          'Bütün dualar, ibadetler ve iyilikler Allah\'a mahsustur…'),
      NamazOkuma('Allâhümme Salli',
          'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ',
          'Allâhümme salli alâ Muhammedin ve alâ âli Muhammed…',
          'Allah\'ım! Muhammed\'e ve ailesine rahmet eyle…'),
      NamazOkuma('Allâhümme Bârik',
          'اللَّهُمَّ بَارِكْ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ',
          'Allâhümme bârik alâ Muhammedin ve alâ âli Muhammed…',
          'Allah\'ım! Muhammed\'e ve ailesine bereket ihsan eyle…'),
      NamazOkuma('Rabbenâ Âtinâ',
          'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً',
          'Rabbenâ âtinâ fid-dünyâ haseneten ve fil-âhirati haseneten ve kınâ azâben-nâr.',
          'Rabbimiz! Bize dünyada da ahirette de iyilik ver, bizi ateş azabından koru.'),
    ],
  ),
  NamazAdim(
    id: 10,
    baslik: 'Selam (Sağa)',
    aciklama:
        'Baş sağ omuza çevrilerek "Esselâmü aleyküm ve rahmetullâh" denir.',
    image: 'namaz_10_selam_saga.png',
    okumalar: [
      NamazOkuma('Selam', 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
          'Esselâmü aleyküm ve rahmetullâh',
          'Allah\'ın selâmı ve rahmeti üzerinize olsun.'),
    ],
  ),
  NamazAdim(
    id: 11,
    baslik: 'Selam (Sola)',
    aciklama:
        'Baş sol omuza çevrilerek "Esselâmü aleyküm ve rahmetullâh" denir; '
        'böylece namaz tamamlanır.',
    image: 'namaz_11_selam_sola.png',
    okumalar: [
      NamazOkuma('Selam', 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ',
          'Esselâmü aleyküm ve rahmetullâh',
          'Allah\'ın selâmı ve rahmeti üzerinize olsun.'),
    ],
  ),
];
