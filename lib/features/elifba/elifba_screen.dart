// Arapça Okuma (Elifba) — sıfırdan Arapça okumayı öğreten dersler.
// Harfler → harekeler → med/şedde/tenvin → kelimeler → ibareler. Türkçe anlamlı.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';

class _Oge {
  final String ar; // Arapça
  final String oku; // okunuşu / adı
  final String? anlam; // Türkçe anlam (kelimeler için)
  const _Oge(this.ar, this.oku, [this.anlam]);
}

class _Ders {
  final String baslik, aciklama;
  final int sutun; // grid sütun sayısı
  final List<_Oge> ogeler;
  const _Ders(this.baslik, this.aciklama, this.sutun, this.ogeler);
}

const List<_Ders> _dersler = [
  _Ders('1. Ders — Harfler', 'Arap alfabesindeki 28 harf ve isimleri. Her harfi sesli sesli tekrarla.', 4, [
    _Oge('ا', 'elif'), _Oge('ب', 'be'), _Oge('ت', 'te'), _Oge('ث', 'se'),
    _Oge('ج', 'cim'), _Oge('ح', 'ha'), _Oge('خ', 'hı'), _Oge('د', 'dal'),
    _Oge('ذ', 'zel'), _Oge('ر', 'ra'), _Oge('ز', 'ze'), _Oge('س', 'sin'),
    _Oge('ش', 'şın'), _Oge('ص', 'sad'), _Oge('ض', 'dad'), _Oge('ط', 'tı'),
    _Oge('ظ', 'zı'), _Oge('ع', 'ayn'), _Oge('غ', 'gayn'), _Oge('ف', 'fe'),
    _Oge('ق', 'kaf'), _Oge('ك', 'kef'), _Oge('ل', 'lam'), _Oge('م', 'mim'),
    _Oge('ن', 'nun'), _Oge('و', 'vav'), _Oge('ه', 'he'), _Oge('ي', 'ye'),
  ]),
  _Ders('2. Ders — Harflerin Yazılışı', 'Harfler kelime içinde başta, ortada ve sonda farklı yazılır. Örnekler:', 3, [
    _Oge('بـ', 'be (başta)'), _Oge('ـبـ', 'be (ortada)'), _Oge('ـب', 'be (sonda)'),
    _Oge('عـ', 'ayn (başta)'), _Oge('ـعـ', 'ayn (ortada)'), _Oge('ـع', 'ayn (sonda)'),
    _Oge('كـ', 'kef (başta)'), _Oge('ـكـ', 'kef (ortada)'), _Oge('ـك', 'kef (sonda)'),
  ]),
  _Ders('3. Ders — Üstün (Fetha)', 'Harfin üstündeki eğik çizgi "e/a" sesi verir. Üstünlü harfi oku:', 4, [
    _Oge('بَ', 'be'), _Oge('تَ', 'te'), _Oge('جَ', 'ce'), _Oge('دَ', 'de'),
    _Oge('رَ', 'ra'), _Oge('سَ', 'se'), _Oge('كَ', 'ke'), _Oge('لَ', 'le'),
    _Oge('مَ', 'me'), _Oge('نَ', 'ne'), _Oge('وَ', 've'), _Oge('يَ', 'ye'),
  ]),
  _Ders('4. Ders — Esre (Kesre)', 'Harfin altındaki eğik çizgi "i" sesi verir. Esreli harfi oku:', 4, [
    _Oge('بِ', 'bi'), _Oge('تِ', 'ti'), _Oge('جِ', 'ci'), _Oge('دِ', 'di'),
    _Oge('رِ', 'ri'), _Oge('سِ', 'si'), _Oge('كِ', 'ki'), _Oge('لِ', 'li'),
    _Oge('مِ', 'mi'), _Oge('نِ', 'ni'), _Oge('وِ', 'vi'), _Oge('يِ', 'yi'),
  ]),
  _Ders('5. Ders — Ötre (Damme)', 'Harfin üstündeki küçük "vav" işareti "u/ü" sesi verir. Ötreli harfi oku:', 4, [
    _Oge('بُ', 'bu'), _Oge('تُ', 'tu'), _Oge('جُ', 'cu'), _Oge('دُ', 'du'),
    _Oge('رُ', 'ru'), _Oge('سُ', 'su'), _Oge('كُ', 'ku'), _Oge('لُ', 'lu'),
    _Oge('مُ', 'mu'), _Oge('نُ', 'nu'), _Oge('وُ', 'vu'), _Oge('يُ', 'yu'),
  ]),
  _Ders('6. Ders — Cezm (Sükûn)', 'Harfin üstündeki küçük daire harfin sessiz (harekesiz) okunacağını gösterir:', 3, [
    _Oge('اَبْ', 'eb', 'baba'), _Oge('مَنْ', 'men', 'kim'), _Oge('قُلْ', 'kul', 'de/söyle'),
    _Oge('هَلْ', 'hel', 'mı?'), _Oge('كَمْ', 'kem', 'kaç'), _Oge('نَمْ', 'nem', 'uyu'),
  ]),
  _Ders('7. Ders — Şedde', 'Harfin üstündeki "w" benzeri işaret, o harfin iki kez (kalın) okunacağını gösterir:', 3, [
    _Oge('رَبّ', 'rabb', 'Rab'), _Oge('حَقّ', 'hakk', 'gerçek'), _Oge('اُمّ', 'ümm', 'anne'),
    _Oge('حُبّ', 'hubb', 'sevgi'), _Oge('سِرّ', 'sırr', 'sır'), _Oge('عِزّ', 'izz', 'şeref'),
  ]),
  _Ders('8. Ders — Tenvin', 'Harekenin iki kez yazılması sona "n" sesi ekler: en, in, un.', 3, [
    _Oge('اً', 'en'), _Oge('اٍ', 'in'), _Oge('اٌ', 'un'),
    _Oge('كِتَابًا', 'kitâben', 'bir kitap'), _Oge('عِلْمًا', 'ilmen', 'bir ilim'), _Oge('نُورًا', 'nûran', 'bir nur'),
  ]),
  _Ders('9. Ders — Uzatma (Med)', 'Elif, vav ve ye harfleri sesi uzatır: â, û, î.', 3, [
    _Oge('بَا', 'bâ'), _Oge('بُو', 'bû'), _Oge('بِي', 'bî'),
    _Oge('قَالَ', 'kâle', 'dedi'), _Oge('يَقُولُ', 'yekûlü', 'der/söyler'), _Oge('قِيلَ', 'kîle', 'denildi'),
  ]),
  _Ders('10. Ders — Kelimeler', 'Öğrendiğin harf ve harekelerle basit kelimeleri oku ve anlamını öğren:', 2, [
    _Oge('يَد', 'yed', 'el'), _Oge('دَم', 'dem', 'kan'),
    _Oge('نَار', 'nâr', 'ateş'), _Oge('مَاء', 'mâ', 'su'),
    _Oge('نُور', 'nûr', 'ışık, nur'), _Oge('عِلْم', 'ilm', 'ilim, bilgi'),
    _Oge('قَلَم', 'kalem', 'kalem'), _Oge('كِتَاب', 'kitâb', 'kitap'),
    _Oge('بَيْت', 'beyt', 'ev'), _Oge('يَوْم', 'yevm', 'gün'),
    _Oge('قَمَر', 'kamer', 'ay'), _Oge('شَمْس', 'şems', 'güneş'),
    _Oge('اَرْض', 'ard', 'yer, toprak'), _Oge('سَمَاء', 'semâ', 'gökyüzü'),
    _Oge('نَجْم', 'necm', 'yıldız'), _Oge('بَحْر', 'bahr', 'deniz'),
    _Oge('نَهْر', 'nehr', 'nehir'), _Oge('جَبَل', 'cebel', 'dağ'),
    _Oge('شَجَر', 'şecer', 'ağaç'), _Oge('وَرْد', 'verd', 'gül'),
    _Oge('طَيْر', 'tayr', 'kuş'), _Oge('حُوت', 'hût', 'balık'),
    _Oge('اَسَد', 'esed', 'aslan'), _Oge('نَاقَة', 'nâka', 'dişi deve'),
    _Oge('اَب', 'eb', 'baba'), _Oge('اُمّ', 'ümm', 'anne'),
    _Oge('اِبْن', 'ibn', 'oğul'), _Oge('بِنْت', 'bint', 'kız'),
    _Oge('اَخ', 'ah', 'kardeş'), _Oge('اُخْت', 'uht', 'kız kardeş'),
    _Oge('رَجُل', 'racül', 'adam'), _Oge('اِمْرَأَة', 'imrae', 'kadın'),
    _Oge('مَلِك', 'melik', 'hükümdar'), _Oge('عَبْد', 'abd', 'kul'),
    _Oge('رَسُول', 'resûl', 'elçi'), _Oge('نَبِيّ', 'nebî', 'peygamber'),
    _Oge('صَلَاة', 'salât', 'namaz'), _Oge('صَوْم', 'savm', 'oruç'),
    _Oge('زَكَاة', 'zekât', 'zekât'), _Oge('حَجّ', 'hacc', 'hac'),
    _Oge('دِين', 'dîn', 'din'), _Oge('اِيمَان', 'îmân', 'iman'),
    _Oge('قَلْب', 'kalb', 'kalp'), _Oge('رُوح', 'rûh', 'ruh'),
    _Oge('عَيْن', 'ayn', 'göz'), _Oge('اُذُن', 'üzün', 'kulak'),
    _Oge('لِسَان', 'lisân', 'dil'), _Oge('رَأْس', 're\'s', 'baş'),
    _Oge('جَنَّة', 'cennet', 'cennet'), _Oge('نَعِيم', 'naîm', 'nimet'),
    _Oge('حَقّ', 'hakk', 'gerçek, hak'), _Oge('خَيْر', 'hayr', 'iyilik'),
    _Oge('صِدْق', 'sıdk', 'doğruluk'), _Oge('صَبْر', 'sabr', 'sabır'),
    _Oge('عَدْل', 'adl', 'adalet'), _Oge('رَحْمَة', 'rahmet', 'merhamet'),
    _Oge('سَلَام', 'selâm', 'barış, esenlik'), _Oge('مَحَبَّة', 'mahabbe', 'sevgi'),
    _Oge('اَمَل', 'emel', 'umut'), _Oge('حِكْمَة', 'hikmet', 'hikmet'),
  ]),
  _Ders('11. Ders — İbareler', 'Artık uzun ibareleri okuyabilirsin. Sık kullanılan mübarek sözler:', 1, [
    _Oge('بِسْمِ اللّٰهِ', 'bismillâh', 'Allah\'ın adıyla'),
    _Oge('بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيمِ', 'bismillâhirrahmânirrahîm', 'Rahmân ve Rahîm olan Allah\'ın adıyla'),
    _Oge('اَلْحَمْدُ لِلّٰهِ', 'elhamdülillâh', 'Hamd Allah\'a mahsustur'),
    _Oge('اَلْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ', 'elhamdülillâhi rabbil âlemîn', 'Hamd, âlemlerin Rabbi Allah\'a mahsustur'),
    _Oge('سُبْحَانَ اللّٰهِ', 'sübhânallâh', 'Allah\'ı tesbih ederim'),
    _Oge('اَللّٰهُ اَكْبَرُ', 'Allâhü ekber', 'Allah en büyüktür'),
    _Oge('لَا إِلٰهَ إِلَّا اللّٰهُ', 'lâ ilâhe illallâh', 'Allah\'tan başka ilah yoktur'),
    _Oge('مُحَمَّدٌ رَسُولُ اللّٰهِ', 'muhammedün resûlullâh', 'Muhammed Allah\'ın elçisidir'),
    _Oge('اَسْتَغْفِرُ اللّٰهَ', 'estağfirullâh', 'Allah\'tan bağışlanma dilerim'),
    _Oge('سُبْحَانَ اللّٰهِ وَبِحَمْدِهِ', 'sübhânallâhi ve bihamdih', 'Allah\'ı hamd ile tesbih ederim'),
    _Oge('لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ', 'lâ havle velâ kuvvete illâ billâh', 'Güç ve kuvvet ancak Allah\'tandır'),
    _Oge('اِنَّا لِلّٰهِ وَاِنَّا اِلَيْهِ رَاجِعُونَ', 'innâ lillâhi ve innâ ileyhi râciûn', 'Biz Allah\'a aitiz ve O\'na döneceğiz'),
    _Oge('مَا شَاءَ اللّٰهُ', 'mâşâallâh', 'Allah ne güzel dilemiş'),
    _Oge('اِنْ شَاءَ اللّٰهُ', 'inşâallâh', 'Allah dilerse'),
    _Oge('بَارَكَ اللّٰهُ', 'bârekallâh', 'Allah bereket versin'),
    _Oge('جَزَاكَ اللّٰهُ خَيْرًا', 'cezâkallâhü hayrâ', 'Allah seni hayırla mükâfatlandırsın'),
    _Oge('اَللّٰهُمَّ صَلِّ عَلٰى مُحَمَّدٍ', 'Allâhümme salli alâ muhammed', 'Allah\'ım, Muhammed\'e salât et'),
    _Oge('اَلسَّلَامُ عَلَيْكُمْ', 'esselâmü aleyküm', 'Selâm üzerinize olsun'),
    _Oge('وَعَلَيْكُمُ السَّلَامُ', 've aleykümüsselâm', 'Selâm sizin de üzerinize olsun'),
    _Oge('رَضِيَ اللّٰهُ عَنْهُ', 'radıyallâhü anh', 'Allah ondan razı olsun'),
  ]),
  _Ders('12. Ders — Kısa Cümleler', 'Kelimeleri birleştirip kısa, anlamlı cümleler oku:', 1, [
    _Oge('اَللّٰهُ رَبِّي', 'Allâhü rabbî', 'Allah benim Rabbimdir'),
    _Oge('اَللّٰهُ نُورُ السَّمَاوَاتِ', 'Allâhü nûrus-semâvât', 'Allah göklerin nurudur'),
    _Oge('اَلْحَقُّ مِنْ رَبِّكَ', 'el-hakku min rabbike', 'Gerçek, Rabbindendir'),
    _Oge('اِنَّ اللّٰهَ غَفُورٌ رَحِيمٌ', 'innallâhe ğafûrun rahîm', 'Şüphesiz Allah bağışlayan, merhamet edendir'),
    _Oge('اَللّٰهُ مَعَ الصَّابِرِينَ', 'Allâhü meas-sâbirîn', 'Allah sabredenlerle beraberdir'),
    _Oge('رَبِّ زِدْنِي عِلْمًا', 'rabbi zidnî ilmâ', 'Rabbim, ilmimi artır'),
    _Oge('اَلْجَنَّةُ تَحْتَ الْاَقْدَامِ', 'el-cennetü tahtel-akdâm', 'Cennet ayakların altındadır'),
    _Oge('اِنَّ مَعَ الْعُسْرِ يُسْرًا', 'inne meal-usri yüsrâ', 'Şüphesiz her zorlukla beraber bir kolaylık vardır'),
    _Oge('اَللّٰهُ خَالِقُ كُلِّ شَيْءٍ', 'Allâhü hâliku külli şey\'', 'Allah her şeyin yaratıcısıdır'),
    _Oge('اَلْعِلْمُ نُورٌ', 'el-ilmü nûr', 'İlim bir nurdur'),
    _Oge('اَلصَّبْرُ مِفْتَاحُ الْفَرَجِ', 'es-sabru miftâhul-ferec', 'Sabır, ferahlığın anahtarıdır'),
    _Oge('اَلنَّظَافَةُ مِنَ الْاِيمَانِ', 'en-nezâfetü minel-îmân', 'Temizlik imandandır'),
    _Oge('اَلْجَنَّةُ دَارُ السَّلَامِ', 'el-cennetü dârüs-selâm', 'Cennet esenlik yurdudur'),
    _Oge('اَلدُّنْيَا دَارُ الْاِمْتِحَانِ', 'ed-dünyâ dârül-imtihân', 'Dünya bir imtihan yurdudur'),
    _Oge('خَيْرُ النَّاسِ أَنْفَعُهُمْ', 'hayrun-nâsi enfeuhüm', 'İnsanların en hayırlısı en faydalı olanıdır'),
    _Oge('اَلْمُؤْمِنُ لِلْمُؤْمِنِ كَالْبُنْيَانِ', 'el-mü\'minü lil-mü\'mini kel-bünyân', 'Mü\'min mü\'mine bir bina gibidir'),
    _Oge('اَلْكَلِمَةُ الطَّيِّبَةُ صَدَقَةٌ', 'el-kelimetüt-tayyibetü sadaka', 'Güzel söz bir sadakadır'),
    _Oge('اَلْوَقْتُ كَالسَّيْفِ', 'el-vaktü kes-seyf', 'Vakit kılıç gibidir'),
  ]),
  _Ders('13. Ders — Kur\'an\'dan Kısa Ayetler', 'Öğrendiklerinle Kur\'an\'dan kısa ayetleri oku:', 1, [
    _Oge('قُلْ هُوَ اللّٰهُ اَحَدٌ', 'kul hüvallâhü ehad', '"De ki: O Allah birdir." (İhlâs 1)'),
    _Oge('اَللّٰهُ الصَّمَدُ', 'Allâhüs-samed', '"Allah Samed\'dir (hiçbir şeye muhtaç değildir)." (İhlâs 2)'),
    _Oge('اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِينُ', 'iyyâke na\'büdü ve iyyâke nesteîn', '"Yalnız sana kulluk eder, yalnız senden yardım dileriz." (Fâtiha 5)'),
    _Oge('اِهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', 'ihdinas-sırâtal-müstakîm', '"Bizi doğru yola ilet." (Fâtiha 6)'),
    _Oge('وَاللّٰهُ خَيْرُ الرَّازِقِينَ', 'vallâhü hayrur-râzikîn', '"Allah rızık verenlerin en hayırlısıdır." (Cuma 11)'),
    _Oge('فَاذْكُرُونِي اَذْكُرْكُمْ', 'fezkürûnî ezkürküm', '"Beni anın ki ben de sizi anayım." (Bakara 152)'),
    _Oge('اِنَّ اللّٰهَ مَعَ الصَّابِرِينَ', 'innallâhe meas-sâbirîn', '"Şüphesiz Allah sabredenlerle beraberdir." (Bakara 153)'),
    _Oge('وَبَشِّرِ الصَّابِرِينَ', 've beşşiris-sâbirîn', '"Sabredenleri müjdele." (Bakara 155)'),
    _Oge('اَللّٰهُ لَا اِلٰهَ اِلَّا هُوَ', 'Allâhü lâ ilâhe illâ hû', '"Allah, kendisinden başka ilah olmayandır." (Bakara 255)'),
    _Oge('لَا اِكْرَاهَ فِي الدِّينِ', 'lâ ikrâhe fid-dîn', '"Dinde zorlama yoktur." (Bakara 256)'),
    _Oge('اِنَّ الدِّينَ عِنْدَ اللّٰهِ الْاِسْلَامُ', 'inned-dîne indallâhil-islâm', '"Allah katında din İslam\'dır." (Âl-i İmrân 19)'),
    _Oge('فَاعْفُ عَنْهُمْ', 'fa\'fü anhüm', '"Onları affet." (Âl-i İmrân 159)'),
    _Oge('اِنَّ اللّٰهَ عَلٰى كُلِّ شَيْءٍ قَدِيرٌ', 'innallâhe alâ külli şey\'in kadîr', '"Allah her şeye kadirdir." (Bakara 20)'),
    _Oge('وَاللّٰهُ غَفُورٌ رَحِيمٌ', 'vallâhü ğafûrun rahîm', '"Allah bağışlayan, merhamet edendir." (Bakara 218)'),
    _Oge('اَلَا بِذِكْرِ اللّٰهِ تَطْمَئِنُّ الْقُلُوبُ', 'elâ bizikrillâhi tatmeinnül-kulûb', '"Kalpler ancak Allah\'ı anmakla huzur bulur." (Ra\'d 28)'),
    _Oge('وَقُلْ رَبِّ زِدْنِي عِلْمًا', 've kul rabbi zidnî ilmâ', '"De ki: Rabbim, ilmimi artır." (Tâhâ 114)'),
    _Oge('اِنَّ مَعَ الْعُسْرِ يُسْرًا', 'inne meal-usri yüsrâ', '"Şüphesiz her zorlukla beraber bir kolaylık vardır." (İnşirah 6)'),
  ]),
  _Ders('14. Ders — Esmâ-ül Hüsnâ', 'Allah\'ın güzel isimlerinden bazılarını oku ve anlamını öğren:', 1, [
    _Oge('اَلرَّحْمٰنُ', 'er-Rahmân', 'Rahmeti sonsuz olan'),
    _Oge('اَلرَّحِيمُ', 'er-Rahîm', 'Çok merhamet eden'),
    _Oge('اَلْمَلِكُ', 'el-Melik', 'Mülkün gerçek sahibi'),
    _Oge('اَلْقُدُّوسُ', 'el-Kuddûs', 'Her türlü eksiklikten uzak'),
    _Oge('اَلسَّلَامُ', 'es-Selâm', 'Esenlik veren'),
    _Oge('اَلْغَفُورُ', 'el-Ğafûr', 'Çok bağışlayan'),
    _Oge('اَلْوَدُودُ', 'el-Vedûd', 'Çok seven, çok sevilen'),
    _Oge('اَلْحَكِيمُ', 'el-Hakîm', 'Her işi hikmetli olan'),
    _Oge('اَلْكَرِيمُ', 'el-Kerîm', 'Çok cömert olan'),
    _Oge('اَلنُّورُ', 'en-Nûr', 'Nur olan, aydınlatan'),
    _Oge('اَلْعَزِيزُ', 'el-Azîz', 'Mutlak güç ve izzet sahibi'),
    _Oge('اَلْجَبَّارُ', 'el-Cebbâr', 'İradesini her şeye geçiren'),
    _Oge('اَلْخَالِقُ', 'el-Hâlik', 'Yaratan'),
    _Oge('اَلْبَارِئُ', 'el-Bârî', 'Kusursuzca var eden'),
    _Oge('اَلْمُصَوِّرُ', 'el-Musavvir', 'Şekil ve suret veren'),
    _Oge('اَلْوَهَّابُ', 'el-Vehhâb', 'Karşılıksız çokça veren'),
    _Oge('اَلرَّزَّاقُ', 'er-Rezzâk', 'Rızık veren'),
    _Oge('اَلْفَتَّاحُ', 'el-Fettâh', 'Hayır kapılarını açan'),
    _Oge('اَلْعَلِيمُ', 'el-Alîm', 'Her şeyi bilen'),
    _Oge('اَلسَّمِيعُ', 'es-Semî', 'Her şeyi işiten'),
    _Oge('اَلْبَصِيرُ', 'el-Basîr', 'Her şeyi gören'),
    _Oge('اَلْحَكَمُ', 'el-Hakem', 'Mutlak hüküm veren'),
    _Oge('اَلْعَدْلُ', 'el-Adl', 'Mutlak adalet sahibi'),
    _Oge('اَللَّطِيفُ', 'el-Latîf', 'En ince işleri bilen, lütfeden'),
    _Oge('اَلْخَبِيرُ', 'el-Habîr', 'Her şeyden haberdar olan'),
    _Oge('اَلْحَلِيمُ', 'el-Halîm', 'Acele etmeyen, yumuşak davranan'),
    _Oge('اَلْعَظِيمُ', 'el-Azîm', 'Pek yüce olan'),
    _Oge('اَلشَّكُورُ', 'eş-Şekûr', 'Az amele çok mükâfat veren'),
    _Oge('اَلْعَلِيُّ', 'el-Aliyy', 'Yüceler yücesi'),
    _Oge('اَلْحَفِيظُ', 'el-Hafîz', 'Her şeyi koruyan'),
    _Oge('اَلْمُجِيبُ', 'el-Mucîb', 'Dualara cevap veren'),
    _Oge('اَلْوَاسِعُ', 'el-Vâsi', 'İlmi ve rahmeti geniş olan'),
    _Oge('اَلْمَجِيدُ', 'el-Mecîd', 'Şanı yüce ve cömert olan'),
    _Oge('اَلْحَقُّ', 'el-Hakk', 'Varlığı gerçek olan'),
    _Oge('اَلْوَكِيلُ', 'el-Vekîl', 'Kendisine güvenilen, işleri yürüten'),
    _Oge('اَلْمَتِينُ', 'el-Metîn', 'Çok güçlü, sağlam'),
    _Oge('اَلْوَلِيُّ', 'el-Veliyy', 'Dost ve yardımcı'),
    _Oge('اَلْحَمِيدُ', 'el-Hamîd', 'Her türlü övgüye layık'),
  ]),
  _Ders('15. Ders — Dua Cümleleri', 'Günlük hayatta okuyabileceğin kısa dua cümleleri:', 1, [
    _Oge('رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً', 'rabbenâ âtinâ fid-dünyâ haseneh', 'Rabbimiz, bize dünyada iyilik ver'),
    _Oge('رَبِّ اشْرَحْ لِي صَدْرِي', 'rabbişrah lî sadrî', 'Rabbim, gönlümü genişlet'),
    _Oge('رَبِّ اغْفِرْ لِي', 'rabbiğfir lî', 'Rabbim, beni bağışla'),
    _Oge('حَسْبُنَا اللّٰهُ وَنِعْمَ الْوَكِيلُ', 'hasbünallâhü ve ni\'mel vekîl', 'Allah bize yeter, O ne güzel vekildir'),
    _Oge('رَبَّنَا تَقَبَّلْ مِنَّا', 'rabbenâ tekabbel minnâ', 'Rabbimiz, bizden kabul buyur'),
    _Oge('اَللّٰهُمَّ اهْدِنِي', 'Allâhümmehdinî', 'Allah\'ım, bana doğru yolu göster'),
    _Oge('رَبِّ يَسِّرْ وَلَا تُعَسِّرْ', 'rabbi yessir velâ tüassir', 'Rabbim, kolaylaştır, zorlaştırma'),
    _Oge('رَبِّ زِدْنِي عِلْمًا', 'rabbi zidnî ilmâ', 'Rabbim, ilmimi artır'),
    _Oge('رَبَّنَا لَا تُؤَاخِذْنَا', 'rabbenâ lâ tüâhıznâ', 'Rabbimiz, bizi sorumlu tutma (bağışla)'),
    _Oge('اَللّٰهُمَّ عَافِنِي', 'Allâhümme âfinî', 'Allah\'ım, bana afiyet ver'),
    _Oge('اَللّٰهُمَّ اغْفِرْ لِي', 'Allâhümmeğfir lî', 'Allah\'ım, beni bağışla'),
    _Oge('رَبِّ ارْحَمْهُمَا', 'rabbirhamhümâ', 'Rabbim, (anne-babama) merhamet et'),
    _Oge('اَللّٰهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ', 'Allâhümme innî es\'elükel-cenneh', 'Allah\'ım, senden cenneti isterim'),
    _Oge('اَللّٰهُمَّ أَجِرْنِي مِنَ النَّارِ', 'Allâhümme ecirnî minen-nâr', 'Allah\'ım, beni ateşten koru'),
    _Oge('رَبَّنَا هَبْ لَنَا', 'rabbenâ heb lenâ', 'Rabbimiz, bize bağışla'),
    _Oge('اَللّٰهُمَّ بَارِكْ لَنَا', 'Allâhümme bârik lenâ', 'Allah\'ım, bize bereket ver'),
    _Oge('رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ', 'rabbi evzı\'nî en eşküre', 'Rabbim, şükretmemi ilham et'),
    _Oge('اَللّٰهُمَّ اجْعَلْنِي شَكُورًا', 'Allâhümmec\'alnî şekûrâ', 'Allah\'ım, beni çok şükreden kıl'),
    _Oge('رَبِّ نَجِّنِي', 'rabbi neccinî', 'Rabbim, beni kurtar'),
    _Oge('حَسْبِيَ اللّٰهُ', 'hasbiyallâh', 'Allah bana yeter'),
  ]),
];

