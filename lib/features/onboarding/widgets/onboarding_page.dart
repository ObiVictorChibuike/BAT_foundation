import 'package:batnf/router/routes.dart';
import 'package:batnf/universal.dart/main_btn.dart';
import 'package:batnf/universal.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPageWidget extends StatelessWidget {
  const OnboardingPageWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.pageController,
    required this.currentPage,
  });

  final String image;
  final String title;
  final String description;
  final PageController pageController;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover, // You can choose how the image fits inside the container
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, right: 30),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, Routes.login);
                        },
                        child: const TextWidget(
                          text: "Skip",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 300,
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * .45,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: title,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextWidget(
                      text: description,
                      fontSize: 18,
                      textAlign: TextAlign.center,
                      color: const Color(0xFF6D6265),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    SmoothPageIndicator(controller: pageController, // PageController
                        count: 3, effect: const ExpandingDotsEffect(
                          dotHeight: 8, dotWidth: 8,
                          activeDotColor: Color.fromARGB(255, 8, 51, 121),
                        ), // your preferred effect
                        onDotClicked: (index) {}),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: MainButton(
                        label: currentPage == 2 ? "Get Started" : "Next",
                        onTap: () {
                          if (currentPage == 2) {
                            Navigator.pushReplacementNamed(context, Routes.login);
                            return;
                          }
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.decelerate);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
