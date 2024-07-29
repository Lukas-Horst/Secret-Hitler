// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/account/account_page.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/homepage.dart';
import 'package:secret_hitler/frontend/pages/home/settings/settings_page.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/bottom_navigation_bar.dart';


class PageNavigation extends ConsumerStatefulWidget {

  final int? startPage;

  const PageNavigation({super.key, this.startPage});

  @override
  ConsumerState<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends ConsumerState<PageNavigation> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const Account(),
    const Settings(),
  ];

  @override
  void initState() {
    // Change the start page if we have a correct index
    if (widget.startPage == 1 || widget.startPage == 2) {
      _selectedIndex = widget.startPage!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didpop) async {
          if (!didpop) {}
        },
      child: Scaffold(
        backgroundColor: const Color(0xFF474747),
        body: _pages[_selectedIndex],
        bottomNavigationBar: CustomBottomNavigationBar(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: ScreenSize.screenWidth * 0.9,
              height: ScreenSize.screenHeight * 0.06,
              child: GNav(
                iconSize: ScreenSize.screenHeight * 0.08 +
                    ScreenSize.screenWidth * 0.08,
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 0.5),
                duration: const Duration(milliseconds: 300),
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: AppDesign.getPrimaryColor(),
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                tabs: const [
                  GButton(
                    icon: Icons.home,
                  ),
                  GButton(
                    icon: Icons.person,
                  ),
                  GButton(
                    icon: Icons.settings,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
