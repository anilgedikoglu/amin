// Yeni Müslüman rehberi — adım adım Müslüman olma, hikmetleri; iman ve İslam'ın
// şartları; başlıca haramlar (nedenleriyle, madde madde). İçerik öğretici amaçlıdır.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';

class _Madde {
  final String baslik, aciklama;
  const _Madde(this.baslik, this.aciklama);
}

class _Bolum {
  final String baslik, giris;
  final IconData icon;
  final List<_Madde> maddeler;
  const _Bolum(this.icon, this.baslik, this.giris, this.maddeler);
}

const List<_Bolum> _bolumler = [
  _Bolum(
    Icons.directions_walk_rounded,
    'Müslüman Olmanın Adımları',
    'İslam\'a giriş zorlama değil, gönülden bir tercihtir (\"Dinde zorlama yoktur\" — Bakara, 256). Aşağıdaki adımlar sırayla, acele etmeden atılır.',
    [
      _Madde('1. Kalpten inanmak ve niyet etmek',
          'Önce kalben Allah\'ın bir ve tek olduğuna, Hz. Muhammed\'in O\'nun elçisi olduğuna inanılır. İslam\'ın özü dilin söylediğini kalbin tasdik etmesidir. Hikmet: İman bir taklit değil, içten bir kabul ve teslimiyettir.'),
      _Madde('2. Kelime-i Şehadet\'i söylemek',
          '"Eşhedü en lâ ilâhe illallah ve eşhedü enne Muhammeden abdühû ve rasûlüh." (Şahitlik ederim ki Allah\'tan başka ilah yoktur ve şahitlik ederim ki Muhammed O\'nun kulu ve elçisidir.) İki şahit huzurunda söylemek güzeldir ama şart değildir; aslolan kalbin tasdiki ve dilin ikrarıdır. Hikmet: İnancı açıkça dile getirmek, ona şahit olmaktır.'),
      _Madde('3. Gusül abdesti almak (boy abdesti)',
          'Tüm bedeni yıkayarak temizlenmek, yeni ve temiz bir sayfa açmanın sembolüdür. Hikmet: Maddi temizlik manevi arınmaya eşlik eder; insan adeta yeniden doğar.'),
      _Madde('4. Abdest ve namazı öğrenmek',
          'Günlük ibadetin temeli olan abdest ve beş vakit namaz adım adım öğrenilir. Baştan hepsini kusursuz yapmak gerekmez; önemli olan başlamak ve sürdürmektir. Hikmet: Namaz, Allah ile günde beş kez yenilenen canlı bir bağdır.'),
      _Madde('5. Temel bilgileri öğrenmek',
          'İmanın ve İslam\'ın şartları, helal ve haramlar yavaş yavaş öğrenilir. Bilen birinden (hoca, güvenilir kaynak) destek almak süreci kolaylaştırır. Hikmet: Bilgi, ibadeti şuurlu ve kalıcı kılar.'),
      _Madde('6. Sabır ve süreklilik',
          'Her şeyi bir günde yapmaya çalışmak yerine istikrarlı küçük adımlar atılır. Hata yapınca tövbe kapısı her zaman açıktır. Hikmet: "Amellerin en hayırlısı, az da olsa devamlı olanıdır." (Hadis)'),
    ],
  ),
  _Bolum(
    Icons.favorite_rounded,
    'İmanın Şartları (6)',
    'Âmentü\'de özetlenen, kalben inanılması gereken altı esastır.',
    [
      _Madde('1. Allah\'a iman',
          'O\'nun var, bir, eşi ve benzeri olmayan, her şeyin yaratıcısı olduğuna inanmak. Tevhid inancın temelidir.'),
      _Madde('2. Meleklere iman',
          'Nurdan yaratılmış, Allah\'a isyan etmeyen, görevli varlıkların varlığına inanmak (Cebrail, Mikail vb.).'),
      _Madde('3. Kitaplara iman',
          'Allah\'ın peygamberlerine indirdiği ilahî kitaplara (Tevrat, Zebur, İncil ve son kitap Kur\'an) inanmak.'),
      _Madde('4. Peygamberlere iman',
          'Allah\'ın insanlığa yol göstermek için gönderdiği bütün peygamberlere; sonuncusu Hz. Muhammed (s.a.v.) olmak üzere inanmak.'),
      _Madde('5. Ahiret gününe iman',
          'Ölümden sonra dirilişe, hesaba, cennet ve cehenneme inanmak. Bu inanç, adaletin nihai olarak tecellî edeceğini bildirir.'),
      _Madde('6. Kadere iman',
          'Hayrın ve şerrin Allah\'ın bilgisi ve takdiriyle olduğuna inanmak. Bu, insanın sorumluluğunu kaldırmaz; insan iradesiyle seçer, Allah yaratır.'),
    ],
  ),
  _Bolum(
    Icons.star_rounded,
    'İslam\'ın Şartları (5)',
    'İslam binasının üzerine kurulduğu beş temel ibadettir.',
    [
      _Madde('1. Kelime-i Şehadet',
          'Allah\'tan başka ilah olmadığına ve Muhammed\'in O\'nun elçisi olduğuna şahitlik etmek. Neden: Tüm ibadetlerin dayandığı iman ikrarıdır.'),
      _Madde('2. Namaz (günde 5 vakit)',
          'Belirli vakitlerde Allah\'ın huzuruna durmak. Neden: Kulu Rabbiyle sürekli irtibatta tutar, disiplin ve huzur verir, kötülükten alıkoyar.'),
      _Madde('3. Oruç (Ramazan ayı)',
          'Bir ay boyunca tan yerinden akşama kadar yeme-içme ve nefsanî isteklerden uzak durmak. Neden: Nefsi terbiye eder, sabrı öğretir, açların halini hissettirir.'),
      _Madde('4. Zekât',
          'Belirli bir zenginliğe ulaşanın malının kırkta birini (%2,5) ihtiyaç sahiplerine vermesi. Neden: Malı arındırır, cimriliği kırar, sosyal adaleti sağlar.'),
      _Madde('5. Hac (gücü yetene ömürde bir kez)',
          'Mekke\'de Kâbe\'yi ziyaret ederek belirli ibadetleri yapmak. Neden: Tüm Müslümanların eşitlik ve kardeşlik içinde buluştuğu büyük bir birlik tecrübesidir.'),
    ],
  ),
  _Bolum(
    Icons.block_rounded,
    'Başlıca Haramlar (Nedenleriyle)',
    'Haramlar keyfî yasaklar değil, insanı ve toplumu korumaya yönelik sınırlardır.',
    [
      _Madde('Şirk (Allah\'a ortak koşmak)',
          'En büyük günahtır. Neden: Tevhid inancının özüne aykırıdır; insanı sahte ilahların kulu yapar.'),
      _Madde('İçki ve uyuşturucu',
          'Neden: Aklı ve iradeyi giderir; sağlığa, aileye ve topluma zarar verir. Akıl, korunması gereken temel emanettir.'),
      _Madde('Kumar',
          'Neden: Emeksiz kazanç ve başkasının zararı üzerine kuruludur; bağımlılık, düşmanlık ve yıkım getirir.'),
      _Madde('Faiz',
          'Neden: Emeksiz, parayla para kazanıp ihtiyaç sahibini sömürür; serveti azınlıkta toplar, adaleti bozar.'),
      _Madde('Zina ve gayrimeşru ilişki',
          'Neden: Nesli, aileyi ve toplumun güven temelini sarsar; iffeti ve sadakati zedeler.'),
      _Madde('Hırsızlık, gasp, kul hakkı',
          'Neden: Başkasının hakkını çiğner. Kul hakkının affı, Allah\'a değil, hak sahibine bağlıdır.'),
      _Madde('Yalan, iftira, gıybet',
          'Neden: Güveni ve insanlar arası ilişkileri çürütür; insanların onurunu zedeler.'),
      _Madde('Haksız yere cana kıymak',
          'Neden: Bir cana kıymak, bütün insanlığa kıymak gibidir (Mâide, 32). Hayat Allah\'ın emanetidir.'),
      _Madde('Domuz eti, leş ve kan',
          'Neden: Kur\'an\'da açıkça yasaklanmıştır; tahir (temiz) sayılmayan ve zarar barındıran gıdalardır.'),
    ],
  ),
  _Bolum(
    Icons.tips_and_updates_rounded,
    'Yeni Başlayana Tavsiyeler',
    'Yolculuk uzun değil; istikrarlı ve huzurludur.',
    [
      _Madde('Acele etme, adım adım ilerle',
          'Önce farzları öğren, sonra detayları. Allah kolaylık diler, zorluk değil (Bakara, 185).'),
      _Madde('Niyetini koru, sürekli ol',
          'Küçük ama düzenli ibadet, büyük ama kesik ibadetten hayırlıdır.'),
      _Madde('Öğrenmekten çekinme',
          'Bilmediğini sormak ayıp değil, erdemdir. Güvenilir kaynaklardan ve hocalardan faydalan.'),
      _Madde('Tövbe kapısı her zaman açık',
          'Hata yapmak insanîdir; önemli olan pişman olup yeniden doğrulmaktır. Allah çok bağışlayandır.'),
    ],
  ),
];

