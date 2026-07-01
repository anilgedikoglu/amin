# Amin — AGENTS.md

İslami dua ve zikir sayacı Flutter uygulaması.

## Teknik Yapı

- **Tek dosya mimarisi:** tüm kod `lib/main.dart` içinde
- **Flutter SDK:** `^3.7.2` (Dart), build makinede `stable` kullanılır
- **Paketler:** `google_mobile_ads ^5.1.0`, `shared_preferences`, `google_fonts`, `flutter_launcher_icons`
- **Kotlin:** `2.1.0` (`android/settings.gradle.kts`) — `webview_flutter_android 4.12.0` için zorunlu

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

### Reklam Mantığı

Dua TAMAMLANDI durumunda "Yeniden Başla" veya geri tuşuna basılınca:
- Her **2.** tıkta → geçiş reklamı
- Her **6.** tıkta → ödüllü reklam (6, 12, 18… — 2'nin katı olsa da rewarded öncelikli)

Sayaç: `AdManager.instance._completionTapCount` (singleton, session boyunca birikir)

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
- **Sürüm:** `1.0.2+3` (`pubspec.yaml`)
- **Web repo:** `github.com/futurastictech/futurastictech.github.io`
- **Uygulama repo:** `github.com/anilgedikoglu/amin`