class ElifbaScreen extends StatelessWidget {
  const ElifbaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Arapça Okuma · Elifba')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Text('Sıfırdan Arapça okumayı öğren. Dersleri sırayla çalış; her derste harfleri sesli tekrarla.',
              style: GoogleFonts.lora(fontSize: 12.5, height: 1.45, color: QC.greenMid)),
          const SizedBox(height: 14),
          ..._dersler.asMap().entries.map((e) => _dersTile(context, e.key)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _dersTile(BuildContext context, int i) {
    final d = _dersler[i];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QC.greenPale.withAlpha(160)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  center: Alignment(-0.3, -0.4), colors: [QC.goldLight, QC.gold])),
          child: Center(
              child: Text('${i + 1}',
                  style: GoogleFonts.lora(
                      fontSize: 17, fontWeight: FontWeight.w800, color: QC.greenDark))),
        ),
        title: Text(d.baslik,
            style: GoogleFonts.lora(
                fontSize: 14.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
        subtitle: Text('${d.ogeler.length} öğe',
            style: GoogleFonts.lora(fontSize: 11.5, color: QC.greenMid)),
        trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => ElifbaDersScreen(index: i))),
      ),
    );
  }
}

class ElifbaDersScreen extends StatefulWidget {
  final int index;
  const ElifbaDersScreen({super.key, required this.index});
  @override
  State<ElifbaDersScreen> createState() => _ElifbaDersScreenState();
}

