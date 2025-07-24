import 'package:first_flutter_app/data/constants.dart';
import 'package:first_flutter_app/data/notifiers.dart';
import 'package:first_flutter_app/views/pages/cart_page.dart';
import 'package:first_flutter_app/views/pages/categories_page.dart';
import 'package:first_flutter_app/views/pages/home_page.dart';
import 'package:first_flutter_app/views/pages/products_page.dart';
import 'package:first_flutter_app/views/pages/profile_page.dart';
import 'package:first_flutter_app/views/pages/settings_page.dart';
import 'package:first_flutter_app/views/widget/cart_icon_with_badge.dart';
import 'package:first_flutter_app/views/widget/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Widget> pages = [
  const HomePage(),
  const CategoriesPage(),
  const ProductsPage(),
  const ProfilePage(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Tree Example'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (builder, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
              },
            ),
            onPressed: () async {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setBool(
                KConstants.themeModeKey,
                isDarkModeNotifier.value,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SettingsPage(title: 'Settings');
                  },
                ),
              );
            },
          ),
          CartIconWithBadge(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
