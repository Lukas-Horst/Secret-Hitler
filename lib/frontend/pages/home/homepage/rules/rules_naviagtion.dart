// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_page_1.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_page_2.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_page_3.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_page_4.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_page_5.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_page_6.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/rules/rules_page_7.dart';
import 'package:secret_hitler/frontend/widgets/components/bottom_navigation_bar.dart';
import 'package:secret_hitler/frontend/widgets/components/buttons.dart';
import 'package:secret_hitler/frontend/widgets/header/header.dart';

class RulesNavigation extends StatefulWidget {
  const RulesNavigation({super.key});

  @override
  State<RulesNavigation> createState() => _RulesNavigationState();
}

class _RulesNavigationState extends State<RulesNavigation> {

  int _currentPage = 6;

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  final List<Widget> _pages = [
    const RulesPage1(),
    const RulesPage2(),
    const RulesPage3(),
    const RulesPage4(),
    const RulesPage5(),
    const RulesPage6(),
    const RulesPage7(),
  ];

  void changePage(int pageNumber) {
    setState(() {
      _currentPage = pageNumber;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBack(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF474747),
          body: Column(
            children: [
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              Header(headerText: AppLanguage.getLanguageData()['Rules'] +
                  '\n(${_currentPage + 1}/7)'),
              SizedBox(height: ScreenSize.screenHeight * 0.02),
              _pages[_currentPage],
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavigationBackButton(onPressed: () {
                goBack(context);
              }),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: ScreenSize.screenWidth * 0.05),
                  child: SizedBox(
                    width: ScreenSize.screenWidth * 0.45,
                    child: Pagination(
                      pages: 7,
                      fontSize: ScreenSize.screenHeight * 0.03 +
                          ScreenSize.screenWidth * 0.03,
                      textColor: AppDesign.getContraryPrimaryColor(),
                      pageChange: changePage,
                      startIndex: 6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
