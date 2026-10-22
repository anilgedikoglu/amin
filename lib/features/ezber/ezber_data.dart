// Ezber bölümü — namazda ve günlük hayatta en çok ezberlenmesi gereken dualar.
// Her dua: Arapça + okunuş (latin) + Türkçe anlam + kategori.

class EzberDua {
  final String id;
  final String ad;
  final String kategori; // "Namaz Duaları", "Kısa Sureler", "Günlük"
  final String arabic;
  final String latin;
  final String turkish;
  const EzberDua({
    required this.id,
    required this.ad,
    required this.kategori,
    required this.arabic,
    required this.latin,
    required this.turkish,
  });
}

const List<EzberDua> kEzberDualari = [
  EzberDua(
    id: 'subhaneke',
    ad: 'Sübhâneke',
    kategori: 'Namaz Duaları',
    arabic: 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَى جَدُّكَ وَلَا إِلَهَ غَيْرُكَ',
    latin:
        'Sübhânekellâhümme ve bi-hamdik ve tebârekesmük ve teâlâ ceddük ve lâ ilâhe ğayruk.',
    turkish:
        'Allah\'ım! Sen her türlü eksiklikten uzaksın. Seni hamdinle tesbih ederim. Senin adın mübarektir, şânın yücedir. Senden başka ilah yoktur.',
  ),
  EzberDua(
    id: 'ettehiyyatu',
    ad: 'Ettehiyyâtü',
    kategori: 'Namaz Duaları',
    arabic:
        'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ السَّلَامُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
    latin:
        'Ettehiyyâtü lillâhi vessalevâtü vettayyibât. Esselâmü aleyke eyyühen-nebiyyü ve rahmetullâhi ve berekâtüh. Esselâmü aleynâ ve alâ ibâdillâhis-sâlihîn. Eşhedü en lâ ilâhe illallâh ve eşhedü enne Muhammeden abdühû ve rasûlüh.',
    turkish:
        'Dil ile, beden ve mal ile yapılan bütün ibadetler Allah\'a dır. Ey Peygamber! Allah\'ın selâmı, rahmeti ve bereketi senin üzerine olsun. Selâm bizim ve Allah\'ın sâlih kullarının üzerine olsun. Şahitlik ederim ki Allah\'tan başka ilah yoktur ve yine şahitlik ederim ki Muhammed O\'nun kulu ve elçisidir.',
  ),
  EzberDua(
    id: 'salli',
    ad: 'Allâhümme Salli',
    kategori: 'Namaz Duaları',
    arabic:
        'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
    latin:
        'Allâhümme salli alâ Muhammedin ve alâ âli Muhammed. Kemâ salleyte alâ İbrâhîme ve alâ âli İbrâhîm. İnneke hamîdün mecîd.',
    turkish:
        'Allah\'ım! Muhammed\'e ve Muhammed\'in âline (ümmetine) rahmet eyle; İbrahim\'e ve İbrahim\'in âline rahmet eylediğin gibi. Şüphesiz Sen övülmeye lâyıksın, şanın yücedir.',
  ),
  EzberDua(
    id: 'barik',
    ad: 'Allâhümme Bârik',
    kategori: 'Namaz Duaları',
    arabic:
        'اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ',
    latin:
        'Allâhümme bârik alâ Muhammedin ve alâ âli Muhammed. Kemâ bârekte alâ İbrâhîme ve alâ âli İbrâhîm. İnneke hamîdün mecîd.',
    turkish:
        'Allah\'ım! Muhammed\'e ve Muhammed\'in âline bereket ver; İbrahim\'e ve İbrahim\'in âline bereket verdiğin gibi. Şüphesiz Sen övülmeye lâyıksın, şanın yücedir.',
  ),
  EzberDua(
    id: 'rabbena_atina',
    ad: 'Rabbenâ Âtinâ',
    kategori: 'Namaz Duaları',
    arabic:
        'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
    latin:
        'Rabbenâ âtinâ fid-dünyâ haseneten ve fil-âhirati haseneten ve kınâ azâben-nâr.',
    turkish:
        'Rabbimiz! Bize dünyada da iyilik ver, ahirette de iyilik ver ve bizi ateş azabından koru.',
  ),
  EzberDua(
    id: 'rabbenagfirli',
    ad: 'Rabbenâğfirlî',
    kategori: 'Namaz Duaları',
    arabic:
        'رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
    latin: 'Rabbenâğfirlî ve li-vâlideyye ve lil-mü\'minîne yevme yekûmül-hisâb.',
    turkish:
        'Rabbimiz! Hesabın görüleceği günde beni, anne-babamı ve mü\'minleri bağışla.',
  ),
  EzberDua(
    id: 'kunut1',
    ad: 'Kunut Duası 1',
    kategori: 'Namaz Duaları',
    arabic:
        'اللَّهُمَّ إِنَّا نَسْتَعِينُكَ وَنَسْتَغْفِرُكَ وَنَسْتَهْدِيكَ وَنُؤْمِنُ بِكَ وَنَتُوبُ إِلَيْكَ وَنَتَوَكَّلُ عَلَيْكَ',
    latin:
        'Allâhümme innâ nesteînüke ve nestağfirüke ve nestehdîke ve nü\'minü bike ve netûbü ileyke ve netevekkelü aleyke...',
    turkish:
        'Allah\'ım! Senden yardım isteriz, günahlarımızı bağışlamanı isteriz, bizi doğru yola iletmeni isteriz. Sana inanır, Sana tövbe ederiz. Sana güvenir, dayanırız.',
  ),
  EzberDua(
    id: 'kunut2',
    ad: 'Kunut Duası 2',
    kategori: 'Namaz Duaları',
    arabic:
        'اللَّهُمَّ إِيَّاكَ نَعْبُدُ وَلَكَ نُصَلِّي وَنَسْجُدُ وَإِلَيْكَ نَسْعَى وَنَحْفِدُ نَرْجُو رَحْمَتَكَ وَنَخْشَى عَذَابَكَ إِنَّ عَذَابَكَ بِالْكُفَّارِ مُلْحِقٌ',
    latin:
        'Allâhümme iyyâke na\'büdü ve leke nüsallî ve nescüdü ve ileyke nes\'â ve nahfid. Nercû rahmeteke ve nahşâ azâbeke. İnne azâbeke bil-küffâri mülhik.',
    turkish:
        'Allah\'ım! Yalnız Sana kulluk ederiz. Namazı yalnız Senin için kılarız, ancak Sana secde ederiz. Sana koşar ve Sana yaklaştıracak şeyleri kazanmaya çalışırız. Rahmetini umar, azabından korkarız. Şüphesiz Senin azabın kâfirlere ulaşır.',
  ),
  EzberDua(
    id: 'fatiha',
    ad: 'Fâtiha Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ الرَّحْمَٰنِ الرَّحِيمِ مَالِكِ يَوْمِ الدِّينِ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
    latin:
        'Bismillâhirrahmânirrahîm. Elhamdü lillâhi rabbil-âlemîn. Errahmânirrahîm. Mâliki yevmiddîn. İyyâke na\'büdü ve iyyâke nestaîn. İhdinas-sırâtal-müstakîm. Sırâtallezîne en\'amte aleyhim ğayril-mağdûbi aleyhim ve laddâllîn.',
    turkish:
        'Rahmân ve Rahîm olan Allah\'ın adıyla. Hamd, âlemlerin Rabbi Allah\'a mahsustur. O Rahmân\'dır, Rahîm\'dir. Din gününün sahibidir. Yalnız Sana ibadet eder, yalnız Senden yardım dileriz. Bizi doğru yola ilet; nimet verdiklerinin yoluna; gazaba uğrayanların ve sapkınların yoluna değil.',
  ),
  EzberDua(
    id: 'ihlas',
    ad: 'İhlâs Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'قُلْ هُوَ اللَّهُ أَحَدٌ اللَّهُ الصَّمَدُ لَمْ يَلِدْ وَلَمْ يُولَدْ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ',
    latin:
        'Kul hüvallâhü ehad. Allâhüssamed. Lem yelid ve lem yûled. Ve lem yekün lehû küfüven ehad.',
    turkish:
        'De ki: O Allah birdir. Allah Samed\'dir (her şey O\'na muhtaç, O hiçbir şeye muhtaç değildir). O doğurmamış ve doğmamıştır. Hiçbir şey O\'na denk değildir.',
  ),
  EzberDua(
    id: 'felak',
    ad: 'Felak Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ مِنْ شَرِّ مَا خَلَقَ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
    latin:
        'Kul eûzü bi-rabbil-felak. Min şerri mâ halak. Ve min şerri ğâsikın izâ vekab. Ve min şerrin-neffâsâti fil-ukad. Ve min şerri hâsidin izâ hased.',
    turkish:
        'De ki: Sığınırım sabahın Rabbine. Yarattığı şeylerin şerrinden. Karanlığı çöktüğünde gecenin şerrinden. Düğümlere üfleyenlerin şerrinden. Ve haset ettiğinde hasetçinin şerrinden.',
  ),
  EzberDua(
    id: 'nas',
    ad: 'Nâs Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ النَّاسِ مَلِكِ النَّاسِ إِلَهِ النَّاسِ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ مِنَ الْجِنَّةِ وَالنَّاسِ',
    latin:
        'Kul eûzü bi-rabbin-nâs. Melikin-nâs. İlâhin-nâs. Min şerril-vesvâsil-hannâs. Ellezî yüvesvisü fî sudûrin-nâs. Minel-cinneti ven-nâs.',
    turkish:
        'De ki: Sığınırım insanların Rabbine. İnsanların Melikine (mutlak hükümdarına). İnsanların İlahına. O sinsi vesvesecinin şerrinden. O ki insanların göğüslerine vesvese verir. Gerek cinlerden gerek insanlardan.',
  ),
  EzberDua(
    id: 'kevser',
    ad: 'Kevser Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ فَصَلِّ لِرَبِّكَ وَانْحَرْ إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ',
    latin: 'İnnâ a\'taynâkel-kevser. Fesalli li-rabbike venhar. İnne şânieke hüvel-ebter.',
    turkish:
        'Şüphesiz biz sana Kevser\'i verdik. O hâlde Rabbin için namaz kıl ve kurban kes. Asıl soyu kesik olan, sana kin besleyendir.',
  ),
  EzberDua(
    id: 'fil',
    ad: 'Fil Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'أَلَمْ تَرَ كَيْفَ فَعَلَ رَبُّكَ بِأَصْحَابِ الْفِيلِ أَلَمْ يَجْعَلْ كَيْدَهُمْ فِي تَضْلِيلٍ وَأَرْسَلَ عَلَيْهِمْ طَيْرًا أَبَابِيلَ تَرْمِيهِمْ بِحِجَارَةٍ مِنْ سِجِّيلٍ فَجَعَلَهُمْ كَعَصْفٍ مَأْكُولٍ',
    latin:
        'Elem tera keyfe feale rabbüke bi-ashâbil fîl. Elem yec\'al keydehüm fî tadlîl. Ve ersele aleyhim tayran ebâbîl. Termîhim bi-hicâratin min siccîl. Fecealehüm keasfin me\'kûl.',
    turkish:
        'Rabbinin fil sahiplerine ne yaptığını görmedin mi? Onların tuzaklarını boşa çıkarmadı mı? Üzerlerine sürü sürü kuşlar gönderdi. Onlara pişmiş çamurdan taşlar atıyorlardı. Böylece onları yenilip çiğnenmiş ekin gibi yaptı.',
  ),
  EzberDua(
    id: 'nasr',
    ad: 'Nasr Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ إِنَّهُ كَانَ تَوَّابًا',
    latin:
        'İzâ câe nasrullâhi vel-feth. Ve raeyten-nâse yedhulûne fî dînillâhi efvâcâ. Fesebbih bi-hamdi rabbike vestağfirh. İnnehû kâne tevvâbâ.',
    turkish:
        'Allah\'ın yardımı ve fetih geldiğinde ve insanların bölük bölük Allah\'ın dinine girdiğini gördüğünde, Rabbini hamd ile tesbih et ve O\'ndan bağışlanma dile. Şüphesiz O, tövbeleri çok kabul edendir.',
  ),
  EzberDua(
    id: 'asr',
    ad: 'Asr Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'وَالْعَصْرِ إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ',
    latin:
        'Vel-asr. İnnel-insâne lefî husr. İllellezîne âmenû ve amilüs-sâlihâti ve tevâsav bil-hakkı ve tevâsav bis-sabr.',
    turkish:
        'Asra yemin olsun ki, insan gerçekten ziyandadır. Ancak iman edenler, sâlih ameller işleyenler, birbirlerine hakkı ve sabrı tavsiye edenler bunun dışındadır.',
  ),
  EzberDua(
    id: 'ayetelkursi',
    ad: 'Âyetü\'l-Kürsî',
    kategori: 'Faziletli Dualar',
    arabic:
        'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ',
    latin:
        'Allâhü lâ ilâhe illâ hüvel-hayyül-kayyûm. Lâ te\'huzühû sinetün ve lâ nevm. Lehû mâ fis-semâvâti ve mâ fil-ard. Men zellezî yeşfeu indehû illâ bi-iznih. Ya\'lemü mâ beyne eydîhim ve mâ halfehüm. Ve lâ yühîtûne bi-şey\'in min ilmihî illâ bimâ şâ\'. Vesia kürsiyyühüs-semâvâti vel-ard. Ve lâ yeûdühû hıfzuhümâ ve hüvel-aliyyül-azîm.',
    turkish:
        'Allah, kendisinden başka hiçbir ilah bulunmayandır. O, diridir, her şeyi ayakta tutandır. O\'nu ne bir uyuklama ne de uyku tutar. Göklerde ve yerde ne varsa hepsi O\'nundur. İzni olmadan O\'nun katında kim şefaat edebilir? O, kullarının önlerindekini ve arkalarındakini bilir. Onlar O\'nun ilminden, O\'nun dilediği kadarından başka bir şey kavrayamazlar. O\'nun kürsüsü gökleri ve yeri kaplamıştır. Onları koruyup gözetmek O\'na ağır gelmez. O, yücedir, büyüktür.',
  ),
  EzberDua(
    id: 'salatitefriciye',
    ad: 'Salât-ı Tefrîciye',
    kategori: 'Faziletli Dualar',
    arabic:
        'اللَّهُمَّ صَلِّ صَلَاةً كَامِلَةً وَسَلِّمْ سَلَامًا تَامًّا عَلَى سَيِّدِنَا مُحَمَّدٍ الَّذِي تَنْحَلُّ بِهِ الْعُقَدُ وَتَنْفَرِجُ بِهِ الْكُرَبُ وَتُقْضَى بِهِ الْحَوَائِجُ',
    latin:
        'Allâhümme salli salâten kâmileten ve sellim selâmen tâmmen alâ seyyidinâ Muhammedin, ellezî tenhallü bihil-ukadü, ve tenfericü bihil-kürebü, ve tükdâ bihil-havâic.',
    turkish:
        'Allah\'ım! Kendisi hürmetine düğümlerin çözüldüğü, sıkıntıların açıldığı ve ihtiyaçların giderildiği Efendimiz Muhammed\'e kâmil bir salât ve tam bir selâm eyle.',
  ),
  EzberDua(
    id: 'amentu',
    ad: 'Âmentü',
    kategori: 'Temel',
    arabic:
        'آمَنْتُ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الْآخِرِ وَبِالْقَدَرِ خَيْرِهِ وَشَرِّهِ مِنَ اللَّهِ تَعَالَى وَالْبَعْثُ بَعْدَ الْمَوْتِ حَقٌّ',
    latin:
        'Âmentü billâhi ve melâiketihî ve kütübihî ve rusulihî vel-yevmil-âhiri ve bil-kaderi hayrihî ve şerrihî minallâhi teâlâ vel-ba\'sü ba\'del-mevti hakkun. Eşhedü en lâ ilâhe illallâh ve eşhedü enne Muhammeden abdühû ve rasûlüh.',
    turkish:
        'Allah\'a, meleklerine, kitaplarına, peygamberlerine, ahiret gününe; kadere, hayrın ve şerrin Allah\'tan olduğuna inandım. Öldükten sonra dirilmek haktır. Şahitlik ederim ki Allah\'tan başka ilah yoktur ve Muhammed O\'nun kulu ve elçisidir.',
  ),
  EzberDua(
    id: 'kafirun',
    ad: 'Kâfirûn Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'قُلْ يَا أَيُّهَا الْكَافِرُونَ لَا أَعْبُدُ مَا تَعْبُدُونَ وَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ وَلَا أَنَا عَابِدٌ مَا عَبَدْتُمْ وَلَا أَنْتُمْ عَابِدُونَ مَا أَعْبُدُ لَكُمْ دِينُكُمْ وَلِيَ دِينِ',
    latin:
        'Kul yâ eyyühel-kâfirûn. Lâ a\'büdü mâ ta\'büdûn. Ve lâ entüm âbidûne mâ a\'büd. Ve lâ ene âbidün mâ abedtüm. Ve lâ entüm âbidûne mâ a\'büd. Leküm dînüküm ve liye dîn.',
    turkish:
        'De ki: Ey kâfirler! Ben sizin taptıklarınıza tapmam. Siz de benim taptığıma tapmazsınız. Ben sizin taptıklarınıza tapacak değilim. Siz de benim taptığıma tapacak değilsiniz. Sizin dininiz size, benim dinim banadır.',
  ),
  EzberDua(
    id: 'maun',
    ad: 'Mâûn Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'أَرَأَيْتَ الَّذِي يُكَذِّبُ بِالدِّينِ فَذَٰلِكَ الَّذِي يَدُعُّ الْيَتِيمَ وَلَا يَحُضُّ عَلَىٰ طَعَامِ الْمِسْكِينِ فَوَيْلٌ لِلْمُصَلِّينَ الَّذِينَ هُمْ عَنْ صَلَاتِهِمْ سَاهُونَ الَّذِينَ هُمْ يُرَاءُونَ وَيَمْنَعُونَ الْمَاعُونَ',
    latin:
        'Eraeytellezî yükezzibü bid-dîn. Fezâlikellezî yedu\'ul-yetîm. Ve lâ yehuddu alâ taâmil-miskîn. Feveylün lil-musallîn. Ellezîne hüm an salâtihim sâhûn. Ellezîne hüm yürâûne ve yemneûnel-mâûn.',
    turkish:
        'Dini yalanlayanı gördün mü? İşte o, yetimi itip kakan, yoksulu doyurmaya teşvik etmeyen kimsedir. Yazıklar olsun o namaz kılanlara ki, onlar namazlarından gafildirler. Onlar gösteriş yaparlar ve hayra da engel olurlar.',
  ),
  EzberDua(
    id: 'kureys',
    ad: 'Kureyş Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'لِإِيلَافِ قُرَيْشٍ إِيلَافِهِمْ رِحْلَةَ الشِّتَاءِ وَالصَّيْفِ فَلْيَعْبُدُوا رَبَّ هَٰذَا الْبَيْتِ الَّذِي أَطْعَمَهُمْ مِنْ جُوعٍ وَآمَنَهُمْ مِنْ خَوْفٍ',
    latin:
        'Li-îlâfi Kureyş. Îlâfihim rihleteş-şitâi ves-sayf. Felya\'büdû rabbe hâzel-beyt. Ellezî at\'amehüm min cûin ve âmenehüm min havf.',
    turkish:
        'Kureyş\'i alıştırdığı için; onları kış ve yaz yolculuğuna alıştırdığı için, onlar bu evin (Kâbe\'nin) Rabbine kulluk etsinler. O ki onları açlıktan doyurdu ve korkudan emin kıldı.',
  ),
  EzberDua(
    id: 'mesed',
    ad: 'Mesed (Tebbet) Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ مَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ سَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ فِي جِيدِهَا حَبْلٌ مِنْ مَسَدٍ',
    latin:
        'Tebbet yedâ ebî lehebin ve tebb. Mâ ağnâ anhü mâlühû ve mâ keseb. Seyaslâ nâran zâte leheb. Vemraetühû hammâletel-hatab. Fî cîdihâ hablün min mesed.',
    turkish:
        'Ebû Leheb\'in elleri kurusun; kurudu da! Malı ve kazandıkları ona fayda vermedi. O, alevli bir ateşe girecektir. Karısı da odun taşıyıcısı olarak. Boynunda bükülmüş bir ip olacaktır.',
  ),
  EzberDua(
    id: 'zilzal',
    ad: 'Zilzâl Sûresi',
    kategori: 'Kısa Sureler',
    arabic:
        'إِذَا زُلْزِلَتِ الْأَرْضُ زِلْزَالَهَا وَأَخْرَجَتِ الْأَرْضُ أَثْقَالَهَا وَقَالَ الْإِنْسَانُ مَا لَهَا يَوْمَئِذٍ تُحَدِّثُ أَخْبَارَهَا بِأَنَّ رَبَّكَ أَوْحَىٰ لَهَا',
    latin:
        'İzâ zülziletil-ardu zilzâlehâ. Ve ahracetil-ardu eskâlehâ. Ve kâlel-insânü mâ lehâ. Yevmeizin tühaddisü ahbârahâ. Bienne rabbeke evhâ lehâ.',
    turkish:
        'Yer o şiddetli sarsıntısıyla sarsıldığında, yer ağırlıklarını dışarı çıkardığında ve insan "Ona ne oluyor?" dediğinde; işte o gün yer, Rabbinin ona vahyetmesiyle bütün haberlerini anlatır.',
  ),
  EzberDua(
    id: 'yemek_sonrasi',
    ad: 'Yemekten Sonra Dua',
    kategori: 'Günlük',
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِينَ',
    latin: 'Elhamdü lillâhillezî at\'amenâ ve sekânâ ve cealenâ minel-müslimîn.',
    turkish:
        'Bizi yediren, içiren ve Müslümanlardan kılan Allah\'a hamd olsun.',
  ),
  EzberDua(
    id: 'uyku_duasi',
    ad: 'Uyumadan Önce Dua',
    kategori: 'Günlük',
    arabic: 'اللَّهُمَّ بِاسْمِكَ أَمُوتُ وَأَحْيَا',
    latin: 'Allâhümme bismike emûtü ve ahyâ.',
    turkish: 'Allah\'ım! Senin adınla ölür ve Senin adınla dirilirim.',
  ),
  EzberDua(
    id: 'rabbi_yessir',
    ad: 'Rabbi Yessir',
    kategori: 'Günlük',
    arabic: 'رَبِّ يَسِّرْ وَلَا تُعَسِّرْ رَبِّ تَمِّمْ بِالْخَيْرِ',
    latin: 'Rabbi yessir ve lâ tüassir. Rabbi temmim bil-hayr.',
    turkish:
        'Rabbim! Kolaylaştır, zorlaştırma. Rabbim! Hayırla tamamla.',
  ),
  EzberDua(
    id: 'hasbunallah',
    ad: 'Hasbünallâh',
    kategori: 'Faziletli Dualar',
    arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ نِعْمَ الْمَوْلَى وَنِعْمَ النَّصِيرُ',
    latin: 'Hasbünallâhü ve ni\'mel-vekîl. Ni\'mel-mevlâ ve ni\'men-nasîr.',
    turkish:
        'Allah bize yeter, O ne güzel vekildir. O ne güzel dost ve ne güzel yardımcıdır.',
  ),
  EzberDua(
    id: 'istigfar',
    ad: 'Tövbe İstiğfar',
    kategori: 'Günlük',
    arabic:
        'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ الْحَيَّ الْقَيُّومَ وَأَتُوبُ إِلَيْهِ',
    latin:
        'Estağfirullâhel-azîm ellezî lâ ilâhe illâ hüvel-hayyel-kayyûme ve etûbü ileyh.',
    turkish:
        'Kendisinden başka ilah olmayan, diri ve her şeyi ayakta tutan yüce Allah\'tan bağışlanma diler ve O\'na tövbe ederim.',
  ),
];
