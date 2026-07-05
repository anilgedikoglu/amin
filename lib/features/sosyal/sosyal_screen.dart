// Sosyal — dini gün kutlama mesajları + paylaşılabilir görsel kartlar.
// Kart, RepaintBoundary ile PNG'ye çevrilip share_plus ile sosyal medyada paylaşılır.
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../quran/quran_theme.dart';
import '../../widgets/brand_icons.dart';
import 'sosyal_data.dart';

class SosyalScreen extends StatelessWidget {
  const SosyalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Sosyal · Kutlama')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Text('Dini günler için kutlama mesajları seç, tek dokunuşla paylaşılabilir bir kart oluştur.',
              style: GoogleFonts.lora(fontSize: 12.5, height: 1.45, color: QC.greenMid)),
          const SizedBox(height: 14),
          ...kSosyalVesileler.map((v) => _vesileTile(context, v)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _vesileTile(BuildContext context, SosyalVesile v) {
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
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                  center: Alignment(-0.3, -0.4), colors: [QC.goldLight, QC.gold])),
          child: const Icon(Icons.celebration_rounded, color: QC.greenDark, size: 22),
        ),
        title: Text(v.baslik,
            style: GoogleFonts.lora(
                fontSize: 15.5, fontWeight: FontWeight.w700, color: QC.greenDark)),
        subtitle: Text('${v.altBaslik} · ${v.mesajlar.length} mesaj',
            style: GoogleFonts.lora(fontSize: 12, color: QC.greenMid)),
        trailing: const Icon(Icons.chevron_right_rounded, color: QC.gold),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => _MesajListScreen(vesile: v))),
      ),
    );
  }
}

class _MesajListScreen extends StatelessWidget {
  final SosyalVesile vesile;
  const _MesajListScreen({required this.vesile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: Text(vesile.baslik)),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          for (final m in vesile.mesajlar)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(0xFFFAF7F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: QC.greenPale.withAlpha(150)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m,
                    style: GoogleFonts.lora(
                        fontSize: 14, height: 1.55, color: QC.greenDark)),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                        backgroundColor: QC.greenMain,
                        foregroundColor: Color(0xFFFAF7F0),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                    icon: const Icon(Icons.ios_share_rounded, size: 18),
                    label: Text('Görsel oluştur & paylaş',
                        style: GoogleFonts.lora(fontWeight: FontWeight.w700, fontSize: 13)),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                PaylasKartScreen(baslik: vesile.baslik, mesaj: m))),
                  ),
                ),
              ]),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class PaylasKartScreen extends StatefulWidget {
  final String baslik, mesaj;
  const PaylasKartScreen({super.key, required this.baslik, required this.mesaj});
  @override
  State<PaylasKartScreen> createState() => _PaylasKartScreenState();
}

class _PaylasKartScreenState extends State<PaylasKartScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _busy = false;

  Future<void> _share() async {
    setState(() => _busy = true);
    try {
      final boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? bytes =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) return;
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/amin_kart_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      await Share.shareXFiles([XFile(file.path)],
          text: '${widget.mesaj}\n\n— Amin · İman Portalı');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Paylaşım sırasında bir sorun oluştu.')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(title: const Text('Paylaş')),
      body: Column(children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: RepaintBoundary(
                key: _cardKey,
                child: _Card(baslik: widget.baslik, mesaj: widget.mesaj),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: QC.gold,
                  foregroundColor: QC.greenDark,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: QC.greenDark))
                  : const Icon(Icons.ios_share_rounded),
              label: Text(_busy ? 'Hazırlanıyor…' : 'Sosyal medyada paylaş',
                  style: GoogleFonts.lora(fontWeight: FontWeight.w800, fontSize: 15)),
              onPressed: _busy ? null : _share,
            ),
          ),
        ),
      ]),
    );
  }
}

// Paylaşılan tasarımlı kart (sabit oran — sosyal medya için).
class _Card extends StatelessWidget {
  final String baslik, mesaj;
  const _Card({required this.baslik, required this.mesaj});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [QC.greenDark, QC.greenMain, QC.greenDark],
            stops: [0, 0.55, 1]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: QC.gold.withAlpha(120), width: 1.5),
      ),
      child: Stack(children: [
        const Positioned.fill(
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: GeometricBackdrop())),
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const CrescentStarIcon(size: 46, color: QC.goldLight),
            const SizedBox(height: 14),
            Text(baslik.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: QC.goldLight)),
            const SizedBox(height: 12),
            const ArabesqueDivider(width: 150),
            const SizedBox(height: 18),
            Text(mesaj,
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                    fontSize: 15.5, height: 1.6, color: Color(0xFFFAF7F0))),
            const SizedBox(height: 22),
            const ArabesqueDivider(width: 110),
            const SizedBox(height: 12),
            Text('amin',
                style: GoogleFonts.amiri(
                    fontSize: 20, color: QC.goldLight, letterSpacing: 3)),
            Text('İMAN PORTALI',
                style: GoogleFonts.lora(
                    fontSize: 8.5,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                    color: QC.greenPale)),
          ]),
        ),
      ]),
    );
  }
}
