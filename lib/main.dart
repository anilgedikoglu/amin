import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  AdManager.instance.load();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
  runApp(const AminApp());
}

// ── ADMOB ─────────────────────────────────
class AdManager {
  static final AdManager instance = AdManager._();
  AdManager._();

  static const _adUnitId = 'ca-app-pub-6470338276121414/3936380770';
  InterstitialAd? _ad;
  bool _loading = false;

  void load() {
    if (_loading || _ad != null) return;
    _loading = true;
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) { _ad = null; load(); },
            onAdFailedToShowFullScreenContent: (_, __) { _ad = null; load(); },
          );
        },
        onAdFailedToLoad: (_) {
          _loading = false;
          Future.delayed(const Duration(minutes: 1), load);
        },
      ),
    );
  }

  void show() => _ad?.show();
}

class _BackPressObserver extends NavigatorObserver {
  int _count = 0;
  @override
  void didPop(Route route, Route? previousRoute) {
    _count++;
    if (_count % 5 == 0) AdManager.instance.show();
  }
}

final _backPressObserver = _BackPressObserver();

class AC {
  static const greenDark  = Color(0xFF1a4731);
  static const greenMain  = Color(0xFF2d6a4f);
  static const greenMid   = Color(0xFF40916c);
  static const greenLight = Color(0xFF74c69d);
  static const greenPale  = Color(0xFFb7e4c7);
  static const greenBg    = Color(0xFFd8f3dc);
  static const gold       = Color(0xFFc9a84c);
  static const goldLight  = Color(0xFFf0d080);
  static const brownDark  = Color(0xFF5C3A1E);
}

// ── MODEL ─────────────────────────────────
class Niyet {
  final int    id;
  final String icon, isim, sub, duaAdi;
  final int    hedef;
  final String arabic, latin, turkish, tip;
  const Niyet({required this.id, required this.icon, required this.isim,
    required this.sub, required this.duaAdi, required this.hedef,
    required this.arabic, required this.latin, required this.turkish, required this.tip});
}

class Kategori {
  final int    id;
  final String icon, isim, sub;
  final List<int> niyetIds;
  final bool isZikir;
  const Kategori({required this.id, required this.icon, required this.isim,
    required this.sub, required this.niyetIds, this.isZikir = false});
}

class Zikir {
  final int    id;
  final String icon, isim, anlam, hikmet;
  final int    hedef;
  const Zikir({required this.id, required this.icon, required this.isim,
    required this.anlam, required this.hikmet, required this.hedef});
}

