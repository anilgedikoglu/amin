// Mevcut Türkçe mealler (çeviriler) kayıt defteri.
// Her biri assets/quran/trans/{id}.json dosyasından lazy yüklenir.
// Kaynak: fawazahmed0/quran-api (çoğu Tanzil tabanlı).
// LİSANS NOTU: Tanzil tabanlı mealler gayri-ticari (non-commercial) lisanslı
// olabilir; reklamlı/ticari yayında ilgili hak sahibinden izin gerekebilir.
// Edip Yüksel sürümü MIT (daha serbest).

class MealInfo {
  final String id; // dosya adı + pref anahtarı
  final String name; // kısa ad
  final String author; // çevirmen
  final String license; // lisans/kaynak notu
  const MealInfo(this.id, this.name, this.author, this.license);
}

const List<MealInfo> kMeals = [
  MealInfo('diyanet', 'Diyanet İşleri', 'Diyanet İşleri Başkanlığı', 'Tanzil — gayri-ticari'),
  MealInfo('diyanetvakfi', 'Diyanet Vakfı', 'Diyanet Vakfı', 'Tanzil — gayri-ticari'),
  MealInfo('elmalili', 'Elmalılı Hamdi Yazır', 'Elmalılı M. Hamdi Yazır', 'Tanzil — gayri-ticari'),
  MealInfo('yasarnuri', 'Yaşar Nuri Öztürk', 'Yaşar Nuri Öztürk', 'Tanzil — gayri-ticari'),
  MealInfo('edipyuksel', 'Edip Yüksel', 'Edip Yüksel', 'MIT — serbest'),
  MealInfo('suleymanates', 'Süleyman Ateş', 'Süleyman Ateş', 'Tanzil — gayri-ticari'),
  MealInfo('alibulac', 'Ali Bulaç', 'Ali Bulaç', 'Tanzil — gayri-ticari'),
  MealInfo('golpinarli', 'Abdulbaki Gölpınarlı', 'Abdulbaki Gölpınarlı', 'Tanzil — gayri-ticari'),
  MealInfo('suatyildirim', 'Suat Yıldırım', 'Suat Yıldırım', 'Tanzil — gayri-ticari'),
  MealInfo('esed', 'Muhammed Esed', 'Muhammed Esed (açıklamalı)', 'Tanzil — gayri-ticari'),
  MealInfo('ibnikesir', 'İbn Kesir (Tefsir)', 'İbn Kesir — tefsirli meal', 'Tanzil — gayri-ticari'),
  MealInfo('tefhim', 'Tefhîmü\'l-Kur\'an (Tefsir)', 'Mevdûdî — tefsirli meal', 'Tanzil — gayri-ticari'),
];

MealInfo mealById(String id) =>
    kMeals.firstWhere((m) => m.id == id, orElse: () => kMeals.first);

const String kDefaultMeal = 'diyanet';
