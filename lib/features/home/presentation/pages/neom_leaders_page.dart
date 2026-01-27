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
  final String jobTitle;
  final String image;

  Person({
    required this.name,
    required this.jobTitle,
    required this.image,
  });
}

class PeopleGrid extends StatelessWidget {
  final List<Person> people = [
    Person(
        name: "نظمي النصر",
        jobTitle: "الرئيس التنفيذي، نيوم",
        image: "assets/images/board1.jpg"),
    Person(
        name: "ديرك فان شيبندوم",
        jobTitle: "المدير المالي، نيوم",
        image: "assets/images/board2.jpg"),
    Person(
        name: "بيتر تيريوم",
        jobTitle: "الرئيس التنفيذي، إينوا",
        image: "assets/images/board3.jpg"),
    Person(
        name: "أحمد الزهراني",
        jobTitle: "مساعد وزير، وزارة الطاقة",
        image: "assets/images/board4.jpg"),
    Person(
        name: "أحمد الخويطر",
        jobTitle: "الرئيس التقني، أرامكو",
        image: "assets/images/board5.jpg"),
    Person(
        name: "محمد السديس",
        jobTitle:
            "نائب الرئيس الأول، قسم الاستثمارات العقارية المحلية، صندوق الاستثمارات العامة",
        image: "assets/images/board6.png"),
  ];

  PeopleGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        childAspectRatio: 3 / 4, // Aspect ratio of each item
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
              ),
              const SizedBox(height: 5),
              Text(
                person.jobTitle,
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
