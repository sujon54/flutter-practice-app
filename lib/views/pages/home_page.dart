import 'package:first_flutter_app/data/constants.dart';
import 'package:first_flutter_app/views/pages/course_page.dart';
import 'package:first_flutter_app/views/widget/container_widget.dart';
import 'package:first_flutter_app/views/widget/hero_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> items = [
      KValues.appName,
      KValues.welcomeMessage,
      KValues.loginButtonText,
      KValues.registerButtonText,
      KValues.getStartedButtonText,
    ];
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            HeroWidget(title: 'Sazzad', nextPage: CoursePage()),
            SizedBox(height:10.0),
            ...List.generate(
              items.length,
              (index) => ContainerWidget(
                title: items[index],
                description: 'This is a description for container $index.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