// ── VERİ ──────────────────────────────────
const List<Niyet> niyetler = [
  // ── Mevcut dualar 1-21 ──
  Niyet(id:1, icon:"⭐", isim:"Salat-ı Tefriciye", sub:"Dilek gerçekleşmesi",
    duaAdi:"Salat-ı Tefriciye", hedef:4444,
    arabic:"اللَّهُمَّ صَلِّ صَلَاةً كَامِلَةً وَسَلِّمْ سَلَامًا تَامًّا",
    latin:"Allahümme salli salaten kamileten ve sellim selamen tammen\n'alâ seyyidinâ Muhammedinillezî tenfecicü bihil ukadü\nve tenfericü bihil kürebü ve tüksâ bihil mehârifü\nve tünâlü bihil regâibü ve hüsnül hatimeti\nve yüsteskal garâmü bi vechihil kerimi\nve 'alâ âlihi ve sahbihî fî külli lemhatin ve nefesin\nbi adedi külli ma'lumin lek.",
    turkish:"Allah'ım! Efendimiz Muhammed'e tam ve eksiksiz salavat ve selam getir. O ki onunla düğümler çözülür, sıkıntılar giderilir, ihtiyaçlar karşılanır, dileğe ulaşılır.",
    tip:"Salat-ı Tefriciye günlük 4444 kez okunmasını tavsiye eder ulema. Sabah namazından sonra okunması en fazîletlidir."),
  Niyet(id:2, icon:"🛡️", isim:"Muavvizeteyn", sub:"Nazardan korunma",
    duaAdi:"Felak & Nas Suresi", hedef:41,
    arabic:"قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
    latin:"Kul e'ûzü bi rabbil felak.\nMin şerri mâ halak.\nVe min şerri gâsikin izâ vekab.\nVe min şerrin neffâsâti fil 'ukad.\nVe min şerri hâsidin izâ hased.",
    turkish:"De ki: Sığınırım sabahın Rabbine. Yarattığı şeylerin şerrinden. Karardığında gecenin şerrinden. Düğümlere üfleyenlerin şerrinden. Haset ettiğinde hasetçinin şerrinden.",
    tip:"Felak ve Nas surelerini ardı ardına 41 kez oku. Nazar değdiğinde gün boyunca okunabilir."),
  Niyet(id:3, icon:"💞", isim:"Yasin Suresi", sub:"Kavuşma ve hasret",
    duaAdi:"Yasin (İlk Ayetler)", hedef:7,
    arabic:"يس ۚ وَالْقُرْآنِ الْحَكِيمِ",
    latin:"Yâsîn. Vel Kur'ânil hakîm.\nİnneke le minel murselîn.\n'Alâ sırâtın mustekîm.\nTenzîlel 'azîzir rahîm.",
    turkish:"Yâsîn. Hikmet dolu Kur'an'a andolsun ki sen gerçekten gönderilmiş peygamberlerdensin. Dosdoğru bir yol üzeresin.",
    tip:"Yasin suresini 7 kez okumak kavuşma ve hasret giderici olarak rivayet edilmiştir."),
  Niyet(id:4, icon:"📚", isim:"Dua-yı İlim", sub:"Sınav ve başarı",
    duaAdi:"Rabbi Zidni İlma", hedef:100,
    arabic:"رَبِّ زِدْنِي عِلْمًا",
    latin:"Rabbi zidnî 'ilmâ.\nVe fehmen ve hıfzan.\nAllahümme fettah aleynâ hikmeteke\nve ensür aleynâ min hazâini rahmetike\nyâ Erhamer râhimîn.",
    turkish:"Rabbim! İlmimi artır, anlayış ve hafıza ver. Allah'ım! Üzerimize hikmeti kapılarını aç.",
    tip:"Sınav sabahı 100 kez okunur. Hz. Musa'nın Kur'an'da geçen bu duası ilim ve anlayışa vesiledir."),
  Niyet(id:5, icon:"💊", isim:"Şifa & Afiyet Duası", sub:"Şifa bulmak ve korunma",
    duaAdi:"Şifa Duası", hedef:7,
    arabic:"اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ",
    latin:"Allahümme Rabban nâs, ezhibilbe's.\nİşfî entaşşâfî lâ şifâe illâ şifâük.\nŞifâen lâ yugâdiru sekamâ.",
    turkish:"Allah'ım, ey insanların Rabbi! Bu hastalığı gider. Şifa ver, sen şifa verensin. Senin şifandan başka şifa yoktur.",
    tip:"Hz. Peygamber sav. hasta ziyaretinde bu duayı okuturdu. 7 kez okunur."),
  Niyet(id:6, icon:"💰", isim:"Vâkıa Suresi", sub:"Rızık ve bereket",
    duaAdi:"Vâkıa Suresi", hedef:56,
    arabic:"وَتَجْعَلُونَ رِزْقَكُمْ أَنَّكُمْ تُكَذِّبُونَ",
    latin:"Ve tec'alûne rızkakum\nennekum tükezzibûn.\nFe levlâ izâ belegatil hulkûm.\nVe entüm hîneiziN tenzurûn.",
    turkish:"Siz rızkınızı yalanlamayı mı görev ediniyorsunuz? Haydi can boğaza geldiğinde… Ve siz o anda bakıp duruyorsunuz.",
    tip:"Hazreti Ali ra. fakirlikten şikâyete gelen birine Vakıa suresini tavsiye etmiştir."),
  Niyet(id:7, icon:"💳", isim:"Borç Duası", sub:"Borçtan kurtulma",
    duaAdi:"Borç Duası (Hz. Ali)", hedef:100,
    arabic:"اللَّهُمَّ اكْفِنِي بِحَلالِكَ عَنْ حَرَامِكَ",
    latin:"Allahümmekfinî bi halâlike 'an harâmik.\nVe ağninî bi fadlike 'ammen sıvâk.\nYâ Muğnî yâ Ganiyy\nağninâ min fadlike yâ Kerîm.",
    turkish:"Allah'ım! Helalinle beni haramdan koru. Fazlınla beni başkasından müstağni eyle. Ey Muğni, ey Ganiyy! Fazlınla bizi zengin eyle.",
    tip:"Hz. Ali ra.'ya borç sıkıntısı için öğretildiği rivayet edilir. Sabah ve akşam 100'er kez okunur."),
  Niyet(id:8, icon:"💍", isim:"Tâhâ Suresi", sub:"Evlilik ve hayırlı eş",
    duaAdi:"Tâhâ (İlk Ayetler)", hedef:41,
    arabic:"طه ۚ مَا أَنزَلْنَا عَلَيْكَ الْقُرْآنَ لِتَشْقَىٰ",
    latin:"Tâhâ. Mâ enzelna aleykel Kur'âne litaşkâ.\nİllâ tezkiraten limen yahşâ.\nTenzîlen mimmen halekale arda vessamâvâtil 'ulâ.\nErrahmânu alel 'arşistevâ.",
    turkish:"Tâhâ. Biz Kur'an'ı sana güçlük çekmen için indirmedik. Ancak Allah'tan korkanlar için bir öğüt olarak.",
    tip:"Hayırlı eş için Taha suresinin ilk ayetleri 41 gün sabah namazı ardından okunur."),
  Niyet(id:9, icon:"👶", isim:"Hz. Zekeriyya Duası", sub:"Çocuk sahibi olmak",
    duaAdi:"Hz. Zekeriyya'nın Duası", hedef:33,
    arabic:"رَبِّ لَا تَذَرْنِي فَرْدًا وَأَنتَ خَيْرُ الْوَارِثِينَ",
    latin:"Rabbi lâ tezernî ferden\nve ente hayrul vârisîn.\nReb'bi heb lî min ledünke zurriyyeten tayyibeh.\nİnneke semî'ud du'â.",
    turkish:"Rabbim! Beni tek başıma bırakma, sen varislerin en hayırlısısın. Rabbim! Katından bana salih bir nesil bağışla.",
    tip:"Hz. Zekeriyya as.'ın Kur'an'da geçen duasıdır. Çocuk sahibi olmak isteyenler için 33 kez okunur."),
  Niyet(id:10, icon:"✨", isim:"Kelime-i Tevhid", sub:"Kalp huzuru",
    duaAdi:"Kelime-i Tevhid Zikreti", hedef:1000,
    arabic:"لَا إِلَٰهَ إِلَّا اللَّهُ",
    latin:"Lâ ilâhe illallah.\nMuhammedün Resûlullah.\nLâ ilâhe illallahul melikul hakkul mübîn.",
    turkish:"Allah'tan başka ilah yoktur. Muhammed Allah'ın Resulüdür. Hak melik Allah'tan başka ilah yoktur.",
    tip:"Kelime-i Tevhid'in günde 1000 kez tekrarı kalp huzurunu ve Allah'a yakınlığı artırır."),
  Niyet(id:11, icon:"😨", isim:"Nas Suresi", sub:"Korku ve kaygıdan kurtulma",
    duaAdi:"Nas Suresi", hedef:100,
    arabic:"قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
    latin:"Kul e'ûzü bi rabbin nâs.\nMelikin nâs.\nİlâhin nâs.\nMin şerril vesvâsil hannâs.\nEllezî yüvesvisü fî sudûrin nâs.\nMinel cinneti ven nâs.",
    turkish:"De ki: Sığınırım insanların Rabbine. İnsanların melikine. İnsanların ilahına. Sinsi vesvesecinin şerrinden.",
    tip:"Korku ve vesveseden korunmak için Nas Suresi 100 kez okunur."),
  Niyet(id:12, icon:"💼", isim:"Duhâ Suresi", sub:"İş ve geçim bulmak",
    duaAdi:"Duhâ Suresi", hedef:11,
    arabic:"وَالضُّحَىٰ ۞ وَاللَّيْلِ إِذَا سَجَىٰ",
    latin:"Vedduhâ.\nVel leyli izâ secâ.\nMâ vedde'ake rabbüke ve mâ kalâ.\nVel âhiretü hayrun leke minel ûlâ.\nVe le sevfe yu'tîke rabbüke fe terdâ.",
    turkish:"Kuşluk vaktine andolsun! Karardığında geceye andolsun! Rabbin seni ne bıraktı ne de sana darıldı.",
    tip:"Duhâ suresi bolluğun hatırlatıcısıdır. İş aramak için 11 kez okunur."),
  Niyet(id:13, icon:"🙏", isim:"Seyyidul İstiğfar", sub:"Günahlardan arınma",
    duaAdi:"Seyyidul İstiğfar", hedef:1000,
    arabic:"اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنتَ",
    latin:"Allahümme ente rabbî lâ ilâhe illâ ent.\nHalaktenî ve ene abdük.\nVe ene 'alâ ahdike ve va'dike masteta'tü.\nE'ûzü bike min şerri mâ sana'tü.\nEbû'ü leke bi ni'metike 'aleyye\nve ebû'ü bi zenbî fağfir lî\nfe innehû lâ yağfiruż żünûbe illâ ent.",
    turkish:"Allah'ım! Sen benim Rabbimsin. Senden başka ilah yoktur. Sen beni yarattın ve ben senin kulunum. Beni bağışla. Günahları senden başkası bağışlayamaz.",
    tip:"Seyyidul İstiğfar, istiğfarların efendisidir. Sabah ve akşam söyleyenin günahlarının bağışlanacağı hadiste bildirilmiştir."),
  Niyet(id:14, icon:"✈️", isim:"Seyahat Duası", sub:"Yolculukta selamet",
    duaAdi:"Seyahat Duası", hedef:3,
    arabic:"سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا",
    latin:"Sübhânellezî sahhara lenâ hâzâ\nve mâ künnâ lehû mukrinîn.\nVe innâ ilâ Rabbinâ le münkalibûn.\nAllahümme innâ nes'elüke fî seferinâ\nhâzâ el birre vettakvâ.",
    turkish:"Bize bunu boyun eğdiren Allah'ı tesbih ederiz. Şüphesiz biz Rabbimize döneceğiz. Allah'ım bu yolculuğumuzda iyilik ve takva dile.",
    tip:"Yolculuğa çıkmadan önce 3 kez okunur. Hz. Peygamber sav.'in yolculuklarda okuduğu duadır."),
  Niyet(id:15, icon:"⚔️", isim:"Ayetel Kürsî", sub:"Düşman şerrinden korunma",
    duaAdi:"Ayetel Kürsî", hedef:100,
    arabic:"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ",
    latin:"Allahü lâ ilâhe illâ hüvel hayyül kayyûm.\nLâ te'huzühû sinetün velâ nevm.\nLehû mâ fis semâvâti vemâ fil ard.\nMen zellezî yeşfe'u 'indehû illâ biiznih.\nvesi'a kürsiyyühüs semâvâti vel ard.\nvelâ yeûdühû hıfzuhumâ ve hüvel 'aliyyül 'azîm.",
    turkish:"Allah, kendisinden başka ilah olmayandır, diri ve kayyumdur. Göklerdeki ve yerdeki her şey O'nundur. O'nun kürsisi gökleri ve yeri kaplamıştır. O yücedir, büyüktür.",
    tip:"Ayetel Kürsî her namazın ardından okunursa kıyamete dek Allah'ın himayesinde olunur. (Hadis-i Şerif)"),
  Niyet(id:16, icon:"🔰", isim:"Kötülük Kalkanı", sub:"Genel kötülüklerden korunma",
    duaAdi:"Ayetel Kürsî (Kalkan)", hedef:33,
    arabic:"اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ",
    latin:"Allahü lâ ilâhe illâ hüvel hayyül kayyûm.\nLâ te'huzühû sinetün velâ nevm.\nLehû mâ fis semâvâti vemâ fil ard.\nvesi'a kürsiyyühüs semâvâti vel ard.\nvelâ yeûdühû hıfzuhumâ ve hüvel 'aliyyül 'azîm.",
    turkish:"Allah, kendisinden başka ilah olmayandır, diri ve kayyumdur. O'nun kürsisi gökleri ve yeri kaplamıştır. Onların korunması O'na ağır gelmez. O yücedir, büyüktür.",
    tip:"Ayetel Kürsî her türlü kötülüğe karşı kalkan gibidir. Sabah ve akşam 33 kez okunması tavsiye edilmiştir."),
  Niyet(id:17, icon:"🌙", isim:"Salavat-ı Şerife", sub:"Cennet arzusu",
    duaAdi:"Salavat-ı Şerife", hedef:1000,
    arabic:"اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ",
    latin:"Allahümme salli 'alâ Muhammedin\nve 'alâ âli Muhammed.\nKemâ salleyte 'alâ İbrâhîme\nve 'alâ âli İbrâhîm.\nİnneke hamîdün mecîd.",
    turkish:"Allah'ım! İbrahim'e ve ailesine salat getirdiğin gibi Muhammed'e ve ailesine salat getir. Şüphesiz sen övülen ve yüceltilmişsin.",
    tip:"Günde 1000 salavat getirene şefaat müjdelenmektedir."),
  Niyet(id:18, icon:"🌸", isim:"Ebeveyn Duası", sub:"Anne-baba şefkati",
    duaAdi:"Ebeveyn Duası", hedef:100,
    arabic:"رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ",
    latin:"Rabbighfir lî ve li vâlideyye\nve limen dehale beytiye mü'minan.\nVel mü'minîne vel mü'minât.\nRabbihhamhumâ kemâ rabbeyanî sagîrâ.",
    turkish:"Rabbim! Beni, annemi, babamı ve evime mümin olarak gireni bağışla. Rabbim! Küçükken beni terbiye ettikleri gibi sen de onlara rahmet eyle.",
    tip:"Anne babasına dua etmek en büyük ibadetlerdendir."),
  Niyet(id:19, icon:"🏠", isim:"Bakara Son Ayetleri", sub:"Eve bereket ve koruma",
    duaAdi:"Amenarresülü", hedef:3,
    arabic:"آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ",
    latin:"Âmenar resûlü bimâ ünzile ileyhi min rabbihî vel mü'minûn.\nKüllün âmene billâhi ve melâiketihî ve kütübihî ve rusülih.\nLâ nüferriku beyne ehadin min rusülih.\nVe kâlû semi'nâ ve eta'nâ gufrâneke rabbenâ ve ileykel masîr.",
    turkish:"Peygamber, Rabbi tarafından kendisine indirilene iman etti, müminler de. Her biri Allah'a, meleklerine, kitaplarına ve peygamberlerine iman etti.",
    tip:"Bakara suresinin son iki ayeti her gece yatmadan okunursa eve şeytan giremez. (Hadis-i Şerif)"),
  Niyet(id:20, icon:"🤲", isim:"Hacet Duası", sub:"Özel istek ve hacet",
    duaAdi:"Hacet Duası", hedef:100,
    arabic:"اللَّهُمَّ إِنِّي أَسْأَلُكَ بِأَنَّكَ أَنتَ اللَّهُ",
    latin:"Allahümme innî es'elüke bi enneke entallahü\nlâ ilâhe illâ ente el Ehadu's Samed.\nEllezî lem yelid ve lem yûled\nve lem yekün lehü küfüven ehad.\nAllahümme innî es'elüke en taktiye lî hâcetî.",
    turkish:"Allah'ım! Senden istiyorum; çünkü sen Allah'sın. Senden başka ilah yoktur. Hiç doğurmamış ve doğurulmamış olan Ehad ve Samed'sin. Allah'ım! Hacetimi karşılamanı istiyorum.",
    tip:"Hacet namazı kılındıktan sonra bu dua 100 kez okunur."),
  Niyet(id:21, icon:"💛", isim:"Hamd & Şükür", sub:"Allah'a şükür etmek",
    duaAdi:"Hamd Duası", hedef:100,
    arabic:"الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
    latin:"Elhamdü lillâhi Rabbil 'âlemîn.\nyâ Rabbenâ lekel hamd\nkemâ yenbağî li celâli vechike ve 'azîmi sultânik.",
    turkish:"Hamd, âlemlerin Rabbi Allah'a aittir. Ey Rabbimiz! Yüzünün celaline ve saltanatının azametine yaraşır şekilde hamd senindir.",
    tip:"'Şükrederseniz elbette artırırım.' (İbrahim 7)"),

  // ── Yeni dualar 22-49 ──
  Niyet(id:22, icon:"🌌", isim:"Gizli Hacet Duası", sub:"Gizli dilekler için",
    duaAdi:"Gizli Hacet Duası", hedef:21,
    arabic:"اللَّهُمَّ إِنِّي أَسْأَلُكَ بِأَنِّي أَشْهَدُ أَنَّكَ أَنتَ اللَّهُ",
    latin:"Allahumme inni es'eluke bi enni eshedu\nenneke entellah la ilahe illa ente.",
    turkish:"Allah'ım senden istiyorum, şahitlik ederim ki senden başka ilah yoktur.",
    tip:"Halk arasında inanışa göre gizli bir dileğiniz varsa bu duayı 21 gece art arda okumak kabul için vesiledir."),
  Niyet(id:23, icon:"💸", isim:"Ani Cüzdan Bereketi", sub:"Para ve bolluk için",
    duaAdi:"Cüzdan Bereketi Duası", hedef:111,
    arabic:"يَا رَزَّاقُ يَا فَتَّاحُ يَا غَنِيُّ",
    latin:"Ya Rezzak Ya Fettah Ya Gani.",
    turkish:"Ey rızık veren, kapı açan, zengin eden.",
    tip:"Halk arasında inanışa göre bu esmaları 111 kez çekmek rızık kapılarını açar. Sabah namazı sonrası çekilmesi tavsiye edilir."),
  Niyet(id:24, icon:"🔥", isim:"Düşmana Karşı Kalkan", sub:"Kötü insanlardan korunma",
    duaAdi:"Hasbiyallahu Kalkanı", hedef:14,
    arabic:"حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ",
    latin:"Hasbiyallahu la ilahe illa huve\naleyhi tevekkeltu\nve huve rabbul arşil 'azim.",
    turkish:"Allah bana yeter, O'ndan başka ilah yoktur. O'na güvendim. O büyük Arş'ın Rabbidir.",
    tip:"Halk arasında inanışa göre 7 sabah 7 akşam okunursa düşmanların şerrinden korunulur."),
  Niyet(id:25, icon:"💞", isim:"Muhabbet Tesisi Duası", sub:"Sevgi ve bağ kurmak",
    duaAdi:"Ya Vedud Ya Cami", hedef:1001,
    arabic:"يَا وَدُودُ يَا جَامِعُ",
    latin:"Ya Vedud Ya Cami.\nAllahümme ellif beyne kulubina\nve ıslah zâte beynina.",
    turkish:"Ey sevdiren, ey kalpleri birleştiren. Allah'ım! Aramızdaki ilişkiyi düzelt ve kalplerimizi birbirine yaklaştır.",
    tip:"Halk arasında inanışa göre Ya Vedud ismi 1001 kez zikredildiğinde kalpler arasında muhabbet bağlanır."),
  Niyet(id:26, icon:"🌙", isim:"Rüyada İşaret Görme", sub:"Rüyada cevap almak",
    duaAdi:"Rüya İstiharesi Duası", hedef:77,
    arabic:"اللَّهُمَّ أَرِنَا الْحَقَّ حَقًّا",
    latin:"Allahumme erinel hakka hakkan\nver zuknat tiba'ah.\nVe erinel batile batilan\nver zuknat ictinabeh.",
    turkish:"Allah'ım bana doğruyu doğru olarak göster ve ona uymayı nasip et. Batılı batıl olarak göster ve ondan kaçınmayı nasip et.",
    tip:"Halk arasında inanışa göre yatmadan 77 kez okunursa rüyada hakikate dair işaret görülür."),
  Niyet(id:27, icon:"⚡", isim:"Anında Rahatlama Duası", sub:"İç sıkıntı ve daralma",
    duaAdi:"La Havle Zikreti", hedef:111,
    arabic:"لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
    latin:"La havle ve la kuvvete illa billah.\nLa havle ve la kuvvete illâ billahil 'aliyyil 'azim.",
    turkish:"Güç ve kuvvet yalnız Allah'tandır. Güç ve kuvvet yalnızca yüce ve büyük Allah'tandır.",
    tip:"Cennetin hazinelerinden biri olduğu hadiste bildirilmiştir. Sıkıntılı anlarda 111 kez okunur."),
  Niyet(id:28, icon:"🧿", isim:"Nazar Kırma Duası", sub:"Nazar için",
    duaAdi:"Bismillahi Nazar Duası", hedef:3,
    arabic:"بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ",
    latin:"Bismillahi ellezi la yedurru\nmaasmihi sey'un fil ardi\nve la fis semai\nve hüves semiul 'alim.",
    turkish:"Allah'ın adıyla ki O'nun adıyla yerde ve gökte hiçbir şey zarar veremez. O işitendir, bilendir.",
    tip:"Sabah ve akşam 3 kez okunduğunda o gün hiçbir şeyin zarar vermeyeceği hadiste bildirilmiştir."),
  Niyet(id:29, icon:"🔓", isim:"Mucizevi Kısmet Duası", sub:"Kısmet ve fırsat açılması",
    duaAdi:"Rabbi İnni Limâ", hedef:41,
    arabic:"رَبِّ إِنِّي لِمَا أَنزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ",
    latin:"Rabbi inni lima enzelte ileyye\nmin hayrin fakir.",
    turkish:"Rabbim bana indireceğin hayra muhtacım.",
    tip:"Halk arasında inanışa göre Hz. Musa'nın bu duası kısmeti kapalı olanlara kapıları açar. 41 kez okunur."),
  Niyet(id:30, icon:"🌟", isim:"Çok Güçlü Zikir", sub:"Genel dilek için",
    duaAdi:"Tesbih-i Şerif", hedef:100,
    arabic:"سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ",
    latin:"Subhanallahi ve bihamdihi\nsubhanallahil azim.",
    turkish:"Allah'ı yüceltir ve hamdıyla överim. Büyük Allah'ı tesbih ederim.",
    tip:"Lisanda hafif, mizanda ağır, Rahman'a sevgili bu iki kelimedir. (Buhâri, Muslim)"),
  Niyet(id:31, icon:"🧠", isim:"Zihin Açma Duası", sub:"Odak, karar ve netlik",
    duaAdi:"Rabbi Şrah Li Sadri", hedef:99,
    arabic:"رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي",
    latin:"Rabbi şrah li sadri\nve yessir li emri\nvahlül 'ukdeten min lisani\nyefkahu kavlî.",
    turkish:"Rabbim göğsümü aç ve işimi kolaylaştır. Dilimden düğümü çöz ki sözümü anlasınlar.",
    tip:"Hz. Musa'nın Rabbine yaptığı ve Kur'an'da geçen duadır. Önemli konuşmalar ve sınavlar öncesi 99 kez okunur."),
  Niyet(id:32, icon:"🕳️", isim:"Son Kapı Duası", sub:"Her şey tıkandığında",
    duaAdi:"Ya Hayyu Ya Kayyum", hedef:33,
    arabic:"يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ",
    latin:"Ya Hayyu Ya Kayyum\nbi rahmetike estegis.",
    turkish:"Ey diri ve her şeyi ayakta tutan Allah, rahmetinle yardım et.",
    tip:"Halk arasında inanışa göre 'son noktada kapıları açar'. Çaresizlikte 33 kez okunur."),
  Niyet(id:33, icon:"🔁", isim:"Şans Açılması Duası", sub:"Şanssızlık hissinde",
    duaAdi:"Hasbiyallahu ve Ni'mel Vekil", hedef:100,
    arabic:"حَسْبِيَ اللَّهُ وَنِعْمَ الْوَكِيلُ",
    latin:"Hasbiyallahu ve ni'mel vekil.\nNi'mel mevla ve ni'men nasir.",
    turkish:"Allah bana yeter, O ne güzel vekildir. O ne güzel dost ve ne güzel yardımcıdır.",
    tip:"Hz. İbrahim ateşe atılırken bu zikri söylemiştir. Şanssızlık hissinde 100 kez okunur."),
  Niyet(id:34, icon:"🌪️", isim:"Ağırlık Kaldırma Duası", sub:"Enerji düşüklüğü, ruh sıkışması",
    duaAdi:"Keder ve Üzüntü Duası", hedef:100,
    arabic:"اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ",
    latin:"Allahumme inni euzu bike\nminel hemmi vel hazen.\nVel 'aczi vel kesel.\nVel cübni vel buhl.\nVe daley'd-dayni ve galebetirricial.",
    turkish:"Allah'ım, keder ve üzüntüden, acizlik ve tembellikten, korkaklık ve cimrilikten, borç yükünden ve insanların baskısından sana sığınırım.",
    tip:"Hz. Peygamber'in ağır anlarda okuduğu duadır. Üzüntü ve bunalımda 100 kez okunur."),
  Niyet(id:35, icon:"🧲", isim:"Kalpleri Çekme Duası", sub:"Sosyal çekim ve karizma",
    duaAdi:"Ellif Beyne'l Kulub", hedef:313,
    arabic:"اللَّهُمَّ أَلِّفْ بَيْنَ قُلُوبِ الْعِبَادِ",
    latin:"Allahumme ellif beyne kulubil ibad\nkemâ ellefte beyne kalbi ve ruhî.",
    turkish:"Allah'ım kulların kalplerini bana yaklaştır, tıpkı kalbimi ruhumla birleştirdiğin gibi.",
    tip:"Halk arasında inanışa göre bu dua insanların kalplerinin sana yönelmesine vesiledir. 313 kez okunur."),
  Niyet(id:36, icon:"🌘", isim:"Gece Koruma Duası", sub:"Gece korkusu ve korunma",
    duaAdi:"Bismika Rabbi Yatış Duası", hedef:3,
    arabic:"بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي وَبِكَ أَرْفَعُهُ",
    latin:"Bismika Rabbi vada'tu cenbi\nve bike erfa'uh.\nFe in emsedte nefsi\nferhemha\nve in erseltaha\nfahfazha bima tahfazu bihi ibadekas salihin.",
    turkish:"Rabbim senin adınla yatarım, seninle kalkarım. Canımı alırsan ona merhamet et, gönderirsen salih kullarını koruduğunla onu koru.",
    tip:"Hz. Peygamber'in her gece yatarken okuduğu duadır. Gece korkusunda 3 kez okunur."),
  Niyet(id:37, icon:"⚔️", isim:"Gizli Düşmanı Bertaraf", sub:"Arkadan iş çevirenler",
    duaAdi:"Ekfinihim Duası", hedef:7,
    arabic:"اللَّهُمَّ اكْفِنِيهِمْ بِمَا شِئْتَ",
    latin:"Allahumme ekfinihim bima şite.",
    turkish:"Allah'ım beni onlardan dilediğin şekilde koru ve bertaraf et.",
    tip:"Halk arasında inanışa göre arkadan iş çeviren gizli düşmanlara karşı bu dua 7 kez okunur."),
  Niyet(id:38, icon:"💡", isim:"İlham Açma Duası", sub:"Fikir bulma ve yaratıcılık",
    duaAdi:"İlham ve Hikmet Duası", hedef:100,
    arabic:"رَبِّ زِدْنِي حِكْمَةً وَعِلْمًا",
    latin:"Rabbi zidni hikmeten ve ilmen.\nVe elhimni ruşdî.\nAllahümme fettah 'aleynâ hikmeteke.",
    turkish:"Rabbim bana hikmet ve ilim ver. Bana doğru yolu ilham et. Allah'ım üzerimize hikmeti kapılarını aç.",
    tip:"Yaratıcı iş ve fikir üretiminde bu dua 100 kez okunur. İlham kapılarını açtığı rivayet edilir."),
  Niyet(id:39, icon:"🔓", isim:"Kilitlenen İşleri Açma", sub:"İşler ilerlemiyorsa",
    duaAdi:"Ya Latif Ya Habir", hedef:129,
    arabic:"يَا لَطِيفُ يَا خَبِيرُ",
    latin:"Ya Latif Ya Habir.\nAllahümme bi lutkike ve hibreke\nufruç 'anni.",
    turkish:"Ey en ince işlere vakıf olan, ey her şeyden haberdar olan. Allah'ım lutfun ve haberin ile sıkıntımı gider.",
    tip:"Halk arasında inanışa göre tıkanan işlerin açılması için Ya Latif ismi 129 kez okunur."),
  Niyet(id:40, icon:"🧬", isim:"İçsel Temizlik Duası", sub:"Negatif düşünce temizleme",
    duaAdi:"Kalp Temizleme Duası", hedef:100,
    arabic:"اللَّهُمَّ طَهِّرْ قَلْبِي",
    latin:"Allahumme tahhir kalbi\nmin kulli ma la yurdik.\nVe tahhir lisani min kulli ma yuğdibuk.",
    turkish:"Allah'ım kalbimi seni razı etmeyen her şeyden temizle. Dilimi de seni öfkelendiren her şeyden arındır.",
    tip:"İçsel negatifliği ve kötü düşünceleri gidermek için günde 100 kez okunur."),
  Niyet(id:41, icon:"🌠", isim:"Dilek Hızlandırma", sub:"Dileklerin kabul hızı",
    duaAdi:"Salavat-ı Şerife (Hızlandırıcı)", hedef:100,
    arabic:"اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ",
    latin:"Allahümme salli 'alâ Muhammedin\nve 'alâ âli Muhammed.",
    turkish:"Allah'ım Muhammed'e ve Muhammed'in ailesine rahmet et.",
    tip:"Halk arasında inanışa göre dua öncesi salavat okunursa kabul hızı artar. Dua başında ve sonunda 100 kez okunur."),
  Niyet(id:42, icon:"🧘", isim:"Stres Kesme Duası", sub:"Yoğun stres ve bunaltı",
    duaAdi:"Yunusiyye Duası", hedef:33,
    arabic:"لَا إِلَٰهَ إِلَّا أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ",
    latin:"La ilahe illa ente subhaneke\ninni kuntu minez zalimin.",
    turkish:"Senden başka ilah yoktur, seni tenzih ederim. Ben gerçekten zalimlerden oldum.",
    tip:"Hz. Yunus'un balığın karnında okuduğu duadır. Çok zor anlarda 33 kez okunması tesirlidir."),
  Niyet(id:43, icon:"🪬", isim:"Negatif Enerji Duası", sub:"Kötü enerji hissi",
    duaAdi:"Euzu Bi Kelimatillah", hedef:7,
    arabic:"أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
    latin:"Euzu bi kelimatillahit tammati\nmin şerri ma halak.",
    turkish:"Allah'ın tam kelimelerine sığınırım, yarattıklarının şerrinden.",
    tip:"Her türlü kötülükten korunmak için akşam 3 kez okunması hadiste tavsiye edilmiştir."),
  Niyet(id:44, icon:"⛓️", isim:"Bağımlılıktan Kurtulma", sub:"Bir şeye kopamama durumu",
    duaAdi:"Nefsin Şerrinden Korunma", hedef:21,
    arabic:"اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي",
    latin:"Allahumme inni euzu bike min şerri nefsi\nve min şerri kulli dabbetin\nente ahizun bi nasiyetiha.",
    turkish:"Allah'ım nefsimin şerrinden ve kontrolü senin elinde olan her şeyin şerrinden sana sığınırım.",
    tip:"Halk arasında inanışa göre kötü alışkanlıklardan ve bağımlılıklardan kurtulmak için 21 gün boyunca her gün 21 kez okunur."),
  Niyet(id:45, icon:"🌊", isim:"İç Daralma Duası", sub:"Anlık sıkıntı açma",
    duaAdi:"Tesbih-i Azim", hedef:33,
    arabic:"سُبْحَانَ اللَّهِ الْعَظِيمِ",
    latin:"Subhanallahil azim.\nSubhanallahi ve bihamdihi.",
    turkish:"Büyük Allah'ı tesbih ederim. Allah'ı hamd ile tesbih ederim.",
    tip:"Anlık bunaltı ve iç daralmasında 33 kez söylenmesi 1 dakikada etki eder. Lisanda hafif, mizanda ağırdır."),
  Niyet(id:46, icon:"🧭", isim:"Yön Bulma Duası", sub:"Ne yapacağını bilememek",
    duaAdi:"İhdinî ve Seddidnî", hedef:41,
    arabic:"اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي",
    latin:"Allahumme ihdini ve seddidni.",
    turkish:"Allah'ım beni doğruya yönelt ve doğru yapmamı sağla.",
    tip:"Hz. Peygamber'den rivayet edilen kısa ve özlü duadır. Kararsızlık ve yön arayışında 41 kez okunur."),
  Niyet(id:47, icon:"💓", isim:"Sevgi Açma Zikri", sub:"Kalpler arasında sevgi",
    duaAdi:"Ya Vedud Zikri", hedef:313,
    arabic:"يَا وَدُودُ",
    latin:"Ya Vedud.\nAllahümme habbib ileyye\nman tuhibbu en yuhibbeni.",
    turkish:"Ey sevenler seveni! Allah'ım beni sevmeni dilediğin kişilere sevdir.",
    tip:"Halk arasında inanışa göre Ya Vedud ismi 100 veya 313 kez zikredildiğinde kalpler arasında muhabbet bağlanır."),
  Niyet(id:48, icon:"💔", isim:"Kalpten Bağ Kesme", sub:"Eski sevgiyi unutmak",
    duaAdi:"Bağ Kesme Duası", hedef:21,
    arabic:"اللَّهُمَّ اقْطَعْ عَنِّي كُلَّ تَعَلُّقٍ سِوَاكَ",
    latin:"Allahumme inni euzu bike min şerri nefsi\nve min şerri kulli dabbetin\nente ahizun bi nasiyetiha.\nAllahümme tahhir kalbi min kulli ma la yurdik.",
    turkish:"Allah'ım nefsimin şerrinden sana sığınırım. Allah'ım kalbimi seni razı etmeyen her şeyden temizle.",
    tip:"Halk arasında inanışa göre 21 gün boyunca her gün 21 kez okunduğunda kalp bağlarından arınır."),
  Niyet(id:49, icon:"🫀", isim:"Aklından Çıkarma Duası", sub:"Sürekli akla geleni bitirmek",
    duaAdi:"Kalp Temizleme Zikreti", hedef:100,
    arabic:"اللَّهُمَّ طَهِّرْ قَلْبِي مِمَّا لَا يُرْضِيكَ",
    latin:"Allahumme tahhir kalbi\nmin kulli ma la yurdik.",
    turkish:"Allah'ım kalbimi seni razı etmeyen her şeyden temizle.",
    tip:"Halk arasında inanışa göre aklından çıkaramadığın her şey için günde 100 kez okunması etkilidir."),

  // ── Kur'an Sureleri 50-59 ──
  Niyet(id:50, icon:"☀️", isim:"Duhâ Suresi", sub:"İç sıkıntısı, ümit ve moral",
    duaAdi:"Duhâ Suresi", hedef:7,
    arabic:"وَالضُّحَىٰ\nوَاللَّيْلِ إِذَا سَجَىٰ\nمَا وَدَّعَكَ رَبُّكَ وَمَا قَلَىٰ\nوَلَلْآخِرَةُ خَيْرٌ لَكَ مِنَ الْأُولَىٰ\nوَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ\nأَلَمْ يَجِدْكَ يَتِيمًا فَآوَىٰ\nوَوَجَدَكَ ضَالًّا فَهَدَىٰ\nوَوَجَدَكَ عَائِلًا فَأَغْنَىٰ\nفَأَمَّا الْيَتِيمَ فَلَا تَقْهَرْ\nوَأَمَّا السَّائِلَ فَلَا تَنْهَرْ\nوَأَمَّا بِنِعْمَةِ رَبِّكَ فَحَدِّثْ",
    latin:"Ved-duhâ.\nVel-leyli izâ secâ.\nMâ veddeake rabbuke ve mâ kalâ.\nVe lel-âhiretu hayrun leke minel-ûlâ.\nVe lesevfe yu'tîke rabbuke fe terdâ.\nElem yecidke yetîmen fe âvâ.\nVe vecedeke dâllen fe hedâ.\nVe vecedeke âilen fe ağnâ.\nFe emmel-yetîme felâ takher.\nVe emmes-sâile felâ tenher.\nVe emmâ bi ni'meti rabbike fe haddis.",
    turkish:"Kuşluk vaktine ve sakinleştiği zaman geceye yemin olsun ki Rabbin seni bırakmadı ve sana darılmadı. Ahiret senin için dünyadan daha hayırlıdır. Rabbin sana verecek ve sen hoşnut olacaksın. O seni yetim bulup barındırmadı mı? Yol bilmez halde bulup doğru yola iletmedi mi? İhtiyaç içinde bulup zengin etmedi mi? Öyleyse yetimi ezme, isteyeni azarlama, Rabbinin nimetini anlat.",
    tip:"Ümit, ferahlık ve gönül rahatlığı niyetiyle sabah/kuşluk vaktinde 7 defa okunması tavsiye edilir."),
  Niyet(id:51, icon:"🌬️", isim:"İnşirah Suresi", sub:"Gönül ferahlığı, işlerin kolaylaşması",
    duaAdi:"İnşirah Suresi", hedef:11,
    arabic:"أَلَمْ نَشْرَحْ لَكَ صَدْرَكَ\nوَوَضَعْنَا عَنْكَ وِزْرَكَ\nالَّذِي أَنْقَضَ ظَهْرَكَ\nوَرَفَعْنَا لَكَ ذِكْرَكَ\nفَإِنَّ مَعَ الْعُسْرِ يُسْرًا\nإِنَّ مَعَ الْعُسْرِ يُسْرًا\nفَإِذَا فَرَغْتَ فَانْصَبْ\nوَإِلَىٰ رَبِّكَ فَارْغَبْ",
    latin:"Elem neşrah leke sadrak.\nVe vada'nâ anke vizrak.\nEllezî enkada zahrak.\nVe refa'nâ leke zikrak.\nFe inne meal-'usri yusrâ.\nİnne meal-'usri yusrâ.\nFe izâ ferağte fensab.\nVe ilâ rabbike ferğab.",
    turkish:"Biz senin göğsünü açıp genişletmedik mi? Belini büken yükünü senden kaldırmadık mı? Senin şanını yüceltmedik mi? Şüphesiz güçlükle beraber bir kolaylık vardır. Gerçekten güçlükle beraber bir kolaylık vardır. Öyleyse işin bitince yine gayret et ve ancak Rabbine yönel.",
    tip:"Gönül ferahlığı ve işlerin kolaylaşması niyetiyle 11 defa okunması tavsiye edilir."),
  Niyet(id:52, icon:"📖", isim:"Fâtiha Suresi", sub:"Şifa, bereket ve hayırlı kapılar",
    duaAdi:"Fâtiha Suresi", hedef:7,
    arabic:"الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\nالرَّحْمَٰنِ الرَّحِيمِ\nمَالِكِ يَوْمِ الدِّينِ\nإِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\nاهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ\nصِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ\nغَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
    latin:"Elhamdulillâhi rabbil-âlemîn.\nEr-rahmânir-rahîm.\nMâliki yevmid-dîn.\nİyyâke na'budu ve iyyâke neste'în.\nİhdinas-sırâtal-mustakîm.\nSırâtallezîne en'amte aleyhim.\nĞayril-mağdûbi aleyhim ve led-dâllîn.",
    turkish:"Hamd, âlemlerin Rabbi Allah'a mahsustur. O Rahmân ve Rahîm'dir. Din gününün sahibidir. Yalnız sana kulluk eder, yalnız senden yardım dileriz. Bizi doğru yola ilet; nimet verdiklerinin yoluna, gazaba uğrayanların ve sapmışların yoluna değil.",
    tip:"Şifa, bereket ve dua niyetiyle 1 veya 7 defa okunması tavsiye edilir."),
  Niyet(id:53, icon:"☝️", isim:"İhlâs Suresi", sub:"Tevhid, iman tazeleme ve korunma",
    duaAdi:"İhlâs Suresi", hedef:3,
    arabic:"قُلْ هُوَ اللَّهُ أَحَدٌ\nاللَّهُ الصَّمَدُ\nلَمْ يَلِدْ وَلَمْ يُولَدْ\nوَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ",
    latin:"Kul huvallâhu ehad.\nAllâhus-samed.\nLem yelid ve lem yûled.\nVe lem yekun lehû kufuven ehad.",
    turkish:"De ki: O Allah birdir. Allah Samed'dir; her şey O'na muhtaçtır, O hiçbir şeye muhtaç değildir. Doğurmamış ve doğurulmamıştır. Hiçbir şey O'na denk değildir.",
    tip:"Tevhid, korunma ve manevi güç niyetiyle 3 defa okunması tavsiye edilir."),
  Niyet(id:54, icon:"🌅", isim:"Felak Suresi", sub:"Nazar, haset ve kötülüklerden korunma",
    duaAdi:"Felak Suresi", hedef:3,
    arabic:"قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ\nمِنْ شَرِّ مَا خَلَقَ\nوَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ\nوَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ\nوَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ",
    latin:"Kul e'ûzu bi rabbil-felak.\nMin şerri mâ halak.\nVe min şerri ğâsikin izâ vekab.\nVe min şerrin-neffâsâti fil-'ukad.\nVe min şerri hâsidin izâ hased.",
    turkish:"De ki: Yarattığı şeylerin şerrinden, karanlığı çöktüğü zaman gecenin şerrinden, düğümlere üfleyenlerin şerrinden ve haset ettiği zaman hasetçinin şerrinden sabahın Rabbine sığınırım.",
    tip:"Nazar, haset ve kötülüklerden korunma niyetiyle 3 defa okunması tavsiye edilir."),
  Niyet(id:55, icon:"🤲", isim:"Nâs Suresi", sub:"Vesvese, korku ve manevi korunma",
    duaAdi:"Nâs Suresi", hedef:3,
    arabic:"قُلْ أَعُوذُ بِرَبِّ النَّاسِ\nمَلِكِ النَّاسِ\nإِلَٰهِ النَّاسِ\nمِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ\nالَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ\nمِنَ الْجِنَّةِ وَالنَّاسِ",
    latin:"Kul e'ûzu bi rabbin-nâs.\nMelikin-nâs.\nİlâhin-nâs.\nMin şerril-vesvâsil-hannâs.\nEllezî yuvesvisu fî sudûrin-nâs.\nMinel-cinneti ven-nâs.",
    turkish:"De ki: İnsanların Rabbine, insanların Melikine, insanların ilahına sığınırım. Sinsice vesvese verenin şerrinden; o ki insanların göğüslerine vesvese verir, cinlerden de insanlardan da olur.",
    tip:"Vesvese, korku ve manevi korunma niyetiyle 3 defa okunması tavsiye edilir."),
  Niyet(id:56, icon:"🏛️", isim:"Kâfirûn Suresi", sub:"İmanı koruma, tevhid bilinci",
    duaAdi:"Kâfirûn Suresi", hedef:3,
    arabic:"قُلْ يَا أَيُّهَا الْكَافِرُونَ\nلَا أَعْبُدُ مَا تَعْبُدُونَ\nوَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ\nوَلَا أَنَا عَابِدٌ مَا عَبَدْتُمْ\nوَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ\nلَكُمْ دِينُكُمْ وَلِيَ دِينِ",
    latin:"Kul yâ eyyuhel-kâfirûn.\nLâ a'budu mâ ta'budûn.\nVe lâ entum âbidûne mâ a'bud.\nVe lâ ene âbidun mâ abedtum.\nVe lâ entum âbidûne mâ a'bud.\nLekum dînukum ve liye dîn.",
    turkish:"De ki: Ey inkârcılar! Ben sizin taptıklarınıza tapmam. Siz de benim kulluk ettiğime kulluk etmezsiniz. Ben sizin taptıklarınıza kulluk edecek değilim. Siz de benim kulluk ettiğime kulluk edecek değilsiniz. Sizin dininiz size, benim dinim banadır.",
    tip:"İmanı koruma ve tevhid bilincini güçlendirme niyetiyle 1 veya 3 defa okunması tavsiye edilir."),
  Niyet(id:57, icon:"⏳", isim:"Asr Suresi", sub:"Zamanın kıymeti, sabır ve hak",
    duaAdi:"Asr Suresi", hedef:3,
    arabic:"وَالْعَصْرِ\nإِنَّ الْإِنْسَانَ لَفِي خُسْرٍ\nإِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ\nوَتَوَاصَوْا بِالْحَقِّ\nوَتَوَاصَوْا بِالصَّبْرِ",
    latin:"Vel-'asr.\nİnnel-insâne le fî husr.\nİllellezîne âmenû ve amilus-sâlihât.\nVe tevâsav bil-hakk.\nVe tevâsav bis-sabr.",
    turkish:"Asra yemin olsun ki insan gerçekten ziyandadır. Ancak iman edenler, salih amel işleyenler, birbirlerine hakkı ve sabrı tavsiye edenler başka.",
    tip:"Zamanı bereketli geçirmek, sabır ve doğruluk niyetiyle 3 defa okunması tavsiye edilir."),
  Niyet(id:58, icon:"🏆", isim:"Nasr Suresi", sub:"Şükür, başarı ve istiğfar",
    duaAdi:"Nasr Suresi", hedef:3,
    arabic:"إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ\nوَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا\nفَسَبِّحْ بِحَمْدِ رَبِّكَ\nوَاسْتَغْفِرْهُ\nإِنَّهُ كَانَ تَوَّابًا",
    latin:"İzâ câe nasrullâhi vel-feth.\nVe raeyten-nâse yedhulûne fî dînillâhi efvâcâ.\nFesebbih bi hamdi rabbike vestağfirh.\nİnnehû kâne tevvâbâ.",
    turkish:"Allah'ın yardımı ve fetih geldiğinde, insanların bölük bölük Allah'ın dinine girdiklerini gördüğünde Rabbini hamd ile tesbih et ve O'ndan bağışlanma dile. Çünkü O, tevbeleri çok kabul edendir.",
    tip:"Yardım, şükür ve istiğfar niyetiyle bir işin sonunda 3 defa okunması tavsiye edilir."),
  Niyet(id:59, icon:"🐘", isim:"Fîl Suresi", sub:"Zalimlerin şerrinden korunma",
    duaAdi:"Fîl Suresi", hedef:7,
    arabic:"أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ بِأَصْحَابِ الْفِيلِ\nأَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ\nوَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ\nتَرْمِيهِمْ بِحِجَارَةٍ مِنْ سِجِّيلٍ\nفَجَعَلَهُمْ كَعَصْفٍ مَأْكُولٍ",
    latin:"Elem tera keyfe fe'ale rabbuke bi ashâbil-fîl.\nElem yec'al keydehum fî tadlîl.\nVe ersele aleyhim tayran ebâbîl.\nTermîhim bi hicâratin min siccîl.\nFe ce'alehum ke'asfin me'kûl.",
    turkish:"Rabbin fil sahiplerine ne yaptı, görmedin mi? Onların tuzaklarını boşa çıkarmadı mı? Üzerlerine sürü sürü kuşlar gönderdi. Onlara pişmiş çamurdan taşlar attılar. Böylece onları yenmiş ekin yaprağı gibi yaptı.",
    tip:"Zalimlerin şerrinden korunma ve Allah'a sığınma niyetiyle 7 defa okunması tavsiye edilir."),
  Niyet(id:60, icon:"🌙", isim:"İstihare Duası", sub:"Karar öncesi hayırlı olanı dilemek",
    duaAdi:"İstihare Duası", hedef:1,
    arabic:"اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ\nوَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ\nفَإِنَّكَ تَقْدِرُ وَلَا أَقْدِرُ\nوَتَعْلَمُ وَلَا أَعْلَمُ\nوَأَنْتَ عَلَّامُ الْغُيُوبِ\nاللَّهُمَّ إِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ خَيْرٌ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي\nفَاقْدُرْهُ لِي وَيَسِّرْهُ لِي ثُمَّ بَارِكْ لِي فِيهِ\nوَإِنْ كُنْتَ تَعْلَمُ أَنَّ هَذَا الْأَمْرَ شَرٌّ لِي فِي دِينِي وَمَعَاشِي وَعَاقِبَةِ أَمْرِي\nفَاصْرِفْهُ عَنِّي وَاصْرِفْنِي عَنْهُ\nوَاقْدُرْ لِي الْخَيْرَ حَيْثُ كَانَ ثُمَّ أَرْضِنِي بِهِ",
    latin:"Allâhümme innî estehîruke bi'ilmike ve estakdiruke bikudratike ve es'eluke min fadlike'l-azîm.\nFe inneke takdiru ve lâ akdiru ve ta'lemü ve lâ a'lemü ve ente allâmü'l-ğuyûb.\nAllâhümme in künte ta'lemü enne hâze'l-emre hayrun lî fî dînî ve meâşî ve âkıbeti emrî\nfekdurhu lî ve yessirhu lî sümme bârik lî fîh.\nVe in künte ta'lemü enne hâze'l-emre şerrun lî fî dînî ve meâşî ve âkıbeti emrî\nfasrifhu annî vasrifnî anhu vakdur liyal-hayre haysü kâne sümme arzınî bih.",
    turkish:"Allah'ım! İlminle hayırlısını istiyorum, kudretinle güç istiyorum ve büyük lütfundan diliyorum. Sen güç yetirirsin, ben yetiremem; sen bilirsin, ben bilemem; sen gaybleri bilensin. Allah'ım! Bu işin dinim, geçimim ve işimin sonucu bakımından hayırlı olduğunu biliyorsan onu bana nasip et, kolaylaştır, sonra bana onu mübarek kıl. Eğer şer olduğunu biliyorsan onu benden ve beni ondan uzaklaştır; nerede olursa olsun benim için hayırlı olanı takdir et, sonra beni bununla razı eyle.",
    tip:"Bir iş yapmadan önce 2 rekât namaz kılınıp bu dua edilir. Buhârî'de sabit sahih hadis."),
  Niyet(id:61, icon:"🛡️", isim:"Afiyet Duası", sub:"Dünya ve ahirette af ve afiyet",
    duaAdi:"Afiyet Duası", hedef:1,
    arabic:"اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ",
    latin:"Allâhümme innî es'elüke'l-afve vel-âfiyete fi'd-dünyâ vel-âhira.",
    turkish:"Allah'ım! Senden dünya ve ahirette af ve afiyet istiyorum.",
    tip:"Sabah-akşam okunması tavsiye edilen; Tirmizî ve İbn Mâce'de geçen sahih hadis."),
  Niyet(id:62, icon:"❤️", isim:"Kalp Sağlamlığı Duası", sub:"Kalbini dinde sabit kılmak",
    duaAdi:"Kalbi Sabit Kılma Duası", hedef:7,
    arabic:"يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ",
    latin:"Yâ mukallibel-kulûb, sebbit kalbî alâ dînik.",
    turkish:"Ey kalpleri çeviren! Kalbimi dinin üzere sabit kıl.",
    tip:"Kalbini dinde sabit kılmak için sıklıkla okunması tavsiye edilir; Tirmizî'de geçen sahih hadis."),
  Niyet(id:63, icon:"🚪", isim:"Kolaylaştırma Duası", sub:"Zorlukları kolaylaştırması için",
    duaAdi:"Kolaylaştırma Duası", hedef:7,
    arabic:"اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا\nوَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا",
    latin:"Allâhümme lâ sehle illâ mâ ce'altehû sehlâ\nve ente tec'alü'l-hazne izâ şi'te sehlâ.",
    turkish:"Allah'ım! Sen kolaylaştırdığın şey dışında kolay yoktur. Dilediğinde zorluğu da kolaylaştırırsın.",
    tip:"Zor işlerde ve sıkıntılarda kolaylık dilemek için okunur; İbn Hibbân'da geçen sahih hadis."),
  Niyet(id:64, icon:"👁️", isim:"Beden Afiyeti Duası", sub:"Beden, kulak ve göz için afiyet",
    duaAdi:"Beden Afiyeti Duası", hedef:3,
    arabic:"اللَّهُمَّ عَافِنِي فِي بَدَنِي\nاللَّهُمَّ عَافِنِي فِي سَمْعِي\nاللَّهُمَّ عَافِنِي فِي بَصَرِي",
    latin:"Allâhümme âfinî fî bedenî.\nAllâhümme âfinî fî sem'î.\nAllâhümme âfinî fî besarî.",
    turkish:"Allah'ım! Bedenimde afiyet ver. Allah'ım! Kulağımda afiyet ver. Allah'ım! Gözümde afiyet ver.",
    tip:"Sabah-akşam beden sağlığı için 3 defa okunması tavsiye edilir; Ebû Dâvûd'da geçer."),
  Niyet(id:65, icon:"📚", isim:"Faydalı İlim Duası", sub:"Faydalı ilim, temiz rızık ve makbul amel",
    duaAdi:"Faydalı İlim ve Rızık Duası", hedef:1,
    arabic:"اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا\nوَرِزْقًا طَيِّبًا\nوَعَمَلًا مُتَقَبَّلًا",
    latin:"Allâhümme innî es'elüke ilmen nâfi'an\nve rızkan tayyiben\nve amelen mütekabbelen.",
    turkish:"Allah'ım! Senden faydalı ilim, temiz rızık ve makbul amel istiyorum.",
    tip:"Sabah namazının ardından okunması tavsiye edilir; İbn Mâce'de geçer."),
];

