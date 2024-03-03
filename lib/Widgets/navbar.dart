import 'dart:developer';

import 'package:CompanyDatabase/Pages/CreatePage.dart';
import 'package:CompanyDatabase/Pages/DeletePage.dart';
import 'package:CompanyDatabase/Pages/HomePage.dart';
import 'package:CompanyDatabase/Pages/update_profile.dart';
import 'package:CompanyDatabase/Provider/selected_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class YourBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedIndexProvider =
        Provider.of<SelectedPageIndexProvider>(context);

    return GNav(
      onTabChange: (value) {
        selectedIndexProvider.updateSelectedIndex(value);
        log(value.toString());
        log(selectedIndexProvider.selectedIndex.toString());

        if (value == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreatePage()));
        } else if (value == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else if (value == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeleteEmployee(),
            ),
          );
        }
      },
      backgroundColor: const Color(0xff434cab),
      rippleColor: Colors.grey[800] as Color,
      hoverColor: Colors.grey[700] as Color,
      haptic: true,
      selectedIndex: selectedIndexProvider.selectedIndex,
      tabBorderRadius: 25,
      tabMargin: const EdgeInsets.all(12),
      curve: Curves.easeOutExpo,
      duration: const Duration(milliseconds: 100),
      gap: 2,
      color: Colors.white,
      activeColor: Colors.black,
      iconSize: 20,
      tabBackgroundColor: const Color(0xFFBBF246),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      tabs: [
        const GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        const GButton(
          icon: Icons.add,
          text: 'Add',
        ),
        const GButton(
          icon: Icons.delete,
          text: 'Delete',
        ),
      ],
    );
  }
}
