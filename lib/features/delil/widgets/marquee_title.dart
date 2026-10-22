// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';

/// AppBar başlığı için marquee (kayan yazı) widget'ı.
///
/// • [text].length > [threshold] ise kayan hale gelir.
/// • [initialDelay] sonra başlar; loop separator: "     -     " (sarı tire).
class MarqueeTitle extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int      threshold;
  final Duration initialDelay;
  final double   speed;      // px/sn

  const MarqueeTitle({
    super.key,
    required this.text,
    required this.style,
    this.threshold    = 20,
    this.initialDelay = const Duration(seconds: 2),
    this.speed        = 45,
  });

  @override
  State<MarqueeTitle> createState() => _MarqueeTitleState();
}

class _MarqueeTitleState extends State<MarqueeTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  double _loopWidth = 0;
  bool _ready = false;

  // Separator: 5 boşluk + "-" + 5 boşluk
  static const _sep = '     -     ';
  static const _goldColor = Color(0xFFC9A84C); // amin gold

  bool get _needsMarquee => widget.text.length > widget.threshold;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 8));
    if (_needsMarquee) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _setup());
    }
  }

  void _setup() {
    if (!mounted) return;

    // Separator içindeki '-' de aynı fontla ölçülür; renk genişliği etkilemez.
    final painter = TextPainter(
      text: TextSpan(text: widget.text + _sep, style: widget.style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    _loopWidth = painter.width;
    _ctrl.duration =
        Duration(milliseconds: (_loopWidth / widget.speed * 1000).round());

    setState(() => _ready = true);

    Future.delayed(widget.initialDelay, () {
      if (mounted) _ctrl.repeat();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Bir tekrar için span listesi: [text]     [gold-]
  List<InlineSpan> _unit() => [
        TextSpan(text: widget.text, style: widget.style),
        TextSpan(text: '     ', style: widget.style),
        TextSpan(
            text: '-',
            style: widget.style.copyWith(
                color: _goldColor, fontWeight: FontWeight.w700)),
        TextSpan(text: '     ', style: widget.style),
      ];

  @override
  Widget build(BuildContext context) {
    if (!_needsMarquee || !_ready) {
      return Text(widget.text,
          style: widget.style,
          overflow: TextOverflow.ellipsis,
          maxLines: 1);
    }

    // İki kopya → seamless loop
    return ClipRect(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Transform.translate(
          offset: Offset(-_ctrl.value * _loopWidth, 0),
          child: RichText(
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            text: TextSpan(children: [..._unit(), ..._unit()]),
          ),
        ),
      ),
    );
  }
}
