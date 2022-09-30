import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isSplash == 1 ? Scaffold(
        drawer: Drawer(
          child: MainDrawerWidget(),
          elevation: 0,
        ),
        body: controller.currentPage,
        bottomNavigationBar: CustomBottomNavigationBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          itemColor: context.theme.colorScheme.secondary,
          currentIndex: controller.currentIndex.value,
          onChange: (index) {
            controller.changePage(index);
          },
          children: [
            CustomBottomNavigationItem(
              icon: Icons.home_outlined,
              label: "Home".tr,
            ),
            CustomBottomNavigationItem(
              icon: Icons.assignment_outlined,
              label: "Bookings".tr,
            ),
            CustomBottomNavigationItem(
              icon: Icons.chat_outlined,
              label: "Chats".tr,
            ),
            CustomBottomNavigationItem(
              icon: Icons.person_outline,
              label: "Account".tr,
            ),
          ],
        ),
      ) : Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icon/icon.png', height: 100, width: 100),
                  Container(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Text(
                      "One app for all your daily needs",
                      style: new TextStyle(
                        fontSize: 17.0,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Text(
                      "",
                      style: new TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              )),
            );
    });
  }
}
