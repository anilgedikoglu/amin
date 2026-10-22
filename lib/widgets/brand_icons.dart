// Amin — marka vektör ikonografisi.
// Tüm ikonlar CustomPainter ile çizilir (emoji YOK) → her platformda
// keskin, ölçeklenebilir, tutarlı ve premium görünüm.
import 'dart:math' as math;
import 'package:flutter/material.dart';

class _Brand {
  static const greenDark = Color(0xFF1a4731);
  static const greenMain = Color(0xFF2d6a4f);
  static const greenPale = Color(0xFFb7e4c7);
  static const gold = Color(0xFFc9a84c);
  static const goldLight = Color(0xFFf0d080);
}

// ── Yardımcı: çok köşeli yıldız yolu ──
Path _starPath(Offset c, double r, {int points = 5, double innerRatio = 0.45}) {
  final p = Path();
  for (var i = 0; i < points; i++) {
    final oa = -math.pi / 2 + i * 2 * math.pi / points;
    final ia = oa + math.pi / points;
    final o = c + Offset(math.cos(oa), math.sin(oa)) * r;
    final inr = c + Offset(math.cos(ia), math.sin(ia)) * r * innerRatio;
    if (i == 0) {
      p.moveTo(o.dx, o.dy);
    } else {
      p.lineTo(o.dx, o.dy);
    }
    p.lineTo(inr.dx, inr.dy);
  }
  p.close();
  return p;
}

// ════════════════════════════════════════════
//  HİLAL + YILDIZ  (logo / ana sembol)
// ════════════════════════════════════════════
class CrescentStarIcon extends StatelessWidget {
  final double size;
  final Color color;
  const CrescentStarIcon({super.key, this.size = 56, this.color = _Brand.gold});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _CrescentStarPainter(color));
}

class _CrescentStarPainter extends CustomPainter {
  final Color color;
  _CrescentStarPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;
    final c = Offset(size.width * 0.46, size.height * 0.52);
    final r = size.width * 0.34;
    // Hilal: dış daireden kaydırılmış iç daireyi çıkar
    final outer = Path()..addOval(Rect.fromCircle(center: c, radius: r));
    final inner = Path()
      ..addOval(Rect.fromCircle(
          center: c + Offset(r * 0.46, -r * 0.10), radius: r * 0.88));
    canvas.drawPath(Path.combine(PathOperation.difference, outer, inner), paint);
    // Yıldız: hilalin ağzında, sağ üstte
    canvas.drawPath(
        _starPath(c + Offset(r * 1.02, -r * 0.30), r * 0.42, points: 5), paint);
  }

  @override
  bool shouldRepaint(covariant _CrescentStarPainter old) => old.color != color;
}

// ════════════════════════════════════════════
//  TESBİH  (dualara devam)
// ════════════════════════════════════════════
class TasbihIcon extends StatelessWidget {
  final double size;
  final Color color;
  const TasbihIcon({super.key, this.size = 30, this.color = _Brand.gold});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _TasbihPainter(color));
}

class _TasbihPainter extends CustomPainter {
  final Color color;
  _TasbihPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;
    final center = Offset(size.width / 2, size.height * 0.44);
    final ringR = size.width * 0.30;
    final beadR = size.width * 0.066;
    const n = 14;
    for (var i = 0; i < n; i++) {
      final a = -math.pi / 2 + i * 2 * math.pi / n;
      canvas.drawCircle(
          center + Offset(math.cos(a), math.sin(a)) * ringR, beadR, paint);
    }
    // İmame (büyük bead) + püskül, altta
    final bottom = center + Offset(0, ringR + beadR * 1.4);
    canvas.drawCircle(bottom, beadR * 1.5, paint);
    final stroke = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.035
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(bottom + Offset(0, beadR * 1.5),
        bottom + Offset(0, beadR * 3.4), stroke);
  }

  @override
  bool shouldRepaint(covariant _TasbihPainter old) => old.color != color;
}

// ════════════════════════════════════════════
//  AÇIK KİTAP  (Kur'an-ı Kerim)
// ════════════════════════════════════════════
class OpenBookIcon extends StatelessWidget {
  final double size;
  final Color color;
  const OpenBookIcon({super.key, this.size = 30, this.color = _Brand.gold});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _OpenBookPainter(color));
}

class _OpenBookPainter extends CustomPainter {
  final Color color;
  _OpenBookPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height, cx = w / 2;
    final stroke = Paint()
      ..color = color
      ..strokeWidth = w * 0.05
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    final fill = Paint()
      ..color = color.withAlpha(28)
      ..isAntiAlias = true;

