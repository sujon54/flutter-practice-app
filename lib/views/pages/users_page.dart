import 'package:first_flutter_app/data/providers/auth_provider.dart';
import 'package:first_flutter_app/data/providers/dashboard_provider.dart';
import 'package:first_flutter_app/data/services/dashboard_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  String? token;
  bool isLoading = false;

  void _deleteUser(int id) async {
    final token = ref.read(authTokenProvider) ?? '';

    setState(() {
      isLoading = true;
    });

    try {
      http.Response response = await DashboardApi.deleteUser(token, id);

      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('User deleted')));
        setState(() {}); // Refresh list
        // ignore: unused_result
        ref.refresh(dashboardUserProvider);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _confirmDeleteUser(int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this user?'),
                Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _deleteUser(userId); // Trigger delete
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(dashboardUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user.name[0].toUpperCase())),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteUser(user.id),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
