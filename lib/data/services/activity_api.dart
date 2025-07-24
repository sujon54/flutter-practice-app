import 'dart:convert';
import 'package:first_flutter_app/data/models/activity_class.dart';
import 'package:http/http.dart' as http;

class ActivityApi {
  static Future<Activity> fetchRandomActivity() async {
    final url = Uri.https('bored-api.appbrewery.com', '/random');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load activity');
    }
  }
}