    Path page(bool left) {
      final s = left ? -1.0 : 1.0;
      return Path()
        ..moveTo(cx, h * 0.30)
        ..quadraticBezierTo(cx + s * w * 0.30, h * 0.16, cx + s * w * 0.40, h * 0.26)
        ..lineTo(cx + s * w * 0.40, h * 0.72)
        ..quadraticBezierTo(cx + s * w * 0.30, h * 0.64, cx, h * 0.74)
        ..close();
    }

    canvas.drawPath(page(true), fill);
    canvas.drawPath(page(false), fill);
    canvas.drawPath(page(true), stroke);
    canvas.drawPath(page(false), stroke);
    // Sırt
    canvas.drawLine(Offset(cx, h * 0.30), Offset(cx, h * 0.74), stroke);
    // Satır izleri
    final line = Paint()
      ..color = color.withAlpha(150)
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final y = h * (0.40 + i * 0.10);
      canvas.drawLine(Offset(cx - w * 0.28, y), Offset(cx - w * 0.08, y), line);
      canvas.drawLine(Offset(cx + w * 0.08, y), Offset(cx + w * 0.28, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant _OpenBookPainter old) => old.color != color;
}

// ════════════════════════════════════════════
//  DUA ELLERİ  (dua et)
// ════════════════════════════════════════════
class DuaHandsIcon extends StatelessWidget {
  final double size;
  final Color color;
  const DuaHandsIcon({super.key, this.size = 30, this.color = _Brand.gold});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _DuaHandsPainter(color));
}

class _DuaHandsPainter extends CustomPainter {
  final Color color;
  _DuaHandsPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height, cx = w / 2;
    final fill = Paint()
      ..color = color
      ..isAntiAlias = true;
    final stroke = Paint()
      ..color = color
      ..strokeWidth = w * 0.05
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // İki avuç (yukarı açık) — simetrik yaprak benzeri form
    Path palm(bool left) {
      final s = left ? -1.0 : 1.0;
      return Path()
        ..moveTo(cx + s * w * 0.02, h * 0.84)
        ..quadraticBezierTo(cx + s * w * 0.04, h * 0.50, cx + s * w * 0.30, h * 0.30)
        ..quadraticBezierTo(cx + s * w * 0.40, h * 0.22, cx + s * w * 0.34, h * 0.40)
        ..quadraticBezierTo(cx + s * w * 0.26, h * 0.56, cx + s * w * 0.22, h * 0.78)
        ..quadraticBezierTo(cx + s * w * 0.16, h * 0.86, cx + s * w * 0.02, h * 0.84)
        ..close();
    }

    canvas.drawPath(palm(true), stroke);
    canvas.drawPath(palm(false), stroke);
    // İçteki ışık/nokta (niyet)
    canvas.drawCircle(Offset(cx, h * 0.30), w * 0.05, fill);
    // Işık huzmeleri
    final ray = Paint()
      ..color = color.withAlpha(170)
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, h * 0.18), Offset(cx, h * 0.10), ray);
    canvas.drawLine(Offset(cx - w * 0.12, h * 0.20), Offset(cx - w * 0.17, h * 0.13), ray);
    canvas.drawLine(Offset(cx + w * 0.12, h * 0.20), Offset(cx + w * 0.17, h * 0.13), ray);
  }

  @override
  bool shouldRepaint(covariant _DuaHandsPainter old) => old.color != color;
}

// ════════════════════════════════════════════
//  HERO MADALYON  (ana ekran logosu)
// ════════════════════════════════════════════
class HeroMedallion extends StatelessWidget {
  final double size;
  const HeroMedallion({super.key, this.size = 128});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(alignment: Alignment.center, children: [
        // Arka ışıma + yıldız patlaması
        CustomPaint(size: Size.square(size), painter: _StarBurstPainter()),
        // Madalyon gövdesi
        Container(
          width: size * 0.74,
          height: size * 0.74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              center: Alignment(-0.3, -0.4),
              colors: [_Brand.greenMain, _Brand.greenDark],
            ),
            border: Border.all(color: _Brand.gold, width: 2),
            boxShadow: [
              BoxShadow(color: _Brand.gold.withAlpha(90), blurRadius: 26, spreadRadius: 2),
              BoxShadow(color: Colors.black.withAlpha(70), blurRadius: 14, offset: const Offset(0, 6)),
            ],
          ),
          child: CustomPaint(painter: _MedallionInnerPainter()),
        ),
      ]),
    );
  }
}