// ── KATEGORİLER ───────────────────────────
const List<Kategori> kategoriler = [
  Kategori(id:0, icon:"🤲", isim:"Tüm Dualar",
    sub:"Uygulamadaki tüm duaları bir arada görüntüleyin.",
    niyetIds:[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65]),
  Kategori(id:11, icon:"🕋", isim:"Kur'an Sureleri",
    sub:"Kur'an ayetleri ve surelerinden oluşan dualar. Her biri farklı niyet ve ihtiyaçlar için okunabilir.",
    niyetIds:[2, 3, 4, 6, 8, 11, 12, 19, 15, 42, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]),
  Kategori(id:-1, icon:"📿", isim:"Zikirler",
    sub:"Tesbih, esmaül hüsna ve günlük zikirler. Her birini istediğiniz kadar çekerek kalbinizi Allah'ın zikriyle doldurabilirsiniz.",
    niyetIds:[], isZikir:true),
  Kategori(id:1, icon:"🌙", isim:"Gece 03:00 Duaları",
    sub:"Halk arasında inanışa göre gece 03:00'te okunan dualar daha çabuk kabul olur; bu saatte arş kapıları açık olur.",
    niyetIds:[36, 26, 32, 42, 45, 40]),
  Kategori(id:2, icon:"🌟", isim:"En Tesirli Dualar",
    sub:"Halk arasında inanışa göre bu dualar en güçlü ve en hızlı etki eden dualardır. Tarihin her döneminde milyonlarca müslüman tarafından okunmuştur.",
    niyetIds:[1, 15, 13, 10, 30, 17, 27, 32]),
  Kategori(id:3, icon:"🕯️", isim:"3 Gece Okunup Sonuç Alınan Dualar",
    sub:"Halk arasında inanışa göre üst üste 3 gece aynı niyetle okunan bu dualar kısa sürede etkisini gösterir.",
    niyetIds:[22, 28, 36, 43, 29, 37]),
  Kategori(id:4, icon:"📅", isim:"7 Gün Okunup Sonuç Alınan Dualar",
    sub:"Halk arasında inanışa göre 7 gün sabır ve niyet ile okunduğunda bu duaların dilekleri gerçekleştirir.",
    niyetIds:[48, 49, 44, 24, 3, 8, 25]),
  Kategori(id:5, icon:"🔮", isim:"Gizli İlimlerden Dualar",
    sub:"Halk arasında inanışa göre bu dualar tasavvuf ve gizli ilimler geleneğinde rivayet edilen; etkisi güçlü bilinmeyen dualardır.",
    niyetIds:[37, 26, 44, 22, 35, 48, 25]),
  Kategori(id:6, icon:"💎", isim:"Az Bilinen Çok Etkili Dualar",
    sub:"Halk arasında inanışa göre çoğu kişinin bilmediği bu dualar; bilenlere büyük fayda sağlamıştır.",
    niyetIds:[23, 29, 35, 38, 39, 47, 46, 31]),
  Kategori(id:8, icon:"✅", isim:"Sahih Dualar",
    sub:"Halk arasında inanışa göre sahih hadis zinciriyle sabit olan bu dualar en sağlam ve tesirli olanlardır.",
    niyetIds:[13, 14, 15, 9, 18, 4, 28, 34, 46, 52, 53, 54, 55, 56, 57, 60, 61, 62, 63, 64, 65]),
  Kategori(id:9, icon:"📜", isim:"Rivayetle Sabit Dualar",
    sub:"Halk arasında inanışa göre büyük zatlara ve sahabeye dayanan rivayetlerle gelen bu dualar asırlarca okunmuştur.",
    niyetIds:[1, 5, 7, 17, 20, 10, 33, 27]),
  Kategori(id:10, icon:"🗂️", isim:"Kaynaklı Dualar",
    sub:"Halk arasında inanışa göre belirli kitap ve kaynaklara dayanan bu dualar güvenilir ve okunması tavsiye edilenlerdir.",
    niyetIds:[16, 21, 6, 40, 41, 45, 30, 34]),
];

