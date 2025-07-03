
// ignore_for_file: unused_label, unused_import

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:servable/Inbox/inbox.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/customer_view/maincategoriesscreen.dart';
import 'package:servable/customer_view/notifcationns.dart';
import 'package:servable/customer_view/services.dart';
// import 'package:servable/service_providers/worker_account.dart';
import 'package:servable/theme_provider/themeprovider.dart';



class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<Widget> _pages = [
    Maincategoriesscreen()
    // Services(),
    // Inbox(),
    // Notifcationns(),
    // CustomerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<Themeprovider>(context);

    return WillPopScope(
      onWillPop: ()async{
        if(Platform.isAndroid){
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(

        body: Consumer<TabBarProvider>(
          builder: (context, tabbarprovider, child) {
            return IndexedStack(
              index: tabbarprovider.selectedIndex,
              children: _pages,
            );
          },
        ),
        bottomNavigationBar: Consumer<TabBarProvider>(
          builder: (context, tabbarprovider, child) {

             return BottomNavigationBar(
  currentIndex: 0,
  type: BottomNavigationBarType.fixed,
  backgroundColor: themeprovider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
 selectedItemColor: Colors.teal,
  unselectedItemColor: Colors.grey,
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined, size: 30),
      activeIcon: Icon(Icons.home_rounded, size: 30),
      label: 'Homescreen',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.message_outlined, size: 30),
      activeIcon: Icon(Icons.message_rounded, size: 30),
      label: 'Inbox',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.notifications_outlined, size: 30),
    //   activeIcon: Icon(Icons.notifications, size: 30),
    //   label: 'Notifications',
    // ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined, size: 30),
      activeIcon: Icon(Icons.account_circle, size: 30),
      label: 'Profile',
    ),
  ],
  onTap: (index) {
    tabbarprovider.changeIndex(index); // Update tab index

    // Optional: if you still want to navigate on tap instead of switching tab
    switch (index) {
       case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homescreen()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Inbox()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfileScreen()));
        break;
      // case 3:
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfileScreen()));
      //   break;
    }
  },
);


          },
        ),
      ),
    );
  }
}