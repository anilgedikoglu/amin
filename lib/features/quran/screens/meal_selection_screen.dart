// Meal (çeviri) seçimi — birden çok meal seçilebilir; ayet detayında
// karşılaştırmalı gösterilir. En az bir meal seçili kalır.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/meal_registry.dart';
import '../data/quran_prefs.dart';
import '../quran_theme.dart';

class MealSelectionScreen extends StatefulWidget {
  const MealSelectionScreen({super.key});
  @override
  State<MealSelectionScreen> createState() => _MealSelectionScreenState();
}

class _MealSelectionScreenState extends State<MealSelectionScreen> {
  final _prefs = QuranPrefs.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Meal Seçimi", style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
          const Text("Birden fazla seçip karşılaştırabilirsiniz",
              style: TextStyle(fontSize: 10, color: QC.greenPale)),
        ]),
      ),
      body: AnimatedBuilder(
        animation: _prefs,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            children: [
              ...kMeals.map((m) {
                final sel = _prefs.isMealSelected(m.id);
                return GestureDetector(
                  onTap: () => _prefs.toggleMeal(m.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: sel ? QC.greenMain : Color(0xFFFAF7F0),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? QC.gold : QC.greenPale, width: 1.4),
                    ),
                    child: Row(children: [
                      Icon(sel ? Icons.check_circle_rounded : Icons.circle_outlined,
                          color: sel ? QC.goldLight : QC.greenMid, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(m.name,
                              style: GoogleFonts.lora(
                                  fontSize: 15, fontWeight: FontWeight.w700,
                                  color: sel ? Color(0xFFFAF7F0) : QC.greenDark)),
                          const SizedBox(height: 2),
                          Text(m.author,
                              style: TextStyle(
                                  fontSize: 11.5,
                                  color: sel ? QC.greenPale : QC.greenMid)),
                          const SizedBox(height: 2),
                          Text(m.license,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                  color: sel ? QC.greenPale.withAlpha(180) : QC.greenMid.withAlpha(160))),
                        ]),
                      ),
                    ]),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: QC.gold.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: QC.gold.withAlpha(90))),
                child: Text(
                    "Lisans notu: Mealler fawazahmed0/Tanzil kaynaklıdır. Tanzil tabanlı mealler gayri-ticari lisanslı olabilir; reklamlı/ticari yayında ilgili hak sahibinden izin gerekebilir. Edip Yüksel sürümü MIT (serbest).",
                    style: GoogleFonts.lora(
                        fontSize: 11.5, height: 1.6, color: QC.brownDark)),
              ),
            ],
          );
        },
      ),
    );
  }
}