Map<int, Niyet> get niyetMap {
  final m = <int, Niyet>{};
  for (final n in niyetler) m[n.id] = n;
  return m;
}

const List<Zikir> zikirler = [
  Zikir(id:101, icon:"📿", isim:"Subhanallah",                         anlam:"Allah eksikliklerden uzaktır",          hikmet:"Günahları azaltır, kalbi arındırır",       hedef:33),
  Zikir(id:102, icon:"📿", isim:"Elhamdülillah",                       anlam:"Hamd Allah'a aittir",                   hikmet:"Şükür arttıkça nimet artar",               hedef:33),
  Zikir(id:103, icon:"📿", isim:"Allahu Ekber",                        anlam:"Allah en büyüktür",                     hikmet:"Korku ve kaygıyı azaltır",                 hedef:33),
  Zikir(id:104, icon:"🌟", isim:"La ilahe illallah",                   anlam:"Allah'tan başka ilah yoktur",           hikmet:"En faziletli zikirdir",                    hedef:100),
  Zikir(id:105, icon:"🤲", isim:"Estağfirullah el azim",               anlam:"Büyük Allah'tan bağışlanma dilerim",    hikmet:"Günahları affettirir",                     hedef:100),
  Zikir(id:106, icon:"✨", isim:"Subhanallahi ve bihamdihi",           anlam:"Allah'ı överek tesbih ederim",          hikmet:"Çok büyük sevap kazandırır",               hedef:100),
  Zikir(id:107, icon:"✨", isim:"Subhanallahil azim",                  anlam:"Büyük Allah'ı tesbih ederim",           hikmet:"Kalbi rahatlatır",                         hedef:100),
  Zikir(id:108, icon:"💪", isim:"La havle ve la kuvvete illa billah",  anlam:"Güç ve kuvvet sadece Allah'tandır",     hikmet:"Stresi azaltır, güç verir",                hedef:100),
  Zikir(id:109, icon:"🛡️", isim:"Hasbiyallahu la ilahe illa huve",    anlam:"Allah bana yeter",                      hikmet:"Zor zamanlarda güven verir",               hedef:7),
  Zikir(id:110, icon:"🌙", isim:"Allahümme salli ala Muhammed",        anlam:"Allah'ım Muhammed'e salat et",          hikmet:"Duaların kabulüne vesile olur",            hedef:100),
  Zikir(id:111, icon:"💖", isim:"Ya Vedud",                            anlam:"Ey çok seven ve sevilen",               hikmet:"Sevgi ve muhabbet artırır",                hedef:1000),
  Zikir(id:112, icon:"🗝️", isim:"Ya Fettah",                          anlam:"Ey kapıları açan",                      hikmet:"İşlerin açılmasına vesile olur",           hedef:489),
  Zikir(id:113, icon:"🌾", isim:"Ya Rezzak",                           anlam:"Ey rızık veren",                        hikmet:"Rızık ve bereket getirir",                 hedef:308),
  Zikir(id:114, icon:"🌿", isim:"Ya Latif",                            anlam:"Ey en ince işleri bilen",               hikmet:"Zor işleri kolaylaştırır",                 hedef:129),
  Zikir(id:115, icon:"🕊️", isim:"Ya Sabur",                           anlam:"Ey sabır veren",                        hikmet:"Sabır kazandırır",                         hedef:100),
  Zikir(id:116, icon:"💊", isim:"Ya Şafi",                             anlam:"Ey şifa veren",                         hikmet:"Hastalıklara iyi gelir",                   hedef:100),
  Zikir(id:117, icon:"⭐", isim:"Ya Kafi",                             anlam:"Ey yeterli olan",                       hikmet:"Maddi manevi yeterlilik verir",            hedef:111),
  Zikir(id:118, icon:"💰", isim:"Ya Gani",                             anlam:"Ey zengin eden",                        hikmet:"Fakirliği giderir",                        hedef:106),
  Zikir(id:119, icon:"🌊", isim:"Ya Halim",                            anlam:"Ey yumuşak davranan",                   hikmet:"Öfkeyi azaltır",                           hedef:88),
  Zikir(id:120, icon:"☀️", isim:"Ya Nur",                              anlam:"Ey aydınlatan",                         hikmet:"Kalbe huzur verir",                        hedef:256),
  Zikir(id:121, icon:"🌸", isim:"Ya Rahman",                           anlam:"Ey merhamet eden",                      hikmet:"Rahmet çeker",                             hedef:298),
  Zikir(id:122, icon:"💝", isim:"Ya Rahim",                            anlam:"Ey çok merhametli",                     hikmet:"Affa vesile olur",                         hedef:258),
  Zikir(id:123, icon:"⚡", isim:"Ya Aziz",                             anlam:"Ey güçlü olan",                         hikmet:"Güç ve itibar kazandırır",                 hedef:94),
  Zikir(id:124, icon:"🎁", isim:"Ya Kerim",                            anlam:"Ey cömert olan",                        hikmet:"Bolluk getirir",                           hedef:270),
  Zikir(id:125, icon:"👁️", isim:"Ya Basir",                           anlam:"Ey her şeyi gören",                     hikmet:"Farkındalık artırır",                      hedef:302),
  Zikir(id:126, icon:"👂", isim:"Ya Semi",                             anlam:"Ey her şeyi işiten",                    hikmet:"Duaların kabulüne vesile olur",            hedef:180),
  Zikir(id:127, icon:"🧠", isim:"Ya Hakim",                            anlam:"Ey hikmet sahibi",                      hikmet:"Doğru karar verdirir",                     hedef:78),
  Zikir(id:128, icon:"⚖️", isim:"Ya Adl",                             anlam:"Ey adaletli olan",                      hikmet:"Haksızlıktan korur",                       hedef:104),
  Zikir(id:129, icon:"🌠", isim:"Ya Hadi",                             anlam:"Ey doğru yola ileten",                  hikmet:"Yol gösterir",                             hedef:400),
  Zikir(id:130, icon:"♾️", isim:"Ya Baki",                             anlam:"Ey sonsuz olan",                        hikmet:"Kalıcılık ve istikrar verir",              hedef:113),
];

