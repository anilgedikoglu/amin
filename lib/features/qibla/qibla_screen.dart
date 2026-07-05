// Kıble Pusulası — flutter_qiblah (pusula sensörü + konum).
// Cihazı çevir, Kâbe işareti yukarı (üçgen) hizalanınca kıbleye dönüktür.
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});
  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final Future<bool?> _sensorSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  void dispose() {
    FlutterQiblah().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text("Kıble Pusulası", style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
      ),
      body: FutureBuilder<bool?>(
        future: _sensorSupport,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: QC.greenMain));
          }
          if (snap.data == false) {
            return _message(Icons.explore_off_rounded,
                "Cihazınızda pusula sensörü bulunmuyor.",
                "Kıble pusulası için manyetometre (pusula) sensörü gereklidir.");
          }
          return _LocationGate();
        },
      ),
    );
  }

  Widget _message(IconData icon, String title, String sub) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 60, color: QC.greenMid),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center,
                style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w700, color: QC.greenDark)),
            const SizedBox(height: 8),
            Text(sub, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: QC.greenMid, height: 1.5)),
          ]),
        ),
      );
}

class _LocationGate extends StatefulWidget {
  @override
  State<_LocationGate> createState() => _LocationGateState();
}

class _LocationGateState extends State<_LocationGate> {
  late Future<LocationStatus> _future;

  @override
  void initState() {
    super.initState();
    _future = FlutterQiblah.checkLocationStatus();
  }

  Future<void> _request() async {
    await FlutterQiblah.requestPermissions();
    setState(() => _future = FlutterQiblah.checkLocationStatus());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationStatus>(
      future: _future,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator(color: QC.greenMain));
        }
        final s = snap.data!;
        if (!s.enabled) {
          return _info(Icons.location_off_rounded, "Konum servisi kapalı",
              "Lütfen cihazınızın konum (GPS) servisini açın.", "Tekrar Dene", _request);
        }
        switch (s.status) {
          case LocationPermission.denied:
          case LocationPermission.unableToDetermine:
            return _info(Icons.location_searching_rounded, "Konum izni gerekli",
                "Kıble yönünü hesaplamak için konum izni verin.", "İzin Ver", _request);
          case LocationPermission.deniedForever:
            return _info(Icons.location_disabled_rounded, "Konum izni reddedildi",
                "Lütfen uygulama ayarlarından konum iznini verin.", "Tekrar Dene", _request);
          case LocationPermission.whileInUse:
          case LocationPermission.always:
            return const _QiblaCompass();
        }
      },
    );
  }

  Widget _info(IconData icon, String title, String sub, String btn, VoidCallback onTap) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 60, color: QC.greenMid),
            const SizedBox(height: 16),
            Text(title, textAlign: TextAlign.center,
                style: GoogleFonts.lora(fontSize: 17, fontWeight: FontWeight.w700, color: QC.greenDark)),
            const SizedBox(height: 8),
            Text(sub, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: QC.greenMid, height: 1.5)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                  backgroundColor: QC.greenMain, foregroundColor: Color(0xFFFAF7F0),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text(btn),
            ),
          ]),
        ),
      );
}

