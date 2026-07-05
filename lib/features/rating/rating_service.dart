// Puanlama/yorum teşviki: her 50 tıkta bir "beğendin mi?" pop-up'ı.
// Yıldıza dokununca mağazanın değerlendirme sayfası açılır; ayrıca paylaşım.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../quran/quran_theme.dart';

class RatingService {
  static const String _appStoreId = '6779628851';
  static const String _androidPkg = 'com.amin.amin';
  static const String _iosUrl = 'https://apps.apple.com/app/id$_appStoreId';
  static const String _androidUrl =
      'https://play.google.com/store/apps/details?id=$_androidPkg';

  static String get storeUrl => Platform.isIOS ? _iosUrl : _androidUrl;

  static bool _dialogAcik = false; // aynı anda iki pop-up olmasın

  /// Kullanıcı değerlendirdiyse artık pop-up gösterme.
  static Future<bool> _degerlendirildi() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool('review_done') ?? false;
  }

  static Future<void> _isaretle() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('review_done', true);
  }

  /// Mağaza değerlendirme akışını aç (native sheet varsa onu, yoksa mağaza sayfası).
  static Future<void> magazadaDegerlendir() async {
    final inApp = InAppReview.instance;
    try {
      if (await inApp.isAvailable()) {
        await inApp.requestReview();
      }
      // Native sheet her zaman görünmeyebilir; mağaza sayfasını da aç ki
      // yorum kısmına ulaşabilsin.
      await inApp.openStoreListing(appStoreId: _appStoreId);
    } catch (_) {}
    await _isaretle();
  }

  static Future<void> paylas() async {
    await Share.share(
      'Amin — dua, zikir, Kur\'an ve daha fazlası bir arada! Sen de indir:\n$storeUrl',
      subject: 'Amin uygulaması',
    );
  }

  /// Pop-up'ı gösterebilecek durumda mı kontrol edip gösterir.
  static Future<void> gosterEgerUygun(BuildContext context) async {
    if (_dialogAcik) return;
    if (await _degerlendirildi()) return;
    if (!context.mounted) return;
    _dialogAcik = true;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _RatingDialog(),
    );
    _dialogAcik = false;
  }
}

class _RatingDialog extends StatefulWidget {
  const _RatingDialog();
  @override
  State<_RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<_RatingDialog> {
  int _hover = 0; // dokunulan yıldız sayısı (animasyon için)

  Future<void> _degerlendir(int yildiz) async {
    setState(() => _hover = yildiz);
    // Kısa bir görsel geri bildirim, sonra mağazayı aç.
    await Future.delayed(const Duration(milliseconds: 250));
    if (mounted) Navigator.of(context).pop();
    await RatingService.magazadaDegerlendir();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFFAF7F0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  center: Alignment(-0.3, -0.3), colors: [QC.goldLight, QC.gold]),
            ),
            child: const Icon(Icons.favorite_rounded, color: Color(0xFFFAF7F0), size: 34),
          ),
          const SizedBox(height: 16),
          Text('Amin\'i beğendin mi?',
              style: GoogleFonts.lora(
                  fontSize: 19, fontWeight: FontWeight.w800, color: QC.greenDark)),
          const SizedBox(height: 8),
          Text(
              'Desteğin bize çok değerli. 5 yıldız verip birkaç kelime yorum bırakmak, '
              'uygulamanın daha çok kişiye ulaşmasını sağlar. 🤲',
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                  fontSize: 13.5, height: 1.6, color: const Color(0xFF4b5563))),
          const SizedBox(height: 18),
          // 5 yıldız — herhangi birine dokunmak mağaza değerlendirmesini açar.
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 1; i <= 5; i++)
              GestureDetector(
                onTap: () => _degerlendir(i),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    i <= _hover ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 40,
                    color: QC.gold,
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 20),
          // Değerlendir + Paylaş
          Row(children: [
            Expanded(
              child: Material(
                color: QC.greenMain,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _degerlendir(5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.rate_review_rounded, color: Color(0xFFFAF7F0), size: 18),
                      const SizedBox(width: 7),
                      Text('Değerlendir',
                          style: GoogleFonts.lora(
                              fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFFAF7F0))),
                    ]),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: QC.gold.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).pop();
                  RatingService.paylas();
                },
                child: const Padding(
                  padding: EdgeInsets.all(13),
                  child: Icon(Icons.ios_share_rounded, color: QC.gold, size: 20),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Şimdi değil',
                style: GoogleFonts.lora(fontSize: 12.5, color: QC.greenMid)),
          ),
        ]),
      ),
    );
  }
}
