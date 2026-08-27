class KeralaDistrict {
  final String id;
  final String nameEn;
  final String nameMl;
  final List<String> primaryCrops;

  const KeralaDistrict({
    required this.id,
    required this.nameEn,
    required this.nameMl,
    required this.primaryCrops,
  });
}

const List<KeralaDistrict> keralaDistrictsList = [
  KeralaDistrict(
    id: 'wayanad',
    nameEn: 'Wayanad',
    nameMl: 'വയനാട്',
    primaryCrops: ['Coffee', 'Black Pepper', 'Tea', 'Cardamom', 'Paddy', 'Ginger'],
  ),
  KeralaDistrict(
    id: 'idukki',
    nameEn: 'Idukki',
    nameMl: 'ഇടുക്കി',
    primaryCrops: ['Cardamom', 'Tea', 'Black Pepper', 'Vegetables', 'Nutmeg'],
  ),
  KeralaDistrict(
    id: 'palakkad',
    nameEn: 'Palakkad',
    nameMl: 'പാലക്കാട്',
    primaryCrops: ['Paddy', 'Coconut', 'Sugarcane', 'Cotton', 'Banana'],
  ),
  KeralaDistrict(
    id: 'thrissur',
    nameEn: 'Thrissur',
    nameMl: 'തൃശ്ശൂർ',
    primaryCrops: ['Coconut', 'Banana (Nendran)', 'Paddy', 'Nutmeg', 'Rubber'],
  ),
  KeralaDistrict(
    id: 'kottayam',
    nameEn: 'Kottayam',
    nameMl: 'കോട്ടയം',
    primaryCrops: ['Rubber', 'Coconut', 'Black Pepper', 'Tapioca', 'Cocoa'],
  ),
  KeralaDistrict(
    id: 'ernakulam',
    nameEn: 'Ernakulam',
    nameMl: 'എറണാകുളം',
    primaryCrops: ['Coconut', 'Rubber', 'Nutmeg', 'Pineapple', 'Paddy'],
  ),
  KeralaDistrict(
    id: 'kozhikode',
    nameEn: 'Kozhikode',
    nameMl: 'കോഴിക്കോട്',
    primaryCrops: ['Coconut', 'Arecanut', 'Black Pepper', 'Banana', 'Tapioca'],
  ),
  KeralaDistrict(
    id: 'malappuram',
    nameEn: 'Malappuram',
    nameMl: 'മലപ്പുറം',
    primaryCrops: ['Coconut', 'Arecanut', 'Rubber', 'Banana', 'Tapioca'],
  ),
  KeralaDistrict(
    id: 'kannur',
    nameEn: 'Kannur',
    nameMl: 'കണ്ണൂർ',
    primaryCrops: ['Coconut', 'Cashew', 'Rubber', 'Black Pepper', 'Arecanut'],
  ),
  KeralaDistrict(
    id: 'kasaragod',
    nameEn: 'Kasaragod',
    nameMl: 'കാസർഗോഡ്',
    primaryCrops: ['Arecanut', 'Coconut', 'Cashew', 'Rubber', 'Black Pepper'],
  ),
  KeralaDistrict(
    id: 'alappuzha',
    nameEn: 'Alappuzha',
    nameMl: 'ആലപ്പുഴ',
    primaryCrops: ['Paddy (Kuttanad)', 'Coconut', 'Tubers', 'Vegetables'],
  ),
  KeralaDistrict(
    id: 'pathanamthitta',
    nameEn: 'Pathanamthitta',
    nameMl: 'പത്തനംതിട്ട',
    primaryCrops: ['Rubber', 'Coconut', 'Tapioca', 'Paddy', 'Black Pepper'],
  ),
  KeralaDistrict(
    id: 'kollam',
    nameEn: 'Kollam',
    nameMl: 'കൊല്ലം',
    primaryCrops: ['Cashew', 'Coconut', 'Rubber', 'Tapioca', 'Black Pepper'],
  ),
  KeralaDistrict(
    id: 'thiruvananthapuram',
    nameEn: 'Thiruvananthapuram',
    nameMl: 'തിരുവനന്തപുരം',
    primaryCrops: ['Coconut', 'Tapioca', 'Rubber', 'Banana', 'Vegetables'],
  ),
];
