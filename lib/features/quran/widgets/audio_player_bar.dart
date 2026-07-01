// Ekranın altında kalan mini tilavet oynatıcısı.
// Play/pause, önceki/sonraki ayet, sure/ayet adı, ilerleme çubuğu.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../data/quran_audio_service.dart';
import '../models/quran_models.dart';
import '../quran_theme.dart';

class AudioPlayerBar extends StatelessWidget {
  const AudioPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = QuranAudioService.instance;
    return ValueListenableBuilder<Surah?>(
      valueListenable: audio.currentSurah,
      builder: (context, surah, _) {
        if (surah == null) return const SizedBox.shrink();
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [QC.greenMain, QC.greenDark]),
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, -2))],
          ),
          child: SafeArea(
            top: false,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // İlerleme çubuğu
              StreamBuilder<Duration>(
                stream: audio.player.positionStream,
                builder: (context, snap) {
                  final pos = snap.data ?? Duration.zero;
                  final total = audio.player.duration ?? Duration.zero;
                  final v = total.inMilliseconds == 0
                      ? 0.0
                      : (pos.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
                  return LinearProgressIndicator(
                    value: v,
                    minHeight: 3,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(QC.goldLight),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
                child: Row(children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: QC.gold),
                    child: const Center(
                        child: Text("📖", style: TextStyle(fontSize: 18))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StreamBuilder<int?>(
                      stream: audio.player.currentIndexStream,
                      builder: (context, snap) {
                        final ayahNo = (snap.data ?? 0) + 1;
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${surah.turkishName} Suresi",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lora(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              Text("Ayet $ayahNo / ${surah.ayahCount}",
                                  style: const TextStyle(
                                      fontSize: 11, color: QC.greenPale)),
                            ]);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded,
                        color: Colors.white, size: 28),
                    onPressed: audio.previous,
                  ),
                  StreamBuilder<PlayerState>(
                    stream: audio.player.playerStateStream,
                    builder: (context, snap) {
                      final state = snap.data;
                      final playing = state?.playing ?? false;
                      final loading = state?.processingState == ProcessingState.loading ||
                          state?.processingState == ProcessingState.buffering;
                      if (loading) {
                        return const Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: QC.goldLight)),
                        );
                      }
                      return IconButton(
                        icon: Icon(
                            playing
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_fill_rounded,
                            color: QC.goldLight,
                            size: 38),
                        onPressed: audio.togglePlay,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded,
                        color: Colors.white, size: 28),
                    onPressed: audio.next,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white54, size: 22),
                    onPressed: audio.stop,
                  ),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}
