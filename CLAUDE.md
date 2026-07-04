# Amin — CLAUDE.md

İslami dua ve zikir sayacı Flutter uygulaması.

## Teknik Yapı

- **Mimari:** Çekirdek (dua/zikir) tek dosya `lib/main.dart`; Kur'an özelliği ayrı modül `lib/features/quran/`
- **Flutter SDK:** `^3.7.2` (Dart), build makinede `stable` kullanılır
- **Paketler:** `google_mobile_ads ^5.1.0`, `shared_preferences`, `google_fonts`, `flutter_launcher_icons`, `just_audio ^0.9.40`, `http ^1.2.0`, `path_provider ^2.1.4`
- **Kotlin:** `2.1.0` (`android/settings.gradle.kts`) — `webview_flutter_android 4.12.0` için zorunlu
- **Fontlar GÖMÜLÜ (offline):** `assets/google_fonts/` (Lora Regular/Medium/Bold + Amiri Regular/Bold) ve `assets/fonts/AmiriQuran-Regular.ttf`. `main()` içinde `GoogleFonts.config.allowRuntimeFetching = false` → CDN'den indirme yok, internetsiz çökme/kasma yok. Yeni GoogleFonts ağırlığı eklersen ilgili TTF'i `assets/google_fonts/`'a `Lora-<Variant>.ttf` adıyla ekle.

## Özellikler (v2 — Tam İslami Uygulama)

Apple 4.2 reddi sonrası uygulama tam kapsamlı bir İslami uygulamaya dönüştürüldü. Tüm özellikler offline çalışır (ses tilaveti + günün ayeti hariç).

