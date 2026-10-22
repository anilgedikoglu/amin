// Delil modülü reklam servisi — AMIN entegrasyonunda NO-OP.
// Amin'in kendi AdManager'ı ve AdMob ID'leri vardır; delil'in ID'leri
// KULLANILMAZ (platform ID'lerini karıştırmamak için). API korunur ki
// delil ekranları derlensin.
import 'package:flutter/widgets.dart';

class AdService {
  AdService._();
  static final AdService instance = AdService._();

  Future<void> init() async {}
  void onCardRead() {}
  void onBackPressed() {}
  bool get isRewardedReady => false;
  void showRewarded({VoidCallback? onRewarded}) => onRewarded?.call();
}
