// ignore_for_file: unused_import, prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Inbox/inbox.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/customer_view/homescreen.dart';
import 'package:servable/customer_view/services.dart';
 
import 'package:servable/theme_provider/themeprovider.dart';
class Notifcationns extends StatefulWidget {
  const Notifcationns({super.key});

  @override
  State<Notifcationns> createState() => _NotifcationnsState();
}

class _NotifcationnsState extends State<Notifcationns> {
  @override
  Widget build(BuildContext context) {
   final  themeprovider = Provider.of<Themeprovider>(context);
   final tabbarprovider = Provider.of<TabBarProvider>(context);
    // final  imageprovider = Provider.of<ImagePickerProvider>(context); 
    return WillPopScope(
      onWillPop: ()async{
        if(Platform.isAndroid){
          tabbarprovider.changeIndex(0);
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen()));
                  }
        return true;

      },
      child: Scaffold(
          backgroundColor: themeprovider.themeMode==ThemeMode.dark?Colors.black:Colors.white,
         appBar: AppBar(
                 flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00A86B), Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
                iconTheme: IconThemeData(
                  color: Colors.white, // Change the color of the back button
                ),
                centerTitle: true,
                 title: Text("Notifications",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                         
                         ),
                            bottomNavigationBar: Consumer<TabBarProvider>(
            builder: (context, tabbarprovider, child) {
        
               return BottomNavigationBar(
        currentIndex: 2,
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
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications_outlined, size: 30),
        activeIcon: Icon(Icons.notifications, size: 30),
        label: 'Notifications',
      ),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => Notifcationns()));
          break;
        case 3:
          Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfileScreen()));
          break;
      }
        },
      );
      
             
            },
          ),
                        //  body: ,
            
           
      ),
    );
  }
}