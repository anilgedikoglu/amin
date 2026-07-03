// Namaz Hocası — adım adım namaz öğretimi.
// Kartlı PageView: pozisyon görseli + açıklama + o adımda okunan dualar.
// İleri/geri butonları ile gezinme. Görseller assets/namaz_hocasi/.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';
import '../ezber/ezber_data.dart';
import '../ezber/ezber_screen.dart';
import 'namaz_steps.dart';

class NamazHocasiScreen extends StatefulWidget {
  const NamazHocasiScreen({super.key});
  @override
  State<NamazHocasiScreen> createState() => _NamazHocasiScreenState();
}

class _NamazHocasiScreenState extends State<NamazHocasiScreen> {
  final _pc = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _go(int i) {
    if (i < 0 || i >= kNamazAdimlari.length) return;
    _pc.animateToPage(i,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final total = kNamazAdimlari.length;
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Namaz Hocası", style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
          Text("Adım ${_index + 1} / $total",
              style: const TextStyle(fontSize: 10.5, color: QC.greenPale)),
        ]),
      ),
      body: Column(children: [
        // İlerleme çubuğu
        LinearProgressIndicator(
          value: (_index + 1) / total,
          minHeight: 4,
          backgroundColor: QC.greenPale,
          valueColor: const AlwaysStoppedAnimation(QC.gold),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pc,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: total,
            itemBuilder: (ctx, i) => _StepCard(adim: kNamazAdimlari[i]),
          ),
        ),
        _navBar(total),
      ]),
    );
  }

  Widget _navBar(int total) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(children: [
          _navBtn(
            icon: Icons.chevron_left_rounded,
            label: "Geri",
            enabled: _index > 0,
            onTap: () => _go(_index - 1),
          ),
          const SizedBox(width: 12),
          // Nokta göstergesi
          Expanded(
            child: Center(
              child: Wrap(
                spacing: 5,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: List.generate(total, (i) {
                  final active = i == _index;
                  return GestureDetector(
                    onTap: () => _go(i),
                    child: Container(
                      width: active ? 18 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: active ? QC.gold : QC.greenMid.withAlpha(120),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _navBtn(
            icon: Icons.chevron_right_rounded,
            label: _index == total - 1 ? "Bitti" : "İleri",
            enabled: _index < total - 1,
            primary: true,
            onTap: () => _go(_index + 1),
          ),
        ]),
      ),
    );
  }

  Widget _navBtn({
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback onTap,
    bool primary = false,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: primary ? QC.gold : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primary ? QC.gold : QC.greenPale, width: 1.4),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (!primary) Icon(icon, color: QC.greenMain, size: 20),
              Text(label,
                  style: GoogleFonts.lora(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: primary ? QC.greenDark : QC.greenMain)),
              if (primary) Icon(icon, color: QC.greenDark, size: 20),
            ]),
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final NamazAdim adim;
  const _StepCard({required this.adim});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      children: [
        // Görsel
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xFFBFAA97), Color(0xFFE4D0BE)]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: QC.gold.withAlpha(120), width: 1.4),
            boxShadow: [BoxShadow(color: QC.greenMain.withAlpha(28), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            namazImage(adim.image),
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.mosque_rounded, size: 64, color: QC.greenMid)),
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [QC.gold, QC.goldLight]),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text('${adim.id}',
                    style: GoogleFonts.lora(
                        fontSize: 15, fontWeight: FontWeight.w700, color: QC.greenDark))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(adim.baslik,
                style: GoogleFonts.lora(
                    fontSize: 20, fontWeight: FontWeight.w700, color: QC.greenDark)),
          ),
        ]),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: QC.greenPale, width: 1.2),
          ),
          child: Text(adim.aciklama,
              style: GoogleFonts.lora(fontSize: 14, height: 1.7, color: const Color(0xFF374151))),
        ),
        if (adim.okumalar.isNotEmpty) ...[
          const SizedBox(height: 18),
          Row(children: [
            const Icon(Icons.menu_book_rounded, color: QC.greenMain, size: 18),
            const SizedBox(width: 8),
            Text("Bu Adımda Okunanlar",
                style: GoogleFonts.lora(
                    fontSize: 14, fontWeight: FontWeight.w700, color: QC.greenDark)),
          ]),
          const SizedBox(height: 10),
          ...adim.okumalar.map((o) => _OkumaCard(okuma: o)),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

class _OkumaCard extends StatelessWidget {
  final NamazOkuma okuma;
  const _OkumaCard({required this.okuma});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: QC.greenPale, width: 1.2),
        boxShadow: [BoxShadow(color: QC.greenMain.withAlpha(14), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => NamazOkumaDetayScreen(okuma: okuma))),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                      color: QC.greenMain, borderRadius: BorderRadius.circular(7)),
                  child: Text(okuma.ad,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700, color: QC.goldLight)),
                ),
                const Spacer(),
                const Icon(Icons.open_in_full_rounded, size: 15, color: QC.gold),
              ]),
              const SizedBox(height: 10),
              Text(okuma.arapca,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontFamily: QC.arabicFont, fontSize: 21, height: 1.9, color: QC.greenDark)),
              const SizedBox(height: 8),
              Text(okuma.okunus,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lora(
                      fontSize: 13.5, height: 1.6, fontStyle: FontStyle.italic, color: QC.greenMain)),
              const SizedBox(height: 6),
              Text('Tamamı için dokun · ezberle',
                  style: GoogleFonts.lora(
                      fontSize: 11, fontWeight: FontWeight.w600, color: QC.gold)),
            ]),
          ),
        ),
      ),
    );
  }
}

// Namaz duasının tam metnini gösteren detay ekranı + Ezberle butonu.
class NamazOkumaDetayScreen extends StatelessWidget {
  final NamazOkuma okuma;
  const NamazOkumaDetayScreen({super.key, required this.okuma});

  EzberDua get _ezberDua => EzberDua(
        id: 'namaz_${okuma.ad}',
        ad: okuma.ad,
        kategori: 'Namaz Duaları',
        arabic: okuma.arapca,
        latin: okuma.okunus,
        turkish: okuma.anlam,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: Text(okuma.ad)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: QC.greenMain.withAlpha(22),
                borderRadius: BorderRadius.circular(16)),
            child: Text(okuma.arapca,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    fontFamily: QC.arabicFont, fontSize: 26, height: 2.1, color: QC.greenDark)),
          ),
          const SizedBox(height: 16),
          Text('Okunuş',
              style: GoogleFonts.lora(
                  fontSize: 12, fontWeight: FontWeight.w700, color: QC.gold)),
          const SizedBox(height: 6),
          Text(okuma.okunus,
              style: GoogleFonts.lora(
                  fontSize: 16.5, height: 1.8, fontStyle: FontStyle.italic, color: QC.greenMain)),
          const SizedBox(height: 18),
          Text('Anlamı',
              style: GoogleFonts.lora(
                  fontSize: 12, fontWeight: FontWeight.w700, color: QC.gold)),
          const SizedBox(height: 6),
          Text(okuma.anlam,
              style: GoogleFonts.lora(
                  fontSize: 15, height: 1.75, color: const Color(0xFF374151))),
          const SizedBox(height: 26),
          Material(
            color: QC.greenMain,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EzberPracticeScreen(dualar: [_ezberDua]))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text('Bu Duayı Ezberle',
                      style: GoogleFonts.lora(
                          fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
