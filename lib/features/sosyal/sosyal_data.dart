// Sosyal — dini günler için kısa kutlama mesajları, şiirler ve dualar.
// Her mesaj paylaşılabilir bir görsel karta dönüştürülebilir.

class SosyalVesile {
  final String id, baslik, altBaslik;
  final List<String> mesajlar;
  const SosyalVesile(this.id, this.baslik, this.altBaslik, this.mesajlar);
}

const List<SosyalVesile> kSosyalVesileler = [
  SosyalVesile('ramazan', 'Ramazan Bayramı', 'Bayram tebrikleri', [
    'Gönüller bir, dualar bir olsun. Ramazan Bayramınız mübarek, sofranız bereketli, kalbiniz huzurlu olsun.',
    'Orucun rahmeti, bayramın neşesi üzerinizden eksik olmasın. İyi bayramlar!',
    'Bu mübarek bayramda dargınlıklar bitsin, gönüller barışsın, eviniz huzurla dolsun. Bayramınız kutlu olsun.',
    'Nice bayramlara sevdiklerinizle birlikte, sağlık ve huzur içinde erişmeniz duasıyla. Ramazan Bayramınız mübarek olsun.',
  ]),
  SosyalVesile('kurban', 'Kurban Bayramı', 'Bayram tebrikleri', [
    'Teslimiyetin ve fedakârlığın bayramı Kurban Bayramınız mübarek olsun. Kurbanlarınız kabul olsun.',
    'Bu bayram, paylaştıkça çoğalan bir bereket getirsin. İyi bayramlar, gönlünüz hep tok olsun.',
    'İbrahimî bir teslimiyetle, gönülden bir niyetle… Kurban Bayramınız kutlu, kurbanlarınız makbul olsun.',
    'Sevgi paylaşıldıkça güzel. Bayramınız bereketli, sofranız ve gönlünüz dolu olsun.',
  ]),
  SosyalVesile('regaip', 'Regaip Kandili', 'Kandil tebrikleri', [
    'Rahmet kapılarının açıldığı bu gece, dualarınız kabul, gönlünüz nur ile dolsun. Regaip Kandiliniz mübarek olsun.',
    'Üç ayların müjdecisi Regaip Kandilinde, niyetleriniz hayır, dualarınız makbul olsun.',
    'Bu mübarek gecede edilen dualar geri çevrilmez. Kandiliniz mübarek, kalbiniz huzurlu olsun.',
  ]),
  SosyalVesile('mirac', 'Mirac Kandili', 'Kandil tebrikleri', [
    'Göklerin kapısının aralandığı bu mübarek gecede, dualarınız arşa yükselsin. Mirac Kandiliniz mübarek olsun.',
    'Mirac, kulluğun en yüce yolculuğudur. Bu gece gönlünüz semaya açılsın, duanız kabul olsun.',
    'Namazın hediye edildiği bu gecede, secdeleriniz huzur, dualarınız nur olsun. Hayırlı kandiller.',
  ]),
  SosyalVesile('berat', 'Berat Kandili', 'Kandil tebrikleri', [
    'Affın ve beraatin gecesi… Geçmiş günahlarınız bağışlansın, defteriniz nurla dolsun. Berat Kandiliniz mübarek olsun.',
    'Bu gece rahmet sağanak sağanak yağar. Tövbeleriniz kabul, kalbiniz pak olsun.',
    'Berat, yeniden başlamaktır. Gönlünüz arınsın, yolunuz aydınlık olsun. Hayırlı kandiller.',
  ]),
  SosyalVesile('kadir', 'Kadir Gecesi', 'Bin aydan hayırlı gece', [
    'Bin aydan hayırlı bu gecede, tek bir duanız bile ömrünüzü aydınlatsın. Kadir Geceniz mübarek olsun.',
    'Meleklerin yeryüzüne indiği bu mübarek gecede, gönlünüz huzurla, defteriniz sevapla dolsun.',
    'Kadir Gecesi\'nin feyzi üzerinize olsun; dualarınız kabul, kalbiniz nur ile dolu olsun.',
  ]),
  SosyalVesile('mevlid', 'Mevlid Kandili', 'Peygamberimizin doğumu', [
    'Âlemlere rahmet olarak gönderilen Sevgili Peygamberimizin dünyaya teşrif ettiği bu gece kutlu olsun. Mevlid Kandiliniz mübarek olsun.',
    'O\'nun (s.a.v.) yolu sevgi, merhamet ve barıştır. Bu mübarek gecede gönlünüz O\'nun sevgisiyle dolsun.',
    'Bir gül doğdu âleme… Mevlid Kandilinde salavatlarınız eksik olmasın. Hayırlı kandiller.',
  ]),
  SosyalVesile('cuma', 'Cuma Mesajları', 'Hayırlı cumalar', [
    'Cuma, gönüllerin buluştuğu, duaların kabul olduğu gündür. Hayırlı cumalar, bereketli günler.',
    'Bu mübarek Cuma gününde dualarınız kabul, kalbiniz huzur, sofranız bereket dolu olsun.',
    'Salât ü selamların arşa yükseldiği bu günde, gönlünüz nurla dolsun. Hayırlı cumalar.',
    'Cumanız mübarek olsun; dertleriniz derman, dualarınız makbul, yüzünüz hep gülsün.',
  ]),
  SosyalVesile('asure', 'Aşure / Muharrem', 'Muharrem ayı', [
    'Bereketin ve paylaşmanın sembolü aşure gibi, hayatınız da tatlı ve bol olsun. Hayırlı Muharremler.',
    'Muharrem ayının rahmeti üzerinize olsun; gönlünüz tok, sofranız komşularla paylaşıldıkça bereketli olsun.',
  ]),
  SosyalVesile('uc_aylar', 'Üç Aylar & Genel', 'Manevi mevsim', [
    'Rahmet, mağfiret ve bereket mevsimi üç aylar hayırlı olsun. Gönüllerimiz manevi bir baharla dirilsin.',
    'Receb, Şaban ve Ramazan… Bu manevi yolculukta kalbiniz huzur, duanız kabul olsun. Hayırlı üç aylar.',
    'Her günümüz şükür, her gecemiz dua olsun. Allah gönlünüzdeki hayırlı niyetleri gerçek kılsın.',
  ]),
];
