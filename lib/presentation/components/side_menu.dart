import 'package:admin_simpass/globals/constants.dart';
import 'package:admin_simpass/presentation/components/clickable_logo.dart';
import 'package:admin_simpass/providers/menu_navigation_provider.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:flutter/material.dart';
import 'package:admin_simpass/presentation/components/side_menu_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    //checking user roles from myinfoprovider
    final myInfoProvider = Provider.of<MyinfoProvifer>(context, listen: false);
    List<String> myRoles = myInfoProvider.myRoles;

    return Drawer(
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.black,
      // width: 500,
      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
      child: Consumer<MenuIndexProvider>(
        builder: (context, value, child) {
          return ListView(
            children: [
              InkWell(
                onTap: () {
                  context.go('/profile');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  alignment: Alignment.topLeft,
                  child: const ClickableLogo(
                    height: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              SideMenuWidget(
                title: "나의 정보",
                iconSrc: "assets/icons/user.svg",
                press: () {
                  context.go('/profile');
                },
                isSelected: value.openSideMenuIndex == 0,
              ),
              if (myRoles.any((role) => rolePathAccessInfo['/manage-users']!.contains(role)))
                SideMenuWidget(
                  title: "사용자 관리",
                  iconSrc: "assets/icons/admin.svg",
                  press: () {
                    context.go('/manage-users');
                  },
                  isSelected: value.openSideMenuIndex == 1,
                ),
              if (myRoles.any((role) => rolePathAccessInfo['/manage-plans']!.contains(role)))
                SideMenuWidget(
                  title: "요금제 관리",
                  iconSrc: "assets/icons/plans.svg",
                  press: () {
                    context.go('/manage-plans');
                  },
                  isSelected: value.openSideMenuIndex == 2,
                ),
              if (myRoles.any((role) => rolePathAccessInfo['/applications']!.contains(role)))
                SideMenuWidget(
                  title: "신청서 접수현황",
                  iconSrc: "assets/icons/regis.svg",
                  press: () {
                    context.go('/applications');
                  },
                  isSelected: value.openSideMenuIndex == 3,
                ),
              if (myRoles.any((role) => rolePathAccessInfo['/retailers']!.contains(role)))
                SideMenuWidget(
                  title: "판매점 계약현황",
                  iconSrc: "assets/icons/partner.svg",
                  press: () {
                    context.go('/retailers');
                  },
                  isSelected: value.openSideMenuIndex == 4,
                ),
              SideMenuWidget(
                title: "상담사 개통 문의현황",
                iconSrc: "assets/icons/call.svg",
                press: () {
                  context.go('/customer-requests');
                },
                isSelected: value.openSideMenuIndex == 5,
              ),
            ],
          );
        },
      ),
    );
  }
}