// ── APP ───────────────────────────────────
class AminApp extends StatelessWidget {
  const AminApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Amin', debugShowCheckedModeBanner: false,
    navigatorObservers: [_backPressObserver],
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: AC.greenMain),
      textTheme: GoogleFonts.loraTextTheme(), useMaterial3: true),
    home: const HomeScreen(),
  );
}

// ── HOME ──────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AC.greenDark, AC.greenMain, AC.greenBg], stops: [0.0, 0.45, 1.0]),
        ),
        child: SafeArea(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيمِ",
            style: GoogleFonts.amiri(fontSize: 26, color: AC.goldLight), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          const Text("Bismillahirrahmanirrahim",
            style: TextStyle(fontSize: 11, color: AC.greenPale, letterSpacing: 1.2)),
          const SizedBox(height: 28),
          Container(
            width: 110, height: 110,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: const RadialGradient(colors: [AC.goldLight, AC.gold], center: Alignment(-0.3, -0.3)),
              boxShadow: [BoxShadow(color: AC.gold.withAlpha(90), blurRadius: 24, spreadRadius: 6),
                BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 12)]),
            child: const Center(child: Text("☽", style: TextStyle(fontSize: 52))),
          ),
          const SizedBox(height: 20),
          Text("AMİN", style: GoogleFonts.amiri(fontSize: 44, color: AC.goldLight, letterSpacing: 6,
            shadows: [const Shadow(color: Colors.black38, blurRadius: 12)])),
          const Text("DUA & ZİKİR UYGULAMASI",
            style: TextStyle(fontSize: 12, color: AC.greenPale, letterSpacing: 2.5)),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(children: [
              _HomeBtn(label: "🤲  DUA ET", isPrimary: true,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KategoriScreen()))),
              const SizedBox(height: 16),
              _HomeBtn(label: "📿  DUALARA DEVAM", isPrimary: false,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DualarDevamScreen()))),
            ]),
          ),
          const SizedBox(height: 40),
          const Text('"Ve Allah\'tan yardım ve muvaffakiyet dileriz."\n2026 © Amin',
            style: TextStyle(fontSize: 11, color: AC.brownDark, letterSpacing: .8),
            textAlign: TextAlign.center),
        ])),
      ),
    );
  }
}

