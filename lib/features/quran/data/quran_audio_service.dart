// Kur'an feature — ses servisi.
// Tilavet ONLINE stream edilir (uygulama boyutunu şişirmez).
// Kullanıcı isterse sureyi OFFLINE indirebilir; indirildiyse yerelden çalar.
// Kaynak: EveryAyah (ayet ayet MP3). Varsayılan kâri: Mishary Alafasy.
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/quran_models.dart';

class Reciter {
  final String id; // EveryAyah klasör adı
  final String name;
  const Reciter(this.id, this.name);
}

class QuranAudioService {
  QuranAudioService._();
  static final QuranAudioService instance = QuranAudioService._();

  static const reciters = <Reciter>[
    Reciter('Alafasy_128kbps', 'Mishary Alafasy'),
    Reciter('Husary_128kbps', 'Mahmoud Husary'),
    Reciter('Abdul_Basit_Murattal_128kbps', 'Abdulbasit Abdussamed'),
    Reciter('Minshawy_Murattal_128kbps', 'Muhammad Minshawi'),
  ];

  final AudioPlayer player = AudioPlayer();
  Reciter reciter = reciters.first;

  // Şu an çalan sure ve playlist'teki ayet numaraları
  final ValueNotifier<Surah?> currentSurah = ValueNotifier(null);
  List<int> _ayahNumbers = const [];

  // İndirme durumu
  final ValueNotifier<bool> downloading = ValueNotifier(false);
  final ValueNotifier<double> downloadProgress = ValueNotifier(0);
  final ValueNotifier<Set<int>> downloadedSurahs = ValueNotifier(<int>{});

  bool _initialized = false;

  Future<void> ensureInit() async {
    if (_initialized) return;
    _initialized = true;
    // Playlist sonuna gelince doğal durur
    await _refreshDownloaded();
  }

  String _pad3(int n) => n.toString().padLeft(3, '0');
  String _fileName(int surah, int ayah) => '${_pad3(surah)}${_pad3(ayah)}.mp3';
  String _remoteUrl(int surah, int ayah) =>
      'https://everyayah.com/data/${reciter.id}/${_fileName(surah, ayah)}';

  Future<Directory> _surahDir(int surahId) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/quran_audio/${reciter.id}/$surahId');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<bool> isSurahDownloaded(Surah s) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/quran_audio/${reciter.id}/${s.id}');
    if (!await dir.exists()) return false;
    for (var a = 1; a <= s.ayahCount; a++) {
      if (!await File('${dir.path}/${_fileName(s.id, a)}').exists()) return false;
    }
    return true;
  }

  Future<void> _refreshDownloaded() async {
    // Hafif kontrol: hangi sure klasörleri var (tam mı diye derine inmez)
    final base = await getApplicationDocumentsDirectory();
    final root = Directory('${base.path}/quran_audio/${reciter.id}');
    final set = <int>{};
    if (await root.exists()) {
      await for (final e in root.list()) {
        final id = int.tryParse(e.path.split(Platform.pathSeparator).last);
        if (id != null) set.add(id);
      }
    }
    downloadedSurahs.value = set;
  }

  Future<AudioSource> _ayahSource(int surahId, int ayah) async {
    final base = await getApplicationDocumentsDirectory();
    final f = File(
        '${base.path}/quran_audio/${reciter.id}/$surahId/${_fileName(surahId, ayah)}');
    if (await f.exists()) return AudioSource.file(f.path);
    return AudioSource.uri(Uri.parse(_remoteUrl(surahId, ayah)));
  }

  // Sureyi (tüm ayetleri) çal — startAyah'tan başlat
  Future<void> playSurah(Surah s, {int startAyah = 1}) async {
    currentSurah.value = s;
    _ayahNumbers = List.generate(s.ayahCount, (i) => i + 1);
    final sources = <AudioSource>[];
    for (var a = 1; a <= s.ayahCount; a++) {
      sources.add(await _ayahSource(s.id, a));
    }
    final playlist = ConcatenatingAudioSource(children: sources);
    await player.setAudioSource(playlist,
        initialIndex: (startAyah - 1).clamp(0, s.ayahCount - 1));
    player.play();
  }

  // Tek ayeti çal (ayet kartındaki dinle butonu)
  Future<void> playAyah(Surah s, int ayah) => playSurah(s, startAyah: ayah);

  int? get currentAyahNumber {
    final idx = player.currentIndex;
    if (idx == null || idx >= _ayahNumbers.length) return null;
    return _ayahNumbers[idx];
  }

  Future<void> togglePlay() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  Future<void> next() async {
    if (player.hasNext) await player.seekToNext();
  }

  Future<void> previous() async {
    if (player.hasPrevious) await player.seekToPrevious();
  }

  Future<void> stop() async {
    await player.stop();
    currentSurah.value = null;
  }

  // Sureyi offline indir
  Future<void> downloadSurah(Surah s) async {
    if (downloading.value) return;
    downloading.value = true;
    downloadProgress.value = 0;
    try {
      final dir = await _surahDir(s.id);
      for (var a = 1; a <= s.ayahCount; a++) {
        final file = File('${dir.path}/${_fileName(s.id, a)}');
        if (!await file.exists()) {
          final resp = await http.get(Uri.parse(_remoteUrl(s.id, a)));
          if (resp.statusCode == 200) {
            await file.writeAsBytes(resp.bodyBytes);
          }
        }
        downloadProgress.value = a / s.ayahCount;
      }
      await _refreshDownloaded();
    } finally {
      downloading.value = false;
    }
  }

  Future<void> deleteDownload(Surah s) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/quran_audio/${reciter.id}/${s.id}');
    if (await dir.exists()) await dir.delete(recursive: true);
    await _refreshDownloaded();
  }

  void dispose() => player.dispose();
}
