// Ayarlar — Değerlendir/Paylaş + Hakkında/koşullar.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';
import '../rating/rating_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _baslik('DESTEK'),
          const SizedBox(height: 10),
          _tile(Icons.star_rounded, 'Uygulamayı Değerlendir',
              '5 yıldız ver, yorum yaz — çok kişiye ulaşsın', () {
            RatingService.magazadaDegerlendir();
          }),
          const SizedBox(height: 10),
          _tile(Icons.ios_share_rounded, 'Arkadaşlarınla Paylaş',
              'Uygulama bağlantısını paylaş', () {
            RatingService.paylas();
          }),
          const SizedBox(height: 24),
          _baslik('BİLGİ'),
          const SizedBox(height: 10),
          _tile(Icons.info_outline_rounded, 'Hakkında & Kullanım Koşulları',
              'Yasal bilgiler, kaynaklar ve telif notları', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HakkindaScreen()));
          }),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _baslik(String s) => Text(s,
      style: GoogleFonts.lora(
          fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w700, color: QC.gold));

  Widget _tile(IconData icon, String title, String sub, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: QC.greenPale.withAlpha(150))),
          child: Row(children: [
            Icon(icon, color: QC.greenMain),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: GoogleFonts.lora(
                        fontSize: 14.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
                const SizedBox(height: 2),
                Text(sub,
                    style: GoogleFonts.lora(fontSize: 12, color: QC.greenMid)),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: QC.gold),
          ]),
        ),
      ),
    );
  }
}

// ── Hakkında & Kullanım Koşulları ──
class HakkindaScreen extends StatelessWidget {
  const HakkindaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Hakkında')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _bolum('Amin Uygulaması', _kTanitim),
          _bolum('Kullanım Koşulları', _kKosullar),
          _bolum('Sorumluluk Reddi', _kSorumluluk),
          _bolum('İçerik ve Kaynaklar', _kKaynaklar),
          _bolum('Telif ve Fikrî Haklar', _kTelif),
          _bolum('Gizlilik', _kGizlilik),
          const SizedBox(height: 20),
          Center(
            child: Text('Bu uygulamayı kullanarak yukarıdaki koşulları\nkabul etmiş sayılırsınız.',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                    fontSize: 12, fontStyle: FontStyle.italic, color: QC.greenMid)),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _bolum(String baslik, String metin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QC.greenPale.withAlpha(150)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 16, color: QC.gold),
          const SizedBox(width: 8),
          Expanded(
            child: Text(baslik,
                style: GoogleFonts.lora(
                    fontSize: 15.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
          ),
        ]),
        const SizedBox(height: 10),
        Text(metin,
            style: GoogleFonts.lora(
                fontSize: 13.5, height: 1.7, color: const Color(0xFF374151))),
      ]),
    );
  }
}

const String _kTanitim =
    'Amin; dua, zikir, Kur\'an-ı Kerim, namaz öğretimi, ezber, dinî bilgi ve daha birçok özelliği bir araya getiren, çoğunlukla çevrimdışı çalışan bir İslami rehber uygulamasıdır. Amaç; ibadet ve öğrenmeyi kolaylaştıran, reklamla desteklenen ücretsiz bir araç sunmaktır.';

const String _kKosullar =
    '1. Bu uygulama "olduğu gibi" sunulur; kullanımı tamamen kullanıcının kendi sorumluluğundadır.\n\n'
    '2. Uygulamayı indirerek, açarak veya kullanarak bu koşulların tamamını kabul etmiş sayılırsınız. Koşulları kabul etmiyorsanız uygulamayı kullanmayınız.\n\n'
    '3. Uygulamadaki dinî bilgiler genel bilgilendirme amaçlıdır; bağlayıcı bir fetva veya resmî dinî görüş yerine geçmez. Şahsınıza özel dinî meselelerde ehil bir kaynağa (müftülük, ilim ehli) danışınız.\n\n'
    '4. Uygulama reklam içerir. Reklam içerikleri üçüncü taraf sağlayıcılar (ör. Google AdMob) tarafından sunulur ve bu içeriklerden uygulama geliştiricisi sorumlu değildir.';

const String _kSorumluluk =
    'Uygulamada yer alan metin, çeviri (meal), tarih, hesaplama (namaz vakti, kıble, dinî günler) ve diğer bilgilerin doğruluğu için azami özen gösterilmiştir; ancak hata, eksiklik veya güncellik farkı bulunabilir. Bu bilgilere dayanılarak yapılan işlemlerden doğabilecek doğrudan veya dolaylı zararlardan geliştirici sorumlu tutulamaz. Namaz vakti ve kıble gibi hassas konularda yerel resmî kaynakların (Diyanet vb.) esas alınması tavsiye edilir.';

const String _kKaynaklar =
    'Kur\'an-ı Kerim meâlleri kamuya açık/serbest kaynaklardan derlenmiştir (varsayılan: Diyanet İşleri meâli). Hadis, esmâ, dua ve dinî bilgi içerikleri klasik ve genel kabul görmüş kaynaklardan sadeleştirilerek hazırlanmıştır. Kutsal metinler bölümündeki İslam dışı metinler kamu malı (public domain) kaynaklardan alınmış ya da bunlardan özgün olarak Türkçeye çevrilmiştir. Namaz vakti hesapları açık kaynak kütüphaneler kullanılarak yapılır.';

const String _kTelif =
    'Uygulamanın özgün tasarımı, düzeni, derlenmiş içerikleri ve yazılımı fikrî mülkiyet kapsamındadır ve izinsiz çoğaltılamaz, dağıtılamaz veya ticari amaçla kullanılamaz. Üçüncü taraflara ait içerikler ilgili sahiplerinin haklarına tabidir. Bir içeriğin hak ihlali oluşturduğunu düşünüyorsanız, uygulamanın destek kanalı üzerinden bildirebilirsiniz; geçerli bildirimler değerlendirilerek gerekli düzeltmeler yapılır.';

const String _kGizlilik =
    'Uygulama, temel tercihlerinizi (seçili meal, favoriler, ilerleme vb.) yalnızca cihazınızda saklar. Bu veriler sunucuya gönderilmez. Reklam sağlayıcıları kendi gizlilik politikaları çerçevesinde cihaz tanımlayıcıları kullanabilir; ayrıntılar için ilgili sağlayıcının (Google AdMob) gizlilik politikasına bakınız. Detaylı gizlilik politikası uygulamanın web sayfasında yayımlanır.';