class _HomeBtn extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  const _HomeBtn({required this.label, required this.isPrimary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isPrimary ? const LinearGradient(colors: [AC.gold, AC.goldLight]) : null,
          color: isPrimary ? null : Colors.white12,
          border: isPrimary ? null : Border.all(color: const Color(0x80c9a84c), width: 2),
          boxShadow: [BoxShadow(
            color: isPrimary ? AC.gold.withAlpha(115) : Colors.black26,
            blurRadius: isPrimary ? 20 : 10, offset: const Offset(0, 6))],
        ),
        child: Text(label, textAlign: TextAlign.center,
          style: GoogleFonts.lora(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 2,
            color: isPrimary ? AC.greenDark : AC.goldLight)),
      ),
    );
  }
}

// ── KATEGORİ SCREEN ───────────────────────
class KategoriScreen extends StatelessWidget {
  const KategoriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AC.greenBg,
      appBar: AppBar(
        backgroundColor: AC.greenDark, elevation: 4,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 18),
          onPressed: () => Navigator.maybePop(context)),
        title: Row(children: [
          Container(width: 32, height: 32,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AC.gold),
            child: const Center(child: Text("☽", style: TextStyle(fontSize: 16)))),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("DUA ET", style: GoogleFonts.amiri(fontSize: 17, color: AC.goldLight, letterSpacing: 1)),
            const Text("KATEGORİ SEÇ",
              style: TextStyle(fontSize: 10, color: AC.greenPale, letterSpacing: 1)),
          ]),
        ]),
      ),
      body: Column(children: [
        const _Ornament(),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Hangi kategoride dua etmek istiyorsunuz?",
            style: TextStyle(fontSize: 13, color: AC.greenMain))),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
            itemCount: kategoriler.length,
            itemBuilder: (ctx, i) {
              final k = kategoriler[i];
              return _KategoriCard(
                kategori: k,
                onTap: () => Navigator.push(ctx, MaterialPageRoute(
                  builder: (_) => k.isZikir
                      ? const ZikirlerScreen()
                      : KategoriDualarScreen(kategori: k))),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _KategoriCard extends StatelessWidget {
  final Kategori kategori;
  final VoidCallback onTap;
  const _KategoriCard({required this.kategori, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AC.greenPale, width: 1.5),
          boxShadow: [BoxShadow(color: AC.greenMain.withAlpha(20), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(children: [
          Container(
            width: 68, height: 68,
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AC.greenMain, AC.greenDark]),
              borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(kategori.icon, style: const TextStyle(fontSize: 28))),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(kategori.isim,
                style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.w700, color: AC.greenDark)),
              const SizedBox(height: 4),
              Text(kategori.isZikir
                  ? "${zikirler.length} zikir"
                  : "${kategori.niyetIds.length} dua",
                style: TextStyle(fontSize: 11, color: AC.greenMid, letterSpacing: .5)),
            ]),
          )),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.chevron_right, color: AC.greenMid)),
        ]),
      ),
    );
  }
}