class _QiblaCompass extends StatelessWidget {
  const _QiblaCompass();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator(color: QC.greenMain));
        }
        final q = snap.data!;
        // qiblah ≈ 0 (veya 360) → cihaz kıbleye dönük
        final qn = q.qiblah % 360;
        final aligned = qn < 5 || qn > 355;
        return Column(children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: aligned ? QC.gold : Color(0xFFFAF7F0),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: aligned ? QC.gold : QC.greenPale, width: 1.4),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(aligned ? Icons.check_circle_rounded : Icons.screen_rotation_rounded,
                  color: aligned ? QC.greenDark : QC.greenMain, size: 22),
              const SizedBox(width: 10),
              Text(
                  aligned ? "Kıble yönündesiniz" : "Cihazı yavaşça çevirin",
                  style: GoogleFonts.lora(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: aligned ? QC.greenDark : QC.greenMain)),
            ]),
          ),
          const SizedBox(height: 8),
          Text("Kıble: ${q.offset.toStringAsFixed(0)}° (Kuzeyden)",
              style: const TextStyle(fontSize: 12, color: QC.greenMid)),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: Stack(alignment: Alignment.center, children: [
                  // Dönen pusula kadranı
                  Transform.rotate(
                    angle: -(q.direction * (math.pi / 180)),
                    child: CustomPaint(size: const Size(300, 300), painter: _DialPainter()),
                  ),
                  // Kâbe işaretçisi (kıbleye doğru)
                  Transform.rotate(
                    angle: -(q.qiblah * (math.pi / 180)),
                    child: CustomPaint(
                        size: const Size(300, 300),
                        painter: _QiblaPointerPainter(aligned: aligned)),
                  ),
                  // Merkez göbek
                  Container(
                    width: 16, height: 16,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: QC.greenDark),
                  ),
                ]),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Text(
                "En doğru sonuç için telefonu düz tutun ve manyetik alanlardan (metal, elektronik) uzak durun.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: QC.greenMid, height: 1.5, fontStyle: FontStyle.italic)),
          ),
        ]);
      },
    );
  }
}

// Pusula kadranı: dış halka + yön harfleri + derece çizgileri
class _DialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 6;
    canvas.drawCircle(c, r, Paint()..color = Color(0xFFFAF7F0));
    canvas.drawCircle(c, r,
        Paint()..color = QC.greenPale..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(c, r - 14,
        Paint()..color = QC.gold.withAlpha(120)..style = PaintingStyle.stroke..strokeWidth = 1);
    // Derece çizgileri
    for (var d = 0; d < 360; d += 15) {
      final a = d * math.pi / 180;
      final major = d % 90 == 0;
      final p1 = c + Offset(math.sin(a), -math.cos(a)) * (r - 6);
      final p2 = c + Offset(math.sin(a), -math.cos(a)) * (r - (major ? 22 : 14));
      canvas.drawLine(p1, p2,
          Paint()..color = major ? QC.greenMain : QC.greenMid.withAlpha(120)
            ..strokeWidth = major ? 2.5 : 1);
    }
    // Yön harfleri
    const dirs = {0: 'K', 90: 'D', 180: 'G', 270: 'B'};
    dirs.forEach((deg, label) {
      final a = deg * math.pi / 180;
      final pos = c + Offset(math.sin(a), -math.cos(a)) * (r - 40);
      final tp = TextPainter(
        text: TextSpan(text: label, style: TextStyle(
            color: deg == 0 ? QC.gold : QC.greenDark,
            fontSize: 20, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

// Kıble işaretçisi: merkezden yukarı bir ok + ucunda Kâbe sembolü
class _QiblaPointerPainter extends CustomPainter {
  final bool aligned;
  _QiblaPointerPainter({required this.aligned});
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 6;
    final col = aligned ? QC.gold : QC.greenMain;
    // Ok çizgisi
    canvas.drawLine(c, Offset(c.dx, c.dy - r + 44),
        Paint()..color = col..strokeWidth = 3..strokeCap = StrokeCap.round);
    // Kâbe sembolü (kavisli kare + altın kuşak)
    final kaabaTop = Offset(c.dx, c.dy - r + 30);
    const s = 22.0;
    final rect = Rect.fromCenter(center: kaabaTop, width: s, height: s);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()..color = const Color(0xFF1a1a1a));
    canvas.drawRect(
        Rect.fromCenter(center: kaabaTop.translate(0, -s * 0.18), width: s, height: s * 0.22),
        Paint()..color = QC.gold);
    // Üçgen uç (yön)
    final tri = Path()
      ..moveTo(c.dx, c.dy - r + 6)
      ..lineTo(c.dx - 8, c.dy - r + 22)
      ..lineTo(c.dx + 8, c.dy - r + 22)
      ..close();
    canvas.drawPath(tri, Paint()..color = col);
  }

  @override
  bool shouldRepaint(covariant _QiblaPointerPainter old) => old.aligned != aligned;
}
