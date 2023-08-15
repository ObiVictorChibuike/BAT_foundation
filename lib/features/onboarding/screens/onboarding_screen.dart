import 'package:batnf/features/onboarding/widgets/onboarding_page.dart';
import 'package:batnf/router/routes.dart';
import 'package:batnf/universal.dart/main_btn.dart';
import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController;
  // ignore: unused_field
  int _currentPage = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      OnboardingPageWidget(
        image: "assets/images/onboarding1.png",
        title: "Attend our events",
        description: "Keep up to date with our events as they happen. Don't forget to register so that you can be part of our stories as we continue to make a difference.",
        pageController: pageController,
        currentPage: _currentPage,
      ),
       OnboardingPageWidget(
        image: "assets/images/onboarding3.png",
        title: "News Updates",
        description: "Get live updates on the foundation's activities, press statements, news articles, videos and photos.",
        pageController: pageController,
        currentPage: _currentPage,
      ),
       OnboardingPageWidget(
        image: "assets/images/onboarding4.png",
        title: "Explore our projects",
        description: "Our agricultural initiatives are aimed at empowering small holder farmers to "
            "improve their productivity and help build their capacity to establish viable agricultural enterprises. ",
         pageController: pageController,
         currentPage: _currentPage,
      ),
    ];
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
        ],
      ),
    );
  }
}