// ── KATEGORİ DUALAR SCREEN ────────────────
class KategoriDualarScreen extends StatefulWidget {
  final Kategori kategori;
  const KategoriDualarScreen({super.key, required this.kategori});
  @override
  State<KategoriDualarScreen> createState() => _KategoriDualarScreenState();
}

class _KategoriDualarScreenState extends State<KategoriDualarScreen> {
  Map<int, int> counts = {};

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final m = <int, int>{};
    for (final n in niyetler) m[n.id] = prefs.getInt('niyet_${n.id}') ?? 0;
    if (mounted) setState(() => counts = m);
  }

  @override
  Widget build(BuildContext context) {
    final map = niyetMap;
    final duas = widget.kategori.niyetIds
        .map((id) => map[id])
        .where((n) => n != null)
        .cast<Niyet>()
        .toList();

    return Scaffold(
      backgroundColor: AC.greenBg,
      appBar: AppBar(
        backgroundColor: AC.greenDark, elevation: 4,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 18),
          onPressed: () => Navigator.maybePop(context)),
        title: Row(children: [
          Text(widget.kategori.icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(child: Text(widget.kategori.isim,
            style: GoogleFonts.amiri(fontSize: 15, color: AC.goldLight, letterSpacing: .5),
            overflow: TextOverflow.ellipsis)),
        ]),
      ),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AC.greenDark.withAlpha(180),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AC.gold.withAlpha(80))),
          child: Text(widget.kategori.sub,
            style: const TextStyle(fontSize: 12, color: AC.greenPale, height: 1.6, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.95),
            itemCount: duas.length,
            itemBuilder: (ctx, i) {
              final n = duas[i];
              final c = counts[n.id] ?? 0;
              final pct = (c / n.hedef).clamp(0.0, 1.0);
              final done = c >= n.hedef;
              return _NiyetCard(
                niyet: n, count: c, pct: pct, done: done,
                onTap: () async {
                  await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => DuaScreen(niyet: n)));
                  _load();
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _NiyetCard extends StatelessWidget {
  final Niyet niyet;
  final int count;
  final double pct;
  final bool done;
  final VoidCallback onTap;
  const _NiyetCard({required this.niyet, required this.count, required this.pct, required this.done, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: done ? const Color(0xFFFFFBF0) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: done ? AC.gold : Colors.transparent, width: 2),
          boxShadow: [BoxShadow(color: AC.greenMain.withAlpha(33), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(niyet.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(niyet.isim,
            style: GoogleFonts.lora(fontSize: 12.5, fontWeight: FontWeight.w700,
              color: done ? AC.gold : AC.greenDark),
            textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(niyet.sub,
            style: const TextStyle(fontSize: 10.5, color: AC.greenMid),
            textAlign: TextAlign.center),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: pct, backgroundColor: AC.greenBg, color: AC.greenMid, minHeight: 5)),
          if (count ~/ niyet.hedef > 0) ...[
            const SizedBox(height: 5),
            Text("✅ ${count ~/ niyet.hedef} tertip tamamlandı",
              style: const TextStyle(fontSize: 9.5, color: AC.greenMid),
              textAlign: TextAlign.center),
          ],
        ]),
      ),
    );
  }
}

// ── DUALARA DEVAM ─────────────────────────
class DualarDevamScreen extends StatefulWidget {
  const DualarDevamScreen({super.key});
  @override
  State<DualarDevamScreen> createState() => _DualarDevamScreenState();
}

class _DualarDevamScreenState extends State<DualarDevamScreen> {
  Map<int, int> counts = {};

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final m = <int, int>{};
    for (final n in niyetler) m[n.id] = prefs.getInt('niyet_${n.id}') ?? 0;
    if (mounted) setState(() => counts = m);
  }

  Future<void> _sil(Niyet n) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('niyet_${n.id}', 0);
    if (mounted) setState(() => counts[n.id] = 0);
  }

  List<Niyet> get _yarimKalanlar => niyetler
      .where((n) => (counts[n.id] ?? 0) > 0 && (counts[n.id] ?? 0) < n.hedef)
      .toList();

  @override
  Widget build(BuildContext context) {
    final liste = _yarimKalanlar;
    return Scaffold(
      backgroundColor: AC.greenBg,
      appBar: AppBar(
        backgroundColor: AC.greenDark, elevation: 4,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 18),
          onPressed: () => Navigator.maybePop(context)),
        title: Row(children: [
          Container(width: 32, height: 32,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AC.gold),
            child: const Center(child: Text("📿", style: TextStyle(fontSize: 18)))),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("DUALARA DEVAM",
              style: GoogleFonts.amiri(fontSize: 17, color: AC.goldLight, letterSpacing: 1)),
            const Text("YARI KALAN DUALAR",
              style: TextStyle(fontSize: 10, color: AC.greenPale, letterSpacing: 1)),
          ]),
        ]),
      ),
      body: liste.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("🌙", style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              Text("Yarım kalan dua yok",
                style: GoogleFonts.lora(fontSize: 18, color: AC.greenMain, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text("Yeni bir dua başlatmak için\nana sayfadan 'DUA ET' seçiniz.",
                style: TextStyle(fontSize: 13, color: AC.greenMid), textAlign: TextAlign.center),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: liste.length,
              itemBuilder: (ctx, i) {
                final n = liste[i];
                final c = counts[n.id] ?? 0;
                final pct = (c / n.hedef).clamp(0.0, 1.0);
                return _DevamCard(
                  niyet: n, count: c, pct: pct,
                  onSil: () => _sil(n),
                  onTap: () async {
                    await Navigator.push(ctx, MaterialPageRoute(builder: (_) => DuaScreen(niyet: n)));
                    _load();
                  },
                );
              },
            ),
    );
  }
}

class _DevamCard extends StatelessWidget {
  final Niyet niyet;
  final int count;
  final double pct;
  final VoidCallback onSil, onTap;
  const _DevamCard({required this.niyet, required this.count, required this.pct,
    required this.onSil, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AC.greenPale, width: 1.5),
          boxShadow: [BoxShadow(color: AC.greenMain.withAlpha(25), blurRadius: 10, offset: const Offset(0, 3))]),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(width: 56, height: 56,
                decoration: BoxDecoration(color: AC.greenBg, borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(niyet.icon, style: const TextStyle(fontSize: 26)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(niyet.isim,
                  style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.w700, color: AC.greenDark)),
                const SizedBox(height: 2),
                Text(niyet.duaAdi, style: TextStyle(fontSize: 12, color: AC.greenMid)),
                const SizedBox(height: 8),
                Row(children: [
                  Text("$count", style: GoogleFonts.lora(
                    fontSize: 18, fontWeight: FontWeight.bold, color: AC.greenMain)),
                  Text(" / ${niyet.hedef}", style: TextStyle(fontSize: 13, color: AC.greenMid)),
                  const Spacer(),
                  Text("${(pct * 100).toStringAsFixed(0)}%",
                    style: TextStyle(fontSize: 12, color: AC.gold, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pct, minHeight: 7, backgroundColor: AC.greenBg, color: AC.greenMid)),
              ])),
              const SizedBox(width: 36),
            ]),
          ),
          Positioned(
            top: 8, right: 8,
            child: GestureDetector(
              onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
                title: Text("Sıfırla", style: GoogleFonts.lora(color: AC.greenDark)),
                content: Text("'${niyet.isim}' için ilerleme sıfırlansın mı?",
                  style: TextStyle(color: AC.greenMain)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context),
                    child: Text("İptal", style: TextStyle(color: AC.greenMid))),
                  TextButton(onPressed: () { Navigator.pop(context); onSil(); },
                    child: const Text("Sıfırla", style: TextStyle(color: Colors.red))),
                ],
              )),
              child: Container(
                width: 26, height: 26,
                decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.shade200)),
                child: Icon(Icons.close, size: 15, color: Colors.red.shade400),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── DUA SCREEN ────────────────────────────
class DuaScreen extends StatefulWidget {
  final Niyet niyet;
  const DuaScreen({super.key, required this.niyet});
  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> with SingleTickerProviderStateMixin {
  int count = 0;
  bool showTurkish = false;
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _load();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => count = prefs.getInt('niyet_${widget.niyet.id}') ?? 0);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('niyet_${widget.niyet.id}', count);
  }

  void _tap() async {
    if (count >= widget.niyet.hedef) return;
    HapticFeedback.lightImpact();
    setState(() => count++);
    _save();
    await _ctrl.forward();
    await _ctrl.reverse();
  }

  Future<void> _reset() async { setState(() => count = 0); await _save(); }

  @override
  Widget build(BuildContext context) {
    final n = widget.niyet;
    final done = count >= n.hedef;
    final pct = (count / n.hedef).clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [AC.greenDark, AC.greenMain, AC.greenBg], stops: [0.0, 0.5, 1.0])),
        child: SafeArea(child: Column(children: [
          Container(
            color: AC.greenDark,
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 18),
                onPressed: () => Navigator.maybePop(context)),
              Container(width: 32, height: 32,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AC.gold),
                child: const Center(child: Text("☽", style: TextStyle(fontSize: 16)))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.isim,
                  style: GoogleFonts.amiri(fontSize: 15, color: AC.goldLight, letterSpacing: 1),
                  overflow: TextOverflow.ellipsis),
                const Text("DUA SAYACI",
                  style: TextStyle(fontSize: 10, color: AC.greenPale, letterSpacing: 1)),
              ])),
            ]),
          ),
          Expanded(child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
              child: Column(children: [
                Text(n.duaAdi,
                  style: GoogleFonts.amiri(fontSize: 26, color: AC.goldLight), textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text("✦ ${n.isim} ✦",
                  style: const TextStyle(fontSize: 12, color: AC.greenPale, letterSpacing: 1.5)),
              ]),
            ),
            const _Ornament(),
            // Dua kutusu + TR switch — kutu her zaman tam yüksekliği doldurur
            Expanded(child: LayoutBuilder(
              builder: (ctx, bc) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(anim),
                    child: child)),
                child: showTurkish
                    ? _DuaKutu(key: const ValueKey('tr'), isTurkish: true, content: n.turkish,
                        availHeight: bc.maxHeight, showTurkish: true,
                        onToggle: () => setState(() => showTurkish = !showTurkish))
                    : _DuaKutu(key: const ValueKey('ar'), isTurkish: false, arabic: n.arabic, latin: n.latin,
                        availHeight: bc.maxHeight, showTurkish: false,
                        onToggle: () => setState(() => showTurkish = !showTurkish)),
              ),
            )),
            const SizedBox(height: 18),
            RichText(text: TextSpan(
              style: GoogleFonts.lora(fontSize: 16, color: AC.goldLight),
              children: [
                const TextSpan(text: "Okunan "),
                TextSpan(text: "$count",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const TextSpan(text: "  /  Gereken "),
                TextSpan(text: "${n.hedef}",
                  style: const TextStyle(color: AC.goldLight, fontWeight: FontWeight.bold)),
              ],
            )),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: ClipRRect(borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: pct,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(AC.greenLight), minHeight: 8)),
            ),
            const SizedBox(height: 24),
            if (!done)
              ScaleTransition(
                scale: _scaleAnim,
                child: GestureDetector(
                  onTap: _tap,
                  child: Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [AC.goldLight, AC.gold], center: Alignment(-0.3, -0.3)),
                      boxShadow: [
                        BoxShadow(color: AC.gold.withAlpha(90), blurRadius: 24, spreadRadius: 8),
                        BoxShadow(color: Colors.black.withAlpha(77), blurRadius: 12)],
                    ),
                    child: const Center(child: Text("☽", style: TextStyle(fontSize: 52))),
                  ),
                ),
              )
            else
              _TamamlandiWidget(onReset: _reset),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AC.greenDark.withAlpha(160), borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AC.greenMid.withAlpha(100))),
                child: Text(n.tip,
                  style: const TextStyle(fontSize: 12, color: AC.greenPale, height: 1.7),
                  textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 24),
          ])),
        ])),
      ),
    );
  }
}

