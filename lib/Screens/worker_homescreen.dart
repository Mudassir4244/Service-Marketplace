import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:servable/Inbox/inbox.dart';
import 'package:servable/customer_view/notifcationns.dart';
import 'package:servable/customer_view/services.dart';
import 'package:servable/service_providers/worker_account.dart';
import 'package:servable/theme_provider/themeprovider.dart';

class Workertabbar with ChangeNotifier {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  int get selectedIndex => _selectedIndex;
  PageController get pageController => _pageController;

  void changeIndex(int index) {
    _selectedIndex = index;
    _pageController.animateToPage(index, // ✅ Use animate for smooth transition
        duration: Duration(milliseconds: 300), curve: Curves.ease);
    notifyListeners(); // ✅ Notify UI updates
  }

  void updateFromPageView(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}

class WorkerHomescreen extends StatefulWidget {
  const WorkerHomescreen({super.key});

  @override
  _WorkerHomescreenState createState() => _WorkerHomescreenState();
}

class _WorkerHomescreenState extends State<WorkerHomescreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    return ChangeNotifierProvider(
      create: (_) => Workertabbar(),
      child: Consumer<Workertabbar>(
        builder: (context, workertabbar, child) {
          return WillPopScope(
            onWillPop: ()async{
              if(Platform.isAndroid){
                SystemNavigator.pop();
              }
              return false ; 
            },
            child: Scaffold(
              body: PageView(
                controller: workertabbar.pageController,
                onPageChanged: workertabbar.updateFromPageView, // ✅ Sync BottomNav when swiping
                children: [
                  Services(),
                  Inbox(),
                  Notifcationns(),
                  WorkerProfileScreen(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
              currentIndex: workertabbar.selectedIndex,
              unselectedItemColor: Colors.grey,
              selectedItemColor: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
              onTap: (index) {
                workertabbar.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(workertabbar.selectedIndex == 0 ? Icons.home : Icons.home_outlined),
                  label: 'WorkerHome',
                ),
                BottomNavigationBarItem(
                  icon: Icon(workertabbar.selectedIndex == 1 ? Icons.message : Icons.message_outlined),
                  label: 'Inbox',
                ),
                BottomNavigationBarItem(
                  icon: Icon(workertabbar.selectedIndex == 2 ? Icons.notifications : Icons.notifications_outlined),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(workertabbar.selectedIndex == 3 ? Icons.account_circle : Icons.account_circle_outlined),
                  label: 'Profile',
                ),
              ],
            ),
            
            ),
          );
        },
      ),
    );
  }
}
