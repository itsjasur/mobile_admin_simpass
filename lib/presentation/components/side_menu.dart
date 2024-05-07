import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/globals/global_keys.dart';
import 'package:admin_simpass/presentation/components/clickable_logo.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/providers/menu_navigation_provider.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:admin_simpass/presentation/components/side_menu_tile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyinfoProvifer>(
      builder: (context, myInfoProvider, child) => Drawer(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        // backgroundColor: Colors.black,
        // width: 500
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Consumer<MenuIndexProvider>(
                builder: (context, value, child) {
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      InkWell(
                        onTap: () async {
                          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

                          Future<void> showNotification() async {
                            var androidDetails = const AndroidNotificationDetails(
                              'channelId',
                              'channelName',
                              importance: Importance.max,
                              priority: Priority.high,
                            );

                            var generalNotificationDetails = NotificationDetails(android: androidDetails);
                            await flutterLocalNotificationsPlugin.show(
                              0,
                              'Test Title',
                              'This is the Notification Body',
                              generalNotificationDetails,
                            );
                          }

                          showNotification();
                          // context.go('/profile');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                          alignment: Alignment.topLeft,
                          child: const ClickableLogo(
                            height: 50,
                          ),
                        ),
                      ),
                      if (myInfoProvider.myName != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text(
                            "반갑습니다 ${myInfoProvider.myName ?? ""}!",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      SideMenuWidget(
                        title: "나의 정보",
                        iconSrc: "assets/icons/user.svg",
                        press: () {
                          rootScaffoldKey.currentState?.closeDrawer();
                          context.go('/profile');
                        },
                        isSelected: value.openSideMenuIndex == 0,
                      ),
                      if (myInfoProvider.myRoles.any((role) => rolePathAccessInfo['/manage-users']!.contains(role)))
                        SideMenuWidget(
                          title: "사용자 관리",
                          iconSrc: "assets/icons/admin.svg",
                          press: () {
                            rootScaffoldKey.currentState?.closeDrawer();
                            context.go('/manage-users');
                          },
                          isSelected: value.openSideMenuIndex == 1,
                        ),
                      if (myInfoProvider.myRoles.any((role) => rolePathAccessInfo['/manage-plans']!.contains(role)))
                        SideMenuWidget(
                          title: "요금제 관리",
                          iconSrc: "assets/icons/plans.svg",
                          press: () {
                            rootScaffoldKey.currentState?.closeDrawer();
                            context.go('/manage-plans');
                          },
                          isSelected: value.openSideMenuIndex == 2,
                        ),
                      if (myInfoProvider.myRoles.any((role) => rolePathAccessInfo['/applications']!.contains(role)))
                        SideMenuWidget(
                          title: "신청서 접수현황",
                          iconSrc: "assets/icons/regis.svg",
                          press: () {
                            rootScaffoldKey.currentState?.closeDrawer();
                            context.go('/applications');
                          },
                          isSelected: value.openSideMenuIndex == 3,
                        ),
                      if (myInfoProvider.myRoles.any((role) => rolePathAccessInfo['/retailers']!.contains(role)))
                        SideMenuWidget(
                          title: "판매점 계약현황",
                          iconSrc: "assets/icons/partner.svg",
                          press: () {
                            rootScaffoldKey.currentState?.closeDrawer();
                            context.go('/retailers');
                          },
                          isSelected: value.openSideMenuIndex == 4,
                        ),
                      SideMenuWidget(
                        title: "상담사 개통 문의현황",
                        iconSrc: "assets/icons/call.svg",
                        press: () {
                          rootScaffoldKey.currentState?.closeDrawer();
                          context.go('/customer-requests');
                        },
                        isSelected: value.openSideMenuIndex == 5,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: SideMenuWidget(
                title: "로그아웃",
                iconSrc: "assets/icons/call.svg",
                press: () async {
                  await Provider.of<AuthServiceProvider>(context, listen: false).loggedOut(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
