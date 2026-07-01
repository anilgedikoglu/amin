// Günlük Hatırlatma ayarları — bildirim aç/kapa, saat seçimi, örnek gönder.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../quran/quran_theme.dart';
import 'notification_service.dart';

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});
  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  final _svc = NotificationService.instance;
  bool _enabled = false;
  bool _prayerEnabled = false;
  int _hour = 9, _min = 0;
  bool _ready = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _enabled = await _svc.isDailyEnabled();
    _prayerEnabled = await _svc.isPrayerEnabled();
    final t = await _svc.dailyTime();
    _hour = t.$1;
    _min = t.$2;
    if (mounted) setState(() => _ready = true);
  }

  Future<void> _togglePrayer(bool v) async {
    setState(() => _busy = true);
    if (v) {
      final granted = await _svc.requestPermissions();
      if (!granted) {
        if (mounted) {
          setState(() => _busy = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Bildirim izni verilmedi.')));
        }
        return;
      }
    }
    await _svc.setPrayerEnabled(v);
    if (mounted) setState(() { _prayerEnabled = v; _busy = false; });
  }

  Future<void> _toggle(bool v) async {
    setState(() => _busy = true);
    if (v) {
      final granted = await _svc.requestPermissions();
      if (!granted) {
        if (mounted) {
          setState(() => _busy = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Bildirim izni verilmedi. Ayarlardan izin verebilirsiniz.')));
        }
        return;
      }
    }
    await _svc.setDailyEnabled(v, hour: _hour, minute: _min);
    if (mounted) setState(() { _enabled = v; _busy = false; });
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _min),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: QC.greenMain, onPrimary: Colors.white)),
        child: child!,
      ),
    );
    if (t != null) {
      setState(() { _hour = t.hour; _min = t.minute; });
      if (_enabled) await _svc.setDailyEnabled(true, hour: _hour, minute: _min);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QC.greenBg,
      appBar: AppBar(
        backgroundColor: QC.greenDark,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text("Günlük Hatırlatma", style: GoogleFonts.lora(fontSize: 16, color: QC.goldLight)),
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator(color: QC.greenMain))
          : ListView(padding: const EdgeInsets.all(18), children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [QC.greenMain, QC.greenDark]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: QC.gold.withAlpha(100)),
                ),
                child: Column(children: [
                  const Icon(Icons.notifications_active_rounded, color: QC.goldLight, size: 40),
                  const SizedBox(height: 10),
                  Text("Günün Hadisi / Sözü",
                      style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 6),
                  const Text("Her gün seçtiğiniz saatte bir hadis veya özlü söz bildirimi alın.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.5, color: QC.greenPale, height: 1.5)),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: QC.greenPale, width: 1.2)),
                child: Column(children: [
                  SwitchListTile(
                    value: _enabled,
                    activeColor: QC.greenMain,
                    title: Text("Bildirimi Etkinleştir",
                        style: GoogleFonts.lora(fontSize: 15, fontWeight: FontWeight.w600, color: QC.greenDark)),
                    subtitle: Text(_enabled ? "Aktif" : "Kapalı",
                        style: TextStyle(fontSize: 12, color: _enabled ? QC.greenMain : QC.greenMid)),
                    onChanged: _busy ? null : _toggle,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    enabled: !_busy,
                    leading: const Icon(Icons.schedule_rounded, color: QC.greenMain),
                    title: Text("Bildirim Saati",
                        style: GoogleFonts.lora(fontSize: 15, fontWeight: FontWeight.w600, color: QC.greenDark)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                          color: QC.greenBg, borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: QC.greenPale)),
                      child: Text(
                          "${_hour.toString().padLeft(2, '0')}:${_min.toString().padLeft(2, '0')}",
                          style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w700, color: QC.greenDark)),
                    ),
                    onTap: _pickTime,
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: QC.greenPale, width: 1.2)),
                child: SwitchListTile(
                  value: _prayerEnabled,
                  activeColor: QC.greenMain,
                  secondary: const Icon(Icons.access_time_filled_rounded, color: QC.greenMain),
                  title: Text("Namaz Vakti Bildirimleri",
                      style: GoogleFonts.lora(fontSize: 15, fontWeight: FontWeight.w600, color: QC.greenDark)),
                  subtitle: Text(
                      _prayerEnabled
                          ? "Seçili şehir için her vakit hatırlatılır"
                          : "Kapalı",
                      style: TextStyle(fontSize: 12, color: _prayerEnabled ? QC.greenMain : QC.greenMid)),
                  onChanged: _busy ? null : _togglePrayer,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  await _svc.requestPermissions();
                  await _svc.showTest();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Örnek bildirim gönderildi.')));
                  }
                },
                style: OutlinedButton.styleFrom(
                    foregroundColor: QC.greenMain,
                    side: const BorderSide(color: QC.greenMain),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                icon: const Icon(Icons.send_rounded),
                label: const Text("Örnek Bildirim Gönder"),
              ),
              const SizedBox(height: 16),
              Text(
                  "Bildirimler cihazınızda yerel olarak planlanır; internet gerektirmez. Her gün farklı bir hadis/söz gösterilir.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: QC.greenMid, height: 1.5, fontStyle: FontStyle.italic)),
            ]),
    );
  }
}