class _StarBurstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final p = Paint()
      ..color = _Brand.gold.withAlpha(26)
      ..isAntiAlias = true;
    // İki kaydırık kare = 8 köşeli yıldız (geometrik motif)
    final r = size.width * 0.5;
    for (final rot in [0.0, math.pi / 4]) {
      final path = Path();
      for (var i = 0; i < 4; i++) {
        final a = rot + i * math.pi / 2;
        final pt = c + Offset(math.cos(a), math.sin(a)) * r;
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      path.close();
      canvas.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _MedallionInnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    // İnce iç halka
    final ring = Paint()
      ..color = _Brand.gold.withAlpha(120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.012
      ..isAntiAlias = true;
    canvas.drawCircle(c, size.width * 0.40, ring);
    // Hilal + yıldız (altın gradient)
    final rect = Rect.fromCircle(center: c, radius: size.width * 0.5);
    final gold = Paint()
      ..shader = const LinearGradient(
        colors: [_Brand.goldLight, _Brand.gold],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..isAntiAlias = true;
    final cc = Offset(size.width * 0.47, size.height * 0.52);
    final r = size.width * 0.24;
    final outer = Path()..addOval(Rect.fromCircle(center: cc, radius: r));
    final inner = Path()
      ..addOval(Rect.fromCircle(center: cc + Offset(r * 0.46, -r * 0.10), radius: r * 0.88));
    canvas.drawPath(Path.combine(PathOperation.difference, outer, inner), gold);
    canvas.drawPath(_starPath(cc + Offset(r * 1.05, -r * 0.32), r * 0.42), gold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ════════════════════════════════════════════
//  ARABESK AYRAÇ
// ════════════════════════════════════════════
class ArabesqueDivider extends StatelessWidget {
  final double width;
  final Color color;
  const ArabesqueDivider({super.key, this.width = 200, this.color = _Brand.gold});
  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size(width, 18),
        painter: _ArabesquePainter(color),
      );
}

class _ArabesquePainter extends CustomPainter {
  final Color color;
  _ArabesquePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2, cx = size.width / 2;
    final line = Paint()
      ..shader = LinearGradient(
        colors: [color.withAlpha(0), color, color.withAlpha(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 1.4
      ..isAntiAlias = true;
    canvas.drawLine(Offset(0, cy), Offset(cx - 14, cy), line..color = color);
    canvas.drawLine(Offset(cx + 14, cy), Offset(size.width, cy), line);
    // Merkez: küçük 8 köşeli yıldız
    final p = Paint()
      ..color = color
      ..isAntiAlias = true;
    final r = size.height * 0.5;
    for (final rot in [0.0, math.pi / 4]) {
      final path = Path();
      for (var i = 0; i < 4; i++) {
        final a = rot + i * math.pi / 2;
        final pt = Offset(cx, cy) + Offset(math.cos(a), math.sin(a)) * r;
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      path.close();
      canvas.drawPath(path, p);
    }
    // Yan noktalar
    canvas.drawCircle(Offset(cx - 14, cy), 1.8, p);
    canvas.drawCircle(Offset(cx + 14, cy), 1.8, p);
  }

  @override
  bool shouldRepaint(covariant _ArabesquePainter old) => old.color != color;
}

// ════════════════════════════════════════════
//  GEOMETRİK ARKA PLAN DOKUSU  (çok hafif)
// ════════════════════════════════════════════
class GeometricBackdrop extends StatelessWidget {
  const GeometricBackdrop({super.key});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _GeoBgPainter(), size: Size.infinite);
}

class _GeoBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = _Brand.greenPale.withAlpha(12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true;
    const step = 92.0;
    final r = step * 0.34;
    for (double y = 0; y < size.height + step; y += step) {
      for (double x = 0; x < size.width + step; x += step) {
        final c = Offset(x, y);
        final path = Path();
        for (final rot in [0.0, math.pi / 4]) {
          for (var i = 0; i < 4; i++) {
            final a = rot + i * math.pi / 2;
            final pt = c + Offset(math.cos(a), math.sin(a)) * r;
            if (i == 0) {
              path.moveTo(pt.dx, pt.dy);
            } else {
              path.lineTo(pt.dx, pt.dy);
            }
          }
          path.close();
        }
        canvas.drawPath(path, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
