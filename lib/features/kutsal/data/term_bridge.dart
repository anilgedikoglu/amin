// TR↔EN kavram köprüsü: Türkçe bir kelime arandığında İngilizce kutsal
// metinlerde karşılığı da (ve tersi) taranır. Böylece "aşk" → "love" eşleşir.

const Map<String, List<String>> _bridge = {
  // tr -> en
  'aşk': ['love', 'beloved'],
  'sevgi': ['love', 'charity'],
  'sev': ['love'],
  'merhamet': ['mercy', 'compassion'],
  'şefkat': ['compassion', 'mercy'],
  'sabır': ['patience', 'patient'],
  'adalet': ['justice', 'righteousness'],
  'barış': ['peace'],
  'huzur': ['peace'],
  'ölüm': ['death'],
  'hayat': ['life'],
  'yaşam': ['life'],
  'ışık': ['light'],
  'nur': ['light'],
  'karanlık': ['darkness'],
  'iman': ['faith', 'belief'],
  'inanç': ['faith', 'belief'],
  'dua': ['prayer', 'pray'],
  'günah': ['sin'],
  'cennet': ['heaven', 'paradise'],
  'cehennem': ['hell'],
  'ruh': ['soul', 'spirit'],
  'can': ['soul'],
  'kalp': ['heart'],
  'gönül': ['heart'],
  'bilgelik': ['wisdom'],
  'hikmet': ['wisdom'],
  'bilgi': ['knowledge'],
  'hakikat': ['truth'],
  'gerçek': ['truth'],
  'yalan': ['lie', 'falsehood'],
  'korku': ['fear'],
  'umut': ['hope'],
  'şükür': ['thanks', 'gratitude'],
  'tövbe': ['repent', 'repentance'],
  'kibir': ['pride'],
  'tevazu': ['humility', 'humble'],
  'cömertlik': ['generosity'],
  'oruç': ['fast', 'fasting'],
  'namaz': ['prayer'],
  'tanrı': ['god', 'lord'],
  'allah': ['god', 'lord'],
  'rab': ['lord', 'god'],
  'peygamber': ['prophet'],
  'melek': ['angel'],
  'kıyamet': ['judgment', 'resurrection'],
  'kurtuluş': ['salvation'],
  'bağışla': ['forgive', 'forgiveness'],
  'af': ['forgiveness', 'pardon'],
  'kardeş': ['brother', 'brethren'],
  'anne': ['mother'],
  'baba': ['father'],
  'çocuk': ['child', 'children'],
  'yetim': ['orphan', 'fatherless'],
  'fakir': ['poor'],
  'zengin': ['rich'],
  'savaş': ['war', 'battle'],
  'kan': ['blood'],
  'su': ['water'],
  'ateş': ['fire'],
  'ekmek': ['bread'],
  'şarap': ['wine'],
};

// Ters yön (en -> tr) otomatik kurulur.
final Map<String, List<String>> _reverse = () {
  final m = <String, List<String>>{};
  _bridge.forEach((tr, ens) {
    for (final en in ens) {
      (m[en] ??= []).add(tr);
    }
  });
  return m;
}();

/// Verilen sorgu için taranacak tüm terimleri (kendisi + köprü karşılıkları) döndürür.
List<String> expandQuery(String q) {
  final key = q.trim().toLowerCase();
  final out = <String>{key};
  if (_bridge.containsKey(key)) out.addAll(_bridge[key]!);
  if (_reverse.containsKey(key)) out.addAll(_reverse[key]!);
  return out.toList();
}