class YeniMuslumanScreen extends StatelessWidget {
  const YeniMuslumanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Yeni Müslüman')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 28),
        children: [
          // Hoş geldin
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [QC.greenMain, QC.greenDark]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.volunteer_activism_rounded, color: QC.goldLight, size: 26),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Hoş geldin',
                      style: GoogleFonts.lora(
                          fontSize: 19, fontWeight: FontWeight.w800, color: QC.goldLight)),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                  'İslam\'a ilgi duyman güzel bir adımdır. Bu rehber, Müslüman olmanın adımlarını, iman ve İslam\'ın şartlarını ve temel sınırları sade bir dille, nedenleriyle birlikte anlatır.',
                  style: GoogleFonts.lora(fontSize: 13, height: 1.55, color: QC.greenPale)),
            ]),
          ),
          const SizedBox(height: 18),
          for (final b in _bolumler) _bolumKart(b),
        ],
      ),
    );
  }

  Widget _bolumKart(_Bolum b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: QC.greenPale.withAlpha(160)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          leading: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                    center: Alignment(-0.3, -0.4), colors: [QC.goldLight, QC.gold])),
            child: Icon(b.icon, color: QC.greenDark, size: 22),
          ),
          title: Text(b.baslik,
              style: GoogleFonts.lora(
                  fontSize: 15.5, fontWeight: FontWeight.w800, color: QC.greenDark)),
          iconColor: QC.gold,
          collapsedIconColor: QC.gold,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(b.giris,
                  style: GoogleFonts.lora(
                      fontSize: 12.5,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                      color: QC.greenMid)),
            ),
            for (final m in b.maddeler) _maddeTile(m),
          ],
        ),
      ),
    );
  }

  Widget _maddeTile(_Madde m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: QC.greenBg.withAlpha(140),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: QC.gold.withAlpha(160), width: 3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(m.baslik,
            style: GoogleFonts.lora(
                fontSize: 13.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
        const SizedBox(height: 4),
        Text(m.aciklama,
            style: GoogleFonts.lora(fontSize: 12.5, height: 1.55, color: QC.greenDark)),
      ]),
    );
  }
}
