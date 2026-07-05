// Kaynaklar / lisans ekranı. Apple ve kullanıcı şeffaflığı için
// metin ve ses kaynaklarını açıkça belirtir.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran_theme.dart';

class QuranSourcesScreen extends StatelessWidget {
  const QuranSourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text("Kaynaklar & Lisans",
            style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: const [
          _Section(
            title: "Kur'an-ı Kerim Metni",
            body:
                "Arapça metin, Medine Mushafı (Uthmani / Hafs rivayeti) imlasıyla "
                "uygulamaya gömülüdür. İnternet bağlantısı olmadan çevrimdışı okunabilir.",
          ),
          _Section(
            title: "Türkçe Meal",
            body:
                "Diyanet İşleri Başkanlığı Türkçe meali esas alınmıştır. "
                "Meal, ayetlerin Türkçe anlamını yansıtır; ibadette esas olan Arapça asıldır.",
          ),
          _Section(
            title: "Sesli Tilavet",
            body:
                "Tilavet kayıtları EveryAyah arşivinden çevrimiçi olarak akıtılır. "
                "Varsayılan kâri: Mishary Râşid el-Afâsî. Dilerseniz sureyi cihazınıza "
                "indirip çevrimdışı dinleyebilirsiniz.",
          ),
          _Section(
            title: "Önemli Not",
            body:
                "Bu bölüm dini bilgilendirme amaçlıdır. Meal ve tilavet tercihleri "
                "ehil kaynaklardan derlenmiştir. Hata fark ederseniz lütfen bize bildirin.",
          ),
          SizedBox(height: 10),
          Center(
            child: Text("Allah doğru söyleyenlerle beraberdir.",
                style: TextStyle(
                    fontStyle: FontStyle.italic, color: QC.greenMain, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QC.greenPale, width: 1.2),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: GoogleFonts.lora(
                fontSize: 15, fontWeight: FontWeight.w700, color: QC.greenDark)),
        const SizedBox(height: 8),
        Text(body,
            style: GoogleFonts.lora(fontSize: 13, height: 1.7, color: const Color(0xFF374151))),
      ]),
    );
  }
}
