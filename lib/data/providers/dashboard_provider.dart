import 'package:first_flutter_app/data/models/user.dart';
import 'package:first_flutter_app/data/providers/auth_provider.dart';
import 'package:first_flutter_app/data/services/dashboard_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final token = ref.watch(authTokenProvider);
  if (token == null) throw Exception('No token');
  return await DashboardApi.fetchDashboard(token);
});

final dashboardUserProvider = FutureProvider<List<User>>((ref) async {
  final token = ref.watch(authTokenProvider);
  if (token == null) throw Exception('No token');
  return await DashboardApi.fetchUsers(token);
});