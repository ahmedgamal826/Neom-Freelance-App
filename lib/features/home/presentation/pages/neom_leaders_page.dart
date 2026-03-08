//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports

class NeomLeadersPage extends StatelessWidget {
  // SECTION - Widget Arguments
  //!SECTION
  //
  const NeomLeadersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // SECTION - Build Setup
    // Values
    // double w = MediaQuery.of(context).size.width;",
    // double h = MediaQuery.of(context).size.height;",
    // Widgets
    //
    // Widgets
    //!SECTION

    // SECTION - Build Return
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 30,
            color: const Color(0xffEC796C),
          ),
          Flexible(child: PeopleGrid()),
          Container(
            width: double.infinity,
            height: 30,
            color: const Color(0xff606060),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Text(
              "أكبر مشروع في العالم يحتاج إلى بعض من أكثر الأشخاص موهبة في العالم. "
              "لهذا السبب يتكون فريق قيادة نيوم من مبتكرين ورؤيويين "
              "يعملون بطريقة مختلفة.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.5,
                color: Colors.grey[700], // Text color styling
              ),
            ),
          ),
        ],
      ),
    );

    //!SECTION
  }
}

class Person {
  final String name;
  final String? jobTitle;
  final String image;

  Person({
    required this.name,
    this.jobTitle,
    required this.image,
  });
}

class PeopleGrid extends StatelessWidget {
  final List<Person> people = [
    Person(
      name: "أيمن بن محمد المديفر",
      jobTitle: "عضو مجلس الإدارة والعضو المنتدب والرئيس التنفيذي",
      image: "assets/images/ayman.jpg",
    ),
    Person(
      name: "ريان فايز",
      jobTitle: "نائب الرئيس التنفيذي",
      image: "assets/images/rean.png",
    ),
    Person(
      name: "جاسر الجاسر",
      jobTitle: "كبير التنفيذيين للحوكمة والمخاطر والالتزام",
      image: "assets/images/jassir.jpg",
    ),
    Person(
      name: "د. منار المنيف",
      jobTitle: "كبيرة التنفيذيين للاستثمار",
      image: "assets/images/manar.jpg",
    ),
    Person(
      name: "د. محمود اليماني",
      jobTitle: "رئيس قطاع الصحة والرفاهية",
      image: "assets/images/mahmoudyamni.webp",
    ),
    Person(
      name: "نادر عاشور",
      jobTitle: "كبير التنفيذيين للشؤون المالية",
      image: "assets/images/nader-ashoor.jpg",
    ),
    Person(
      name: "نيال غيبونز",
      jobTitle: "رئيس قطاع السياحة",
      image: "assets/images/Niall-Gibbons.jpg",
    ),
    Person(
      name: "دينيس هيكي",
      jobTitle: "كبير التنفيذيين للتطوير",
      image: "assets/images/DenisHickey.jpg",
    ),
    Person(
      name: "د. بول مارشال",
      jobTitle: "رئيس قسم الطبيعة",
      image: "assets/images/Paul-Marshall_AYF03551.webp",
    ),
    Person(
      name: "ماجد مفتي",
      jobTitle: "الرئيس التنفيذي لصندوق نيوم للاستثمار",
      image: "assets/images/Majid Mufti_09.2025.jpg",
    ),
    Person(
      name: "جوردي نافال",
      jobTitle: "رئيس قطاع التقنيات الحيوية",
      image: "assets/images/jordi-naval-leader.jpg",
    ),
    Person(
      name: "ستيفان ريكيتس",
      jobTitle: "كبير التنفيذيين للشؤون القانونية",
      image: "assets/images/stefan-ricketts-v2.webp",
    ),
    Person(
      name: "فيشال وانشو",
      jobTitle: "الرئيس التنفيذي لأوكساجون",
      image: "assets/images/Vishal-Wanchoo_AYF02431-1.webp",
    ),
    Person(
      name: "بيتر تيريم",
      jobTitle: "رئيس قطاع الطاقة",
      image: "assets/images/PeterTerium.jpg",
    ),
    Person(
      name: "مايكل ك. يونغ",
      jobTitle: "مستشار قطاع التعليم والبحث والابتكار",
      image: "assets/images/Michael-Young-2025.jpg",
    ),
  ];

  PeopleGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 1200
        ? 4
        : width >= 900
            ? 3
            : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: people.length,
      itemBuilder: (context, index) {
        final person = people[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                person.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                person.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              if (person.jobTitle != null &&
                  person.jobTitle!.trim().isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  person.jobTitle!,
                  style: TextStyle(color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