class _DuaKutu extends StatelessWidget {
  final bool isTurkish;
  final String? arabic, latin, content;
  final bool showTurkish;
  final VoidCallback onToggle;
  final double availHeight;
  const _DuaKutu({super.key, required this.isTurkish, this.arabic, this.latin, this.content,
      required this.showTurkish, required this.onToggle, required this.availHeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: availHeight,
            padding: const EdgeInsets.fromLTRB(18, 36, 18, 18),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(18), borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AC.gold.withAlpha(77))),
            child: SingleChildScrollView(
              child: isTurkish
                  ? Column(children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AC.gold.withAlpha(60), borderRadius: BorderRadius.circular(8)),
                          child: const Text("TÜRKÇE MEAL",
                            style: TextStyle(fontSize: 10, color: AC.goldLight, letterSpacing: 1.5))),
                      ]),
                      const SizedBox(height: 10),
                      Text(content ?? '', style: GoogleFonts.lora(fontSize: 13.5, color: Colors.white, height: 1.9),
                        textAlign: TextAlign.center),
                    ])
                  : Column(children: [
                      Text(arabic ?? '', style: GoogleFonts.amiri(fontSize: 15, color: AC.goldLight, height: 2.0),
                        textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Text(latin ?? '', style: GoogleFonts.lora(
                        fontSize: 13, color: AC.greenPale, fontStyle: FontStyle.italic, height: 1.8),
                        textAlign: TextAlign.center),
                    ]),
            ),
          ),
          Positioned(
            top: 8, right: 8,
            child: GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: showTurkish ? AC.gold : Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AC.gold.withAlpha(180), width: 1.5)),
                child: Text(showTurkish ? "AR" : "TR",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1,
                    color: showTurkish ? AC.greenDark : AC.goldLight)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TamamlandiWidget extends StatelessWidget {
  final VoidCallback onReset;
  const _TamamlandiWidget({required this.onReset});
  @override
  Widget build(BuildContext context) => Column(children: [
    const Text("✦", style: TextStyle(fontSize: 30, color: AC.gold)),
    const SizedBox(height: 8),
    Text("TAMAMLANDI", style: GoogleFonts.amiri(fontSize: 30, color: AC.goldLight, letterSpacing: 3)),
    const SizedBox(height: 8),
    const Text("Duanız kabul olsun inşallah.\nAllah cc. niyetinizi bilir ve duanızı işitir.",
      style: TextStyle(fontSize: 13, color: AC.greenPale, height: 1.6), textAlign: TextAlign.center),
    const SizedBox(height: 16),
    GestureDetector(
      onTap: onReset,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AC.gold, width: 2)),
        child: Text("Yeniden Başla", style: GoogleFonts.lora(fontSize: 14, color: AC.greenDark))),
    ),
  ]);
}

class _Ornament extends StatelessWidget {
  const _Ornament();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Text("✦  ✦  ✦", style: TextStyle(fontSize: 18, color: AC.gold, letterSpacing: 8)));
}

// ── ZİKİRLER SCREEN ───────────────────────
class ZikirlerScreen extends StatefulWidget {
  const ZikirlerScreen({super.key});
  @override
  State<ZikirlerScreen> createState() => _ZikirlerScreenState();
}

class _ZikirlerScreenState extends State<ZikirlerScreen> {
  Map<int, int> counts = {};

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final m = <int, int>{};
    for (final z in zikirler) m[z.id] = prefs.getInt('zikir_${z.id}') ?? 0;
    if (mounted) setState(() => counts = m);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AC.greenBg,
      appBar: AppBar(
        backgroundColor: AC.greenDark, elevation: 4,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 18),
          onPressed: () => Navigator.maybePop(context)),
        title: Row(children: [
          const Text("📿", style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("ZİKİRLER", style: GoogleFonts.amiri(fontSize: 17, color: AC.goldLight, letterSpacing: 1)),
            const Text("TEBSİH & ESMAÜL HÜSNA",
              style: TextStyle(fontSize: 10, color: AC.greenPale, letterSpacing: 1)),
          ]),
        ]),
      ),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AC.greenDark.withAlpha(180),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AC.gold.withAlpha(80))),
          child: const Text(
            "Tesbih, esmaül hüsna ve günlük zikirler. Her birini istediğiniz kadar çekerek kalbinizi Allah'ın zikriyle doldurabilirsiniz.",
            style: TextStyle(fontSize: 12, color: AC.greenPale, height: 1.6, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.95),
            itemCount: zikirler.length,
            itemBuilder: (ctx, i) {
              final z = zikirler[i];
              final c = counts[z.id] ?? 0;
              final pct = (c / z.hedef).clamp(0.0, 1.0);
              final done = c >= z.hedef;
              return GestureDetector(
                onTap: () async {
                  await Navigator.push(ctx, MaterialPageRoute(builder: (_) => ZikirSayacScreen(zikir: z)));
                  _load();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: done ? const Color(0xFFFFFBF0) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: done ? AC.gold : Colors.transparent, width: 2),
                    boxShadow: [BoxShadow(color: AC.greenMain.withAlpha(33), blurRadius: 10, offset: const Offset(0, 3))],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(z.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 8),
                    Text(done ? "✅ ${z.isim}" : z.isim,
                      style: GoogleFonts.lora(fontSize: 12.5, fontWeight: FontWeight.w700,
                        color: done ? AC.gold : AC.greenDark),
                      textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(z.anlam,
                      style: const TextStyle(fontSize: 10.5, color: AC.greenMid),
                      textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ClipRRect(borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: pct, backgroundColor: AC.greenBg, color: AC.greenMid, minHeight: 5)),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

// ── ZİKİR SAYAC SCREEN ────────────────────
class ZikirSayacScreen extends StatefulWidget {
  final Zikir zikir;
  const ZikirSayacScreen({super.key, required this.zikir});
  @override
  State<ZikirSayacScreen> createState() => _ZikirSayacScreenState();
}

class _ZikirSayacScreenState extends State<ZikirSayacScreen> with SingleTickerProviderStateMixin {
  int count = 0;
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _load();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => count = prefs.getInt('zikir_${widget.zikir.id}') ?? 0);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('zikir_${widget.zikir.id}', count);
  }

  void _tap() async {
    if (count >= widget.zikir.hedef) return;
    HapticFeedback.lightImpact();
    setState(() => count++);
    _save();
    await _ctrl.forward();
    await _ctrl.reverse();
  }

  Future<void> _reset() async { setState(() => count = 0); await _save(); }

  @override
  Widget build(BuildContext context) {
    final z = widget.zikir;
    final done = count >= z.hedef;
    final pct = (count / z.hedef).clamp(0.0, 1.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [AC.greenDark, AC.greenMain, AC.greenBg], stops: [0.0, 0.5, 1.0])),
        child: SafeArea(child: Column(children: [
          Container(
            color: AC.greenDark,
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 18),
                onPressed: () => Navigator.maybePop(context)),
              const Text("📿", style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(z.isim,
                  style: GoogleFonts.amiri(fontSize: 15, color: AC.goldLight, letterSpacing: 1),
                  overflow: TextOverflow.ellipsis),
                const Text("ZİKİR SAYACI",
                  style: TextStyle(fontSize: 10, color: AC.greenPale, letterSpacing: 1)),
              ])),
            ]),
          ),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
                child: Text(z.isim,
                  style: GoogleFonts.amiri(fontSize: 32, color: AC.goldLight), textAlign: TextAlign.center),
              ),
              const _Ornament(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(18), borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AC.gold.withAlpha(77))),
                child: Column(children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AC.gold.withAlpha(60), borderRadius: BorderRadius.circular(8)),
                      child: const Text("ANLAMI", style: TextStyle(fontSize: 10, color: AC.goldLight, letterSpacing: 1.5)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(z.anlam,
                    style: GoogleFonts.lora(fontSize: 14, color: Colors.white, height: 1.8),
                    textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AC.greenMid.withAlpha(80), borderRadius: BorderRadius.circular(8)),
                      child: const Text("HİKMETİ", style: TextStyle(fontSize: 10, color: AC.greenPale, letterSpacing: 1.5)),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(z.hikmet,
                    style: const TextStyle(fontSize: 13, color: AC.greenPale, height: 1.8, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center),
                ]),
              ),
              const SizedBox(height: 18),
              RichText(text: TextSpan(
                style: GoogleFonts.lora(fontSize: 16, color: AC.goldLight),
                children: [
                  const TextSpan(text: "Okunan "),
                  TextSpan(text: "$count",
                    style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold)),
                  const TextSpan(text: "  /  Gereken "),
                  TextSpan(text: "${z.hedef}",
                    style: const TextStyle(color: AC.goldLight, fontWeight: FontWeight.bold)),
                ],
              )),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: pct,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(AC.greenLight), minHeight: 8)),
              ),
              const SizedBox(height: 24),
              if (!done)
                ScaleTransition(
                  scale: _scaleAnim,
                  child: GestureDetector(
                    onTap: _tap,
                    child: Container(
                      width: 140, height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [AC.goldLight, AC.gold], center: Alignment(-0.3, -0.3)),
                        boxShadow: [
                          BoxShadow(color: AC.gold.withAlpha(90), blurRadius: 24, spreadRadius: 8),
                          BoxShadow(color: Colors.black.withAlpha(77), blurRadius: 12)],
                      ),
                      child: const Center(child: Text("📿", style: TextStyle(fontSize: 52))),
                    ),
                  ),
                )
              else
                Column(children: [
                  const Text("✦", style: TextStyle(fontSize: 30, color: AC.gold)),
                  const SizedBox(height: 8),
                  Text("TAMAMLANDI", style: GoogleFonts.amiri(fontSize: 30, color: AC.goldLight, letterSpacing: 3)),
                  const SizedBox(height: 8),
                  const Text("Zikriniz kabul olsun inşallah.",
                    style: TextStyle(fontSize: 13, color: AC.greenPale, height: 1.6), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _reset,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AC.gold, width: 2)),
                      child: Text("Yeniden Başla", style: GoogleFonts.lora(fontSize: 14, color: AC.greenDark))),
                  ),
                ]),
            ]),
          )),
        ])),
      ),
    );
  }
}
