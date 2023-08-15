import 'package:batnf/constants.dart/app_colors.dart';
import 'package:batnf/features/authentication/presentation/Screens/login_screen.dart';
import 'package:batnf/features/home/presentation/screens/feed_back.dart';
import 'package:batnf/features/home/presentation/widgets/menu_item.dart';
import 'package:batnf/features/home/presentation/widgets/progress_indicator.dart';
import 'package:batnf/router/routes.dart';
import 'package:batnf/universal.dart/image_widget.dart';
import 'package:batnf/universal.dart/text_widget.dart';
import 'package:batnf/utilities/local_session_manager/local_session_manager.dart';
import 'package:clean_dialog/clean_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool light = true;
  bool? checkBoxValueOne = false;
  bool? checkBoxValueTwo = false;

  showAlertDialog(){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Log Out',
        content: "Are you sure you want to log out of BAT Foundation (App)?",
        backgroundColor: AppColors.primary,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Confirm',
              textColor: AppColors.primary,
              onPressed: (){
                Navigator.pop(context);
                progressIndicator(context);
                LocalSessionManager localSessionManager = LocalSessionManager();
                Future.delayed(const Duration(seconds: 5), (){
                  Get.back();
                  Get.offUntil( MaterialPageRoute(builder: (BuildContext context)=> const LoginScreen()), (route) => false);
                  localSessionManager.authStatusVal = false;
                });
              }
          ),
          CleanDialogActionButtons(
              actionTitle: 'Cancel',
              textColor: Colors.red,
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const ImageWidget(
                        name: "close.png",
                      ),
                    )
                  ],
                ),
              ),
              // MenuItem(
              //   label: "Change Theme",
              //   icon: SizedBox(
              //     height: 20,
              //     width: 38,
              //     child: FlutterSwitch(
              //       width: 125.0,
              //       height: 55.0,
              //       valueFontSize: 25.0,
              //       toggleSize: 13.0,
              //       inactiveToggleColor: const Color.fromARGB(255, 205, 0, 0),
              //       activeColor: const Color(0xFF232323),
              //       inactiveColor: const Color(0xFFD9D9D9),
              //       inactiveSwitchBorder: Border.all(
              //         color: const Color(0xFF868FAD),
              //       ),
              //       toggleBorder: Border.all(
              //           color: const Color.fromARGB(255, 255, 255, 255),
              //           width: 9),
              //       value: light,
              //       borderRadius: 10.0,
              //       padding: 2.0,
              //       onToggle: (val) {
              //         setState(() {
              //           light = val;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, Routes.forgotPassword);
                },
                child: const MenuItem(
                  label: "Change Password",
                  icon: ImageWidget(
                    name: "password_icon.png",
                    width: 30,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.contactUs);
                },
                child: const MenuItem(
                  label: "Contact Us",
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 30,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeedBackScreen()));
                },
                child: const MenuItem(
                  label: "Feedback",
                  icon: ImageWidget(
                    name: "feedback.png",
                    width: 30,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  showAlertDialog();
                },
                child: const MenuItem(
                  label: "Logout ",
                  icon: ImageWidget(
                    name: "logout.png",
                    width: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Expanded(
                    child: TextWidget(
                        fontSize: 14,
                        text:
                            "To receive our quarterly updates with your \nemail address, sign up for our newsletter."),
                  ),
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                        side: const BorderSide(width: 1, color: Colors.grey),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        value: checkBoxValueOne,
                        onChanged: (val) {
                          setState(() {
                            checkBoxValueOne = val;
                          });
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