class _ElifbaDersScreenState extends State<ElifbaDersScreen> {
  late int _i = widget.index;

  @override
  Widget build(BuildContext context) {
    final d = _dersler[_i];
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: Text('Ders ${_i + 1}/${_dersler.length}')),
      body: Column(children: [
        Container(
          width: double.infinity,
          color: QC.greenMain.withAlpha(26),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.baslik,
                style: GoogleFonts.lora(
                    fontSize: 16, fontWeight: FontWeight.w800, color: QC.greenDark)),
            const SizedBox(height: 4),
            Text(d.aciklama,
                style: GoogleFonts.lora(fontSize: 12.5, height: 1.45, color: QC.greenMid)),
          ]),
        ),
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.all(14),
            crossAxisCount: d.sutun,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: d.sutun >= 4
                ? 0.82
                : d.sutun == 3
                    ? 1.0
                    : (d.sutun == 2 ? 1.7 : 3.4),
            children: d.ogeler.map(_ogeCard).toList(),
          ),
        ),
        _navBar(),
      ]),
    );
  }

  Widget _ogeCard(_Oge o) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QC.greenPale.withAlpha(160)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: FittedBox(
              child: Text(o.ar,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                      fontFamily: 'AmiriQuran', fontSize: 34, height: 1.6, color: QC.greenDark)),
            ),
          ),
        ),
        Container(height: 1, width: 26, color: QC.greenPale.withAlpha(120)),
        const SizedBox(height: 10),
        Text(o.oku,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
                fontSize: 13.5, fontWeight: FontWeight.w700, color: QC.greenMain)),
        if (o.anlam != null) ...[
          const SizedBox(height: 2),
          Text(o.anlam!,
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(fontSize: 11.5, color: QC.greenMid)),
        ],
      ]),
    );
  }

  Widget _navBar() {
    final hasPrev = _i > 0;
    final hasNext = _i < _dersler.length - 1;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
        child: Row(children: [
          if (hasPrev)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _i--),
                icon: const Icon(Icons.chevron_left_rounded),
                label: const Text('Önceki ders'),
              ),
            ),
          if (hasPrev && hasNext) const SizedBox(width: 12),
          if (hasNext)
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: QC.greenMain, foregroundColor: Color(0xFFFAF7F0)),
                onPressed: () => setState(() => _i++),
                icon: const Icon(Icons.chevron_right_rounded),
                label: const Text('Sonraki ders'),
              ),
            ),
        ]),
      ),
    );
  }
}
