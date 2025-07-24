import 'package:first_flutter_app/data/models/activity_class.dart';
import 'package:first_flutter_app/data/services/activity_api.dart';
import 'package:first_flutter_app/views/widget/hero_widget.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  Future<Activity>? futureActivity;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    futureActivity = ActivityApi.fetchRandomActivity();
  }

  void _fetchAnotherActivity() {
    setState(() {
      futureActivity = ActivityApi.fetchRandomActivity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isFirstLoad = !isFirstLoad;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Activity>(
        future: futureActivity,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No activity found'));
          }

          final activity = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: AnimatedCrossFade(
              firstChild: Column(
                children: [
                  const HeroWidget(title: 'Course'),
                  const SizedBox(height: 20.0),
                  Text(
                    'Activity: ${activity.activity}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Type: ${activity.type}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: _fetchAnotherActivity,
                    child: const Text('Fetch Another Activity'),
                  ),
                ],
              ),
              secondChild: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              crossFadeState: isFirstLoad
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(microseconds: 500),
            ),
          );
        },
      ),
    );
  }
}
