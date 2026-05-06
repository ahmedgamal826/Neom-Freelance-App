/// One leader row for the NEOM Leaders grid (bilingual copy).
class NeomLeaderEntry {
  const NeomLeaderEntry({
    required this.image,
    required this.nameAr,
    required this.nameEn,
    required this.titleAr,
    required this.titleEn,
  });

  final String image;
  final String nameAr;
  final String nameEn;
  final String titleAr;
  final String titleEn;

  String name(bool isArabic) => isArabic ? nameAr : nameEn;
  String title(bool isArabic) => isArabic ? titleAr : titleEn;
}

/// Order matches the previous UI grid.
const List<NeomLeaderEntry> kNeomLeaders = [
  NeomLeaderEntry(
    image: 'assets/images/ayman.jpg',
    nameAr: 'أيمن بن محمد المديفر',
    nameEn: 'Ayman bin Mohammed Al-Mudaifer',
    titleAr: 'عضو مجلس الإدارة والعضو المنتدب والرئيس التنفيذي',
    titleEn: 'Board Member, Managing Director and Chief Executive Officer',
  ),
  NeomLeaderEntry(
    image: 'assets/images/rean.png',
    nameAr: 'ريان فايز',
    nameEn: 'Rayyan Fayez',
    titleAr: 'نائب الرئيس التنفيذي',
    titleEn: 'Deputy Chief Executive Officer',
  ),
  NeomLeaderEntry(
    image: 'assets/images/jassir.jpg',
    nameAr: 'جاسر الجاسر',
    nameEn: 'Jasser Al-Jasser',
    titleAr: 'كبير التنفيذيين للحوكمة والمخاطر والالتزام',
    titleEn: 'Chief Governance, Risk and Compliance Officer',
  ),
  NeomLeaderEntry(
    image: 'assets/images/manar.jpg',
    nameAr: 'د. منار المنيف',
    nameEn: 'Dr. Manar Al Moneef',
    titleAr: 'كبيرة التنفيذيين للاستثمار',
    titleEn: 'Chief Investment Officer',
  ),
  NeomLeaderEntry(
    image: 'assets/images/mahmoudyamni.webp',
    nameAr: 'د. محمود اليماني',
    nameEn: 'Dr. Mahmoud Al-Yamani',
    titleAr: 'رئيس قطاع الصحة والرفاهية',
    titleEn: 'Head of Health and Well-being Sector',
  ),
  NeomLeaderEntry(
    image: 'assets/images/nader-ashoor.jpg',
    nameAr: 'نادر عاشور',
    nameEn: 'Nader Ashoor',
    titleAr: 'كبير التنفيذيين للشؤون المالية',
    titleEn: 'Chief Financial Officer',
  ),
  NeomLeaderEntry(
    image: 'assets/images/Niall-Gibbons.jpg',
    nameAr: 'نيال غيبونز',
    nameEn: 'Niall Gibbons',
    titleAr: 'رئيس قطاع السياحة',
    titleEn: 'Head of Tourism Sector',
  ),
  NeomLeaderEntry(
    image: 'assets/images/DenisHickey.jpg',
    nameAr: 'دينيس هيكي',
    nameEn: 'Denis Hickey',
    titleAr: 'كبير التنفيذيين للتطوير',
    titleEn: 'Chief Development Officer',
  ),
  NeomLeaderEntry(
    image: 'assets/images/Paul-Marshall_AYF03551.webp',
    nameAr: 'د. بول مارشال',
    nameEn: 'Dr. Paul Marshall',
    titleAr: 'رئيس قسم الطبيعة',
    titleEn: 'Head of Nature',
  ),
  NeomLeaderEntry(
    image: 'assets/images/Majid Mufti_09.2025.jpg',
    nameAr: 'ماجد مفتي',
    nameEn: 'Majid Mufti',
    titleAr: 'الرئيس التنفيذي لصندوق نيوم للاستثمار',
    titleEn: 'Chief Executive Officer, NEOM Investment Fund',
  ),
  NeomLeaderEntry(
    image: 'assets/images/jordi-naval-leader.jpg',
    nameAr: 'جوردي نافال',
    nameEn: 'Jordi Naval',
    titleAr: 'رئيس قطاع التقنيات الحيوية',
    titleEn: 'Head of Biotechnology Sector',
  ),
  NeomLeaderEntry(
    image: 'assets/images/stefan-ricketts-v2.webp',
    nameAr: 'ستيفان ريكيتس',
    nameEn: 'Stefan Ricketts',
    titleAr: 'كبير التنفيذيين للشؤون القانونية',
    titleEn: 'Chief Legal Officer',
  ),
  NeomLeaderEntry(
    image: 'assets/images/Vishal-Wanchoo_AYF02431-1.webp',
    nameAr: 'فيشال وانشو',
    nameEn: 'Vishal Wanchoo',
    titleAr: 'الرئيس التنفيذي لأوكساجون',
    titleEn: 'Chief Executive Officer, OXAGON',
  ),
  NeomLeaderEntry(
    image: 'assets/images/PeterTerium.jpg',
    nameAr: 'بيتر تيريم',
    nameEn: 'Peter Terium',
    titleAr: 'رئيس قطاع الطاقة',
    titleEn: 'Head of Energy Sector',
  ),
  NeomLeaderEntry(
    image: 'assets/images/Michael-Young-2025.jpg',
    nameAr: 'مايكل ك. يونغ',
    nameEn: 'Michael K. Young',
    titleAr: 'مستشار قطاع التعليم والبحث والابتكار',
    titleEn: 'Advisor, Education, Research and Innovation Sector',
  ),
];
