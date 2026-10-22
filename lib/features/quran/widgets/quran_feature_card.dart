// Ana ekrana eklenen "Kur'an-ı Kerim" kartı.
// Amin'in doğal bir bölümü gibi durur; ayrı uygulama hissi vermez.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran_theme.dart';
import '../screens/quran_home_screen.dart';

class QuranFeatureCard extends StatelessWidget {
  const QuranFeatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const QuranHomeScreen())),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [QC.greenMain, QC.greenDark],
          ),
          border: Border.all(color: QC.gold.withAlpha(140), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(60), blurRadius: 14, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                  colors: [QC.goldLight, QC.gold], center: Alignment(-0.3, -0.3)),
              boxShadow: [BoxShadow(color: QC.gold.withAlpha(90), blurRadius: 14, spreadRadius: 2)],
            ),
            child: const Center(child: Text("📖", style: TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("القرآن الكريم",
                  style: const TextStyle(
                      fontFamily: QC.arabicFont, fontSize: 20, color: QC.goldLight)),
              const SizedBox(height: 2),
              Text("Kur'an-ı Kerim",
                  style: GoogleFonts.lora(
                      fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFFFAF7F0))),
              const SizedBox(height: 3),
              const Text("Oku · Meal · Tilavet dinle · Favoriler",
                  style: TextStyle(fontSize: 10.5, color: QC.greenPale, letterSpacing: .3)),
            ]),
          ),
          const Icon(Icons.chevron_right, color: QC.goldLight),
        ]),
      ),
    );
  }
}