| Özellik | Modül | Veri / Paket |
|---|---|---|
| Kur'an-ı Kerim (oku/**çoklu meal**/**okunuş**/tilavet/favori/son okunan) | `features/quran/` | `assets/quran/quran.json` (Arapça+okunuş) + `assets/quran/trans/*.json` (12 meal) |
| Namaz Hocası (adım adım namaz: 11 pozisyon görseli + dualar) | `features/namaz_hocasi/` | `assets/namaz_hocasi/*.png` (kullanıcı sağladı) + gömülü dua metinleri |
| Namaz Vakitleri (2026-2036, şehir seçimli, geri sayım) | `features/prayer/` | `adhan` paketi + `assets/data/cities.json` (81 il + dünya) |
| Kıble Pusulası (pusula + Kâbe yönü) | `features/qibla/` | `flutter_qiblah` (geolocator + flutter_compass_v2) |
| Dini Günler (yıl yıl kandil/bayram) | `features/calendar/` | `hijri` paketi (Hicri→Miladi tarama) |
| Esmâ-ül Hüsnâ (99 isim + anlam + açıklama) | `features/esma/` | `assets/data/esma.json` (Allah + 99 isim) |
| Hadis & Özlü Sözler (~300, kaynağa göre gruplu: Buhârî/Müslim/Tirmizî… + arama) | `features/sozler/` | `assets/data/sozler.json` (224 hadis + 80 söz) |
| Dini Sorular (1000 popüler soru-cevap, 20 kategori + arama) | `features/sorular/dini_sorular.dart` | `assets/data/dini_sorular.json` (kullanıcının xlsx'inden, `{k,s,c,d}`). Kategori→soru; dokun→cevap sheet (kısa cevap+açıklama); okununca tik (`soru_read` prefs). |
| Delil & İman Hakikatleri (Deliller/Mucizeler/Cevaplar/Sözler + **Risale-i Nur**) | `features/delil/` + `features/risale/` | `delil` app'inden komple kopyalandı (lib/data ~10MB Dart). Sekme geçişi YOK: `DelilHomeScreen(initialTab)` tek bölüm + AppBar geri tuşu. Ana menüde 5 büyük yatay buton. Tema amin yeşil/altın (`AppColors` remap). **Risale-i Nur Külliyatı**: `assets/risale/` 15 kitap 298 bölüm ~13MB tam metin (alitekdemir/Risale-i-Nur-Diyanet) + `lugatce.json` (~230 terim sade açıklama). Reader: kitap→bölüm→metin + **Lügatçe paneli** (bölümde geçen zor kelimeler); tüm külliyatta konu araması (ilk aramada tüm kitaplar lazy yüklenir). **TELİF:** kullanıcı sorumluluğunu üstlendi. |
| Kutsal Metinler (çok-dinli okuyucu + **hepsinde birden arama**) | `features/kutsal/` | `assets/sacred/*.json` — **TAMAMI TÜRKÇE**: Kur'an (İslam, TR Diyanet), Tao Te Ching (Taoizm), Dhammapada (Budizm). Tao/Dhammapada = kamu malı İngilizceden (Legge/Müller) **kendi çevirimiz** (`lang:tr`). İncil/Tevrat/Gita/Analektler ÇIKARILDI (telifli TR yok / kaynak belirsiz). |
| Ezber (kademeli açma + aralıklı tekrar) | `features/ezber/` | **30 dua** (`ezber_data.dart`: namaz duaları + kısa sureler + Kâfirûn/Mâûn/Kureyş/Mesed/Zilzâl + günlük dualar). **Mekanik:** önce tam metin → "Ezbere Başla" → ilk kelime → her "Devam"da bir kelime açılır (`_started`/`_revealed`); **açılan kelimenin Arapçası kırmızı parıltıyla vurgulanır** (`_arabicHighlighted`). **"Tekrar gerek" çıkmaz, ilk kelimeden yeniden başlatır** (`_restart`). Bitince Bildim/Tekrar → spaced repetition (`_araGun`, prefs `ezber_lv_*`/`ezber_due_*`). |
| Din Felsefesi (Teoloji, aranabilir) | `features/teoloji/` | 14 derlenmiş kelam/din felsefesi konusu (`teoloji_screen.dart` gömülü); kategorili + arama + detay sheet |
| Yeni Müslüman rehberi | `features/yeni_musluman/` | Adım adım Müslüman olma + hikmetleri, iman/İslam'ın şartları, haramlar (nedenleriyle); ExpansionTile bölümler |
| Sosyal (kutlama + paylaşılabilir görsel) | `features/sosyal/` | 10 dini gün için kutlama mesajları (`sosyal_data.dart`); mesajı tasarımlı karta çevirip `RepaintBoundary→PNG→share_plus` ile sosyal medyada paylaşır. **`share_plus ^7.2.2` eklendi** (clean gerektirdi: GeneratedPluginRegistrant stale → `flutter clean`) |
| Arapça Okuma (Elifba) | `features/elifba/` | **15 ders** gömülü (`elifba_screen.dart`): harfler → yazılış → hareke → cezm/şedde/tenvin/med → **kelimeler (~60)** → **ibareler (~20)** → kısa cümleler → Kur'an ayetleri → Esmâ-ül Hüsnâ → dua cümleleri; Türkçe anlamlı; AmiriQuran fontu. Arapça-okunuş arası boşluk düzeltildi (`_ogeCard`). |
| **Bilgi Yarışması** | `features/quiz/` | `quiz_data.dart` (`kQuizBank`, zorluk 0/1/2) + `quiz_screen.dart`. Her tur `_pickRound()` = 3 kolay+3 orta+4 çok zor rastgele. 10sn geri sayım; süre biterse yanlış+doğru gösterilir, 3sn sonra sonraki. Sonuç X/10 + istatistik (prefs `quiz_played/total_q/correct/perfect`). |
| **Evlilikte Mahremiyet** | `features/evlilik/` | `evlilik_data.dart` (`kEvlilikSorular` {kategori,soru,cevap}) — İslami fıkha dayalı; helal/haram, gusül, karşılıklı haklar, edep, aile planlaması. Kategorili + arama + ExpansionTile. |
| **Arapça Sözlük** | `features/sozluk/` | `sozluk_data.dart` (`kSozluk` {arabic,okunus,turkce}). Türkçe↔Arapça çift yönlü; `_fold` TR-duyarsız + Arapça yazımdan da arar. |
| **Ayarlar** (Değerlendir/Paylaş + Hakkında/koşullar) | `features/settings/` | DESTEK (Değerlendir/Paylaş) + `HakkindaScreen`: kullanım koşulları/sorumluluk reddi/kaynaklar/telif/gizlilik. **ASLA kişisel ad/e-posta yok.** Ana ekran sağ üstte dişli ikonu. (Tema seçimi 1.7.1'de kaldırıldı.) |
| **Puanlama/Yorum daveti** (her 100 tıkta pop-up: 5 yıldız + değerlendir + paylaş) | `features/rating/` | `rating_service.dart` (`in_app_review` + `share_plus`). `AdManager.onTap` her 100. tıkta (reklam yerine) `RatingService.gosterEgerUygun` → yıldıza dokun → `magazadaDegerlendir()` (native sheet + `openStoreListing`, iOS App ID 6779628851 / Android `com.amin.amin`). `review_done` prefs ile bir daha gösterilmez. **`AdManager.pauseTaps`**: Bilgi Yarışması ekranındayken tıklamalar hiç sayılmaz (reklam/pop-up çıkmaz). Global `rootNavigatorKey` ile context'siz gösterim. Ayarlar'da "DESTEK" girişleri de var. |
| **Günlük içerik** (Günün Ayeti + Tarihte Bugün + Günün Kız/Erkek İsmi) | `features/gunluk/` | `gunluk_data.dart` (`kGununAyetleri`, `kTarihteBugun` MM-DD map, `kKizIsimleri`/`kErkekIsimleri` {isim,anlam}) + `gunluk_widgets.dart`. `dayOfYear`'a göre seçim; isme dokun→anlam dialog; `IsimlerScreen` aranabilir. Ana ekranda Günün Hadisi altında. |
| Günlük push + Namaz vakti + **10 yıllık dini gün kutlama** bildirimi | `features/notifications/` | `flutter_local_notifications` + `timezone` + `flutter_timezone` + `hijri`. `scheduleReligiousDays()`: 10 yılın kandil/bayramlarını hicri hesapla + kutlama mesajıyla planla (id base 3000, kanal `religious_days`, sabah 09:00). Açılışta sessizce (ayda bir tazelenir, `_kReligiousLast`). **iOS 64 bekleyen bildirim limiti** → `Platform.isIOS?60:200` cap. |

### Kutsal Metinler özelliği (`lib/features/kutsal/`)
- **7 metin (~39k ayet):** Kur'an (İslam), İncil (Hristiyanlık), Tevrat (Yahudilik, sanal), Bhagavad Gita (Hinduizm), Dhammapada (Budizm), Tao Te Ching (Taoizm), Analektler (Konfüçyüsçülük). Kur'an dışı hepsi İngilizce public domain.
- **Veri:** ortak format `{id,name,religion,lang,license,books:[{n,en?,c:[[ayet...]]}]}`. quran=Diyanet meali+surahs adları, bible=KJV (thiagobodruk/bible, Türkçe kitap adı map'i gömülü), gita=gita/gita repo (701 ayet tek İngilizce çevirmen), dhammapada/tao/analects=Gutenberg düz metinden parse (`scratchpad/parse_eastern.js` — Tao 81 bölüm üç formatı: "N. 1."/"N." şiir/"N. metin"). **Tevrat ayrı dosya DEĞİL** — registry'de `from:'bible', bookRange:[0,5]` ile sanal.
- **EKSİK 3 (10 hedefinden):** Avesta (Zerdüştlük), Guru Granth Sahib (Sihizm), Kojiki (Şinto) — temiz public-domain JSON YOK; sadece archive.org OCR taraması (dipnot/sayfa no/OCR gürültüsü) veya HTML uygulama. Kalite düşmesin diye eklenmedi; OCR'dan eklenebilir (kalite tradeoff).
- **Kayıt defteri:** `data/sacred_repository.dart` `kSacredRegistry`. Yeni metin = normalize + `assets/sacred/`'a koy + registry'ye 1 satır. compute() ile lazy parse + cache. **`hakkinda` alanı**: her metnin tarihçesi (nasıl/kime indi, kaç bölüm…). Okuyucuda kitap listesinin en üstünde açılır kart (`_HakkindaCard`).
- **Birleşik arama:** `search()` Türkçe-duyarsız `_fold` + **TR↔EN terim köprüsü** (`data/term_bridge.dart`: aşk→love…). Sonuç metne göre gruplu; dokun → ilgili ayet (`SacredReaderScreen.highlightVerse`).
- **Ekranlar:** `sacred_home_screen` (arama+kütüphane), `sacred_reader_screen` (kitap→bölüm→ayet, kademeli geri). Tema `QC`.
- **Genişletme:** Avesta/Guru Granth/Kojiki — temiz public-domain JSON YOK (sadece archive.org OCR taraması veya HTML); kaliteyi düşürmemek için eklenmedi. Eklenenler: Dhammapada/Tao/Analects (Gutenberg parse).

**Açılış (`SplashScreen`):** Uygulama açılışında besmele + HeroMedallion + AMİN + İMAN PORTALI + ArabesqueDivider yumuşak belirir (FadeTransition), ~2.3sn sonra `pushReplacement` ile fade geçişle HomeScreen'e. Branding artık burada; HomeScreen'de tekrar edilmez.

**Ana ekran (`main.dart` HomeScreen):** Branding splash'a taşındığı için menü en üstten başlar. **EN ÜSTTE sıradaki namaz/imsak banner'ı** (`NextPrayerBanner`), sonra `_MenuTile` kartlar: **Dua & Zikir** (→ `DuaZikirHubScreen`) + **Kur'an-ı Kerim** + **Kutsal Metinler** (YENİ) + **Namaz Hocası**. Altında **İBADET & ARAÇLAR** araç grid (Namaz, Kıble, Dini Günler, Esmâ, Hadis, Hatırlatma) + **DELİL** butonları + **Günün Hadisi** kartı. Column `crossAxisAlignment.stretch`, yukarıdan aşağı.

**Dua sayacı (`DuaScreen`, main.dart):** Dua kutusunda **yazı boyutu kontrolü** (sol üst A-/A+, `_fontScale` 1.0–2.0, kutu `SingleChildScrollView` olduğu için taşmaz). **5 sn dokunulmazsa** sayaç butonunun etrafında **nefes alan sarı ışık** bir döngü çalışır (`_breathCtrl`), 5 sn beklenir, tekrar eder; dokununca durur (`_startIdleWatch`/`_breathOnce`). `TickerProviderStateMixin` (iki controller).

**Namaz Hocası dualar:** `_OkumaCard` tıklanınca `NamazOkumaDetayScreen` (tam metin) açılır + **"Bu Duayı Ezberle"** → okumadan `EzberDua` üretip `EzberPracticeScreen`'e gider. Görsel arka planı görselin gerçek bej tonuna eşlendi (`0xFFBFAA97`→`0xFFE4D0BE`).

**Kur'an sure detay:** "Dinle" butonunun hemen altında pratik **meal (çevirmen) seçim butonu** (`_mealButton` → seçili meal adını gösterir, dokun → `MealSelectionScreen`; `_onPrefs` listener seçim değişince otomatik yeniden yükler).

### Çoklu Meal (çeviri) sistemi
- 12 Türkçe meal `assets/quran/trans/{id}.json` olarak ayrı dosyalarda; **seçime göre lazy** yüklenir (`QuranRepository.ensureMeals`). Açılışta sadece varsayılan (`diyanet`) yüklenir → hızlı.
- Kayıt defteri: `features/quran/data/meal_registry.dart` (id, ad, çevirmen, lisans). Seçim: `QuranPrefs.selectedMeals` (en az 1). Ekran: `MealSelectionScreen`.
- Birden çok meal seçilince ayet kartında **karşılaştırmalı** (her meal çevirmen etiketiyle) gösterilir. Arama seçili mealler içinde yapılır.
- Tefsir-temelli mealler: Muhammed Esed, İbn Kesir, Tefhim (gerçek paragraf-tefsir Türkçe free JSON olarak yok).
- **LİSANS:** Mealler fawazahmed0/Tanzil kaynaklı, çoğu **gayri-ticari**; reklamlı yayında izin gerekebilir. Edip Yüksel MIT. Uyarı meal seçim ekranında gösteriliyor.

**Vektör ikonlar:** `widgets/brand_icons.dart` — CrescentStarIcon, TasbihIcon, OpenBookIcon, DuaHandsIcon, HeroMedallion, ArabesqueDivider, GeometricBackdrop (hepsi CustomPainter).

**Şehir bazlı namaz:** GPS/izin YOK; kullanıcı şehir seçer. `cities.json`'da `utc` offset (TR=+3) ile şehir yerel saati hesaplanır.

### ÖNEMLİ — Performans (ANR önleme)
- **JSON parse:** Büyük asset'ler (`quran.json` 2.85MB) `compute()` ile arka plan isolate'inde parse edilir. ASLA main thread'de jsonDecode etme.
- **Namaz geri sayımı:** Vakitler bir kez hesaplanır (`PrayerService.nextPrayer`), her saniye sadece `remainingTo()` ile tıklar. Her saniye adhan hesaplama YAPMA.
- **Bildirim init:** `timezone` DB ağırdır; SADECE bildirim etkinse + açılıştan 3sn sonra yüklenir (`main()`). Açılışta yükleme = ANR.
- **AdMob:** `runApp`'tan SONRA, bloklamadan init edilir.

### Android native config
- `android/app/build.gradle.kts`: `isCoreLibraryDesugaringEnabled = true` + `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")` (bildirimler için). **`configurations.all { resolutionStrategy.force(...) }`**: `in_app_review` androidx.core/browser'ın AGP 8.9.1 isteyen çok yeni sürümlerini (1.17.0) çekiyordu → AGP 8.7 uyumlu `androidx.core:1.13.1` + `androidx.browser:1.8.0`'a sabitlendi.
- `AndroidManifest.xml`: POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED, SCHEDULE_EXACT_ALARM, USE_EXACT_ALARM + ScheduledNotification receiver'ları (bildirim); ACCESS_FINE/COARSE_LOCATION + compass feature (kıble)

### iOS native config
- `ios/Runner/Info.plist`: NSLocationWhenInUseUsageDescription + NSLocationAlwaysAndWhenInUseUsageDescription (kıble konumu)
- iOS ana ekran widget'ı YOK (kullanıcının Xcode'u yok; WidgetKit extension target gerektirir). Kaldırıldı — namaz/günün sözü uygulama içi + bildirimde sunuluyor.

## Kur'an-ı Kerim Özelliği (`lib/features/quran/`)

Apple Guideline 4.2 (minimum functionality) reddine karşı eklendi. Tam işlevsel Kur'an okuyucu.

- **Veri (offline, gömülü):** `assets/quran/quran.json` (2.4 MB — Arapça Uthmani/Hafs + Diyanet İşleri Türkçe meali, 6236 ayet) + `assets/quran/surahs.json` (114 sure metadata). İnternet GEREKTİRMEZ.
- **Ses:** EveryAyah'tan online stream (`just_audio`). Varsayılan kâri Mishary Alafasy (+ Husary, Abdulbasit, Minshawi). Sure offline indirilebilir (`path_provider` ile app dökümanlarına).
- **Modüller:** `models/`, `data/` (repository=asset yükleme+arama, prefs=favori/son okunan/font/toggle, audio_service), `screens/` (quran_home, surah_list, surah_detail, sources, favorites), `widgets/` (quran_feature_card, ayah_card, audio_player_bar).
- **Özellikler:** sure listesi, sure detay (Arapça+meal), ayet/sure tilavet, sure+meal arama, favori ayet, son okunan yer, font büyüt/küçült, Arapça/meal toggle, mini oynatıcı, offline indirme, kaynaklar ekranı.
- **Renk paleti:** `QC` sınıfı (`quran_theme.dart`) — ana uygulamanın `AC` paletini birebir korur.
- **Giriş noktası:** Ana ekranda (`HomeScreen`) "DUALARA DEVAM" altındaki `QuranFeatureCard` → `QuranHomeScreen`.
- **Veri üretim notu:** `quran.json` fawazahmed0/quran-api editions'tan (ara-quranuthmanihaf + tur-diyanetisleri) + quran.com chapters metadata birleştirilerek node script ile üretildi.

## Uygulama Kimlikleri

| Platform | Bundle ID |
|----------|-----------|
| Android  | `com.amin.amin` |
| iOS      | `com.futurastic.Amin` |

## AdMob

| | Android | iOS |
|---|---|---|
| App ID | `ca-app-pub-6470338276121414~2679139424` | `ca-app-pub-6470338276121414~8983952032` |
| Geçiş (Interstitial) | `ca-app-pub-6470338276121414/3936380770` | `ca-app-pub-6470338276121414/1633785489` |
| Ödüllü (Rewarded) | `ca-app-pub-6470338276121414/7877624629` | `ca-app-pub-6470338276121414/9147603563` |

**Kural:** Platform ID'lerini asla birbiriyle karıştırma. Elimde yoksa sor, tahmin etme.

### Reklam Mantığı (1.7.0+)

**Geçiş (interstitial): her 10 tıkta 1. Ödüllü (rewarded): SADECE tema değişiminde.**
- Uygulamada **nereye tıklanırsa tıklansın her 10. tıkta 1 geçiş reklamı** (`AdManager.instance.onTap()`, `_tapCount % 10 == 0`), `AminApp` `builder`'ında `Listener(onPointerDown)` ile beslenir.
- **Rewarded geri eklendi (1.7.0):** yalnızca Ayarlar'da tema değişiminde `AdManager.showRewarded(onDone)` — reklam kapanınca tema uygulanır. Reklam hazır değilse akış bloklanmaz.
- Reklam ID'leri **gerçek** (publisher `6470338276121414`, Google test `3940256099942544` DEĞİL).
- Eski tamamlanma-tabanlı (`onDuaCompletion`, `_completionTapCount`) mantık kaldırıldı.

### Arka Plan Teması — KALDIRILDI (1.7.1)
- Kullanıcı istemediği için tema seçimi Ayarlar'dan kaldırıldı. `AppBgTheme` (`quran_theme.dart`) hâlâ duruyor ama `notifier` daima 0 (Zümrüt Yeşil) — `main()`'deki `app_theme` yükleme satırı silindi.
- `QC.greenBg`/`AC.greenBg` hâlâ `get greenBg => AppBgTheme.bg` (const değil) → `const Scaffold(backgroundColor: greenBg)` derlenmez, non-const yap. `AdManager.showRewarded` kodu duruyor ama artık çağrılmıyor.

## Codemagic (iOS TestFlight)

- **Workflow:** `ios-testflight` (`codemagic.yaml`)
- **Tetikleyici:** `v*` tag push (`git tag v1.0.3 && git push origin v1.0.3`)
- **App Store Connect App ID:** `6779628851`
- **Apple Team ID:** `SN5Y726ZKF`
- **Integration:** `Codemagic` (magnus/matematikcik ile aynı, paylaşımlı)
- **Env group:** `signing_credentials` → `CERTIFICATE_PRIVATE_KEY` (RSA base64)
  - Kaynak: `C:\src\magnus_app\ios_certs\ios_distribution.key` → `openssl rsa -traditional` ile dönüştür
- `flutter config --no-enable-swift-package-manager` zorunlu (google_mobile_ads / CocoaPods uyumu)
- Build number: `$(date +%s)` (Unix timestamp — çakışma olmaz)

## Uygulama URL'leri

| | URL |
|---|---|
| Web | `https://futurastictech.github.io/amin/` |
| Destek | `https://futurastictech.github.io/amin/support.html` |
| Gizlilik | `https://futurastictech.github.io/amin/privacy-policy.html` |
| app-ads.txt | `https://futurastictech.github.io/app-ads.txt` |

## Önemli Notlar

- **Görseller** (link format tercihi): Linkleri her zaman kod bloğunda ver, markdown link formatı kullanma
- **iOS ikon:** `flutter_launcher_icons` ile üretildi — `ios: true`, `remove_alpha_ios: true`
- **iOS deployment target:** `13.0`
- **Android min SDK:** `21`
- **Sürüm:** `1.7.1+22` (`pubspec.yaml`) — codemagic.yaml `--build-name` de eşitle
- **Global tema:** `AminApp` MaterialApp'te uygulama geneli AppBar/divider/splash(altın ripple)/snackbar + Cupertino sayfa geçişleri tanımlı (tek noktadan tutarlılık).
- **Web repo:** `github.com/futurastictech/futurastictech.github.io`
- **Uygulama repo:** `github.com/anilgedikoglu/amin`
