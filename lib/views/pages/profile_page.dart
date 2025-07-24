import 'package:first_flutter_app/data/notifiers.dart';
import 'package:first_flutter_app/data/providers/auth_provider.dart';
import 'package:first_flutter_app/views/pages/dashboard_page.dart';
import 'package:first_flutter_app/views/pages/users_page.dart';
import 'package:first_flutter_app/views/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(localUserProvider);

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          CircleAvatar(child: Text(user?.name[0].toUpperCase() ?? '')),
          Text(user?.name ?? ''),
          SizedBox(height: 20.0),
          if (user?.role == 'admin')
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              },
            ),
          if (user?.role == 'admin')
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Users'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const UsersPage();
                    },
                  ),
                );
              },
            ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              logout();
              selectedPageNotifier.value = 0; // Reset to HomePage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return WelcomePage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    await AuthProvider.logout(ref);
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('auth_token');
  }
}
