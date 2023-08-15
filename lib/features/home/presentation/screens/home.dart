import 'package:batnf/constants.dart/app_colors.dart';
import 'package:batnf/features/home/data/projects/controller/home_screen_controller.dart';
import 'package:batnf/features/home/presentation/screens/events_screen.dart';
import 'package:batnf/features/home/presentation/screens/media_center_screen.dart';
import 'package:batnf/features/home/presentation/screens/project_screen.dart';
import 'package:batnf/features/home/presentation/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static const List<Widget> _widgetOptions = <Widget>[
    // HomePage(),
    HomeDashboard(),
    ProjectScreen(),
    EventsScreen(),
    MediaCenterScreen(),
  ];

final controller = Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final differeance = DateTime.now().difference(timeBackPressed);
        timeBackPressed = DateTime.now();
        if (differeance >= const Duration(seconds: 2)) {
          const String msg = 'Press the back button to exit';
          Fluttertoast.showToast(
            msg: msg,
          );
          return false;
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();
          return true;
        }
      },
      child: GetBuilder<HomeScreenController>(
        init: HomeScreenController(),
          builder: (controller){
        return Scaffold(
          backgroundColor: Colors.white,
          body: _widgetOptions.elementAt(controller.selectedIndex),
          bottomNavigationBar: SizedBox(height: 80,
            child: BottomNavigationBar(elevation: 0.0,
              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.primary),
              selectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.primary),
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.home, size: 20,),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.airpod, size: 20,),
                  label: 'Projects',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.calendar, size: 20,),
                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Iconsax.camera, size: 20,),
                  label: 'Media centre',
                ),
              ],
              currentIndex: controller.selectedIndex,
              selectedItemColor: AppColors.primary,
              onTap: controller.onItemTapped,
            ),
          ),
        );
      }),
    );
  }
}
