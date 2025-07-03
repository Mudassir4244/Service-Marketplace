
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/Inbox/chatscreen.dart';
// import 'package:servable/customer_view/customer_profilescreen.dart';
// import 'package:servable/customer_view/homescreen.dart';
// import 'package:servable/customer_view/notifcationns.dart';
// import 'package:servable/customer_view/services.dart';
// import 'package:servable/customer_view/settings.dart';
// import 'package:servable/theme_provider/themeprovider.dart';

// class ChatSelectionProvider extends ChangeNotifier {
//   final Set<String> _selectedChatIds = {};
//   bool _isSelectionMode = false;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Set<String> get selectedChatIds => _selectedChatIds;
//   bool get isSelectionMode => _isSelectionMode;
//   int _selectedIndex = 0;

//   int get selectedIndex => _selectedIndex;

//   void changeIndex(int index) {
//     _selectedIndex = index;
//     notifyListeners();
//   }

//   void toggleSelection(String chatId) {
//     if (_selectedChatIds.contains(chatId)) {
//       _selectedChatIds.remove(chatId);
//     } else {
//       _selectedChatIds.add(chatId);
//     }
//     _isSelectionMode = _selectedChatIds.isNotEmpty;
//     notifyListeners();
//   }

//   void clearSelection() {
//     _selectedChatIds.clear();
//     _isSelectionMode = false;
//     notifyListeners();
//   }

//   Future<void> hideChats(Set<String> chatIds) async {
//     final userId = _auth.currentUser!.uid;
//     final hiddenChatsRef = _firestore.collection('Customers').doc(userId).collection('hiddenChats');

//     WriteBatch batch = _firestore.batch();
//     for (String chatId in chatIds) {
//       batch.set(
//         hiddenChatsRef.doc(chatId),
//         {
//           'chatId': chatId,
//           'hiddenAt': FieldValue.serverTimestamp(),
//         },
//         SetOptions(merge: true),
//       );
//     }
//     await batch.commit();
//     notifyListeners();
//   }

//   Stream<Set<String>> getHiddenChatIds() {
//     final userId = _auth.currentUser!.uid;
//     return _firestore
//         .collection('Customers')
//         .doc(userId)
//         .collection('hiddenChats')
//         .snapshots()
//         .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
//   }

//   Future<void> unhideChat(String chatId) async {
//     final userId = _auth.currentUser!.uid;
//     await _firestore
//         .collection('Customers')
//         .doc(userId)
//         .collection('hiddenChats')
//         .doc(chatId)
//         .delete();
//     notifyListeners();
//   }
// }

// class Inbox extends StatefulWidget {
//   final auth = FirebaseAuth.instance;
//   final CollectionReference chatsCollection = FirebaseFirestore.instance.collection('chats');

//   Inbox({super.key});

//   @override
//   State<Inbox> createState() => _InboxState();
// }

// class _InboxState extends State<Inbox> with SingleTickerProviderStateMixin {
//   final TextEditingController searchController = TextEditingController();
//   final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     searchController.dispose();
//     searchQuery.dispose();
//     super.dispose();
//   }

//   Future<void> deleteSelectedChats(BuildContext context) async {
//     final provider = Provider.of<ChatSelectionProvider>(context, listen: false);
//     await provider.hideChats(provider.selectedChatIds);
//     Fluttertoast.showToast(msg: 'Chats removed from your list');
//     provider.clearSelection();
//   }

//   String getOtherUserId(List participants) {
//     String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//     return participants.firstWhere((id) => id != currentUserId, orElse: () => 'Unknown');
//   }

//   String getDisplayName(Map<String, dynamic> data) {
//     String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//     String senderId = data['senderId'] ?? '';
//     String receiverId = data['receiverId'] ?? '';

//     if (senderId == currentUserId) {
//       return data['receiverName'] ?? 'No Name';
//     } else if (receiverId == currentUserId) {
//       return data['senderName'] ?? 'No Name';
//     }
//     return data['receiverName'] ?? data['senderName'] ?? 'No Name';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<Themeprovider>(context);
//     final customerProvider = Provider.of<CustomerProvider>(context);
//     final tabProvider = Provider.of<TabBarProvider>(context);
//     final isDark = themeProvider.themeMode == ThemeMode.dark;
//     final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
//     final textColor = isDark ? Colors.white : Colors.black87;

//     return Consumer<ChatSelectionProvider>(
//       builder: (context, selectionProvider, child) {
//         return WillPopScope(
//           onWillPop: () async {
//             if (Platform.isAndroid) {
//               tabProvider.changeIndex(0);
//               Navigator.push(context, MaterialPageRoute(builder: (context) => Homescreen()));
//             }
//             return true;
//           },
//           child: Scaffold(
//             backgroundColor: bgColor,
//             appBar: AppBar(
//               flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF00A86B), Colors.teal],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//               elevation: 0,
//               centerTitle: true,
//               iconTheme: const IconThemeData(color: Colors.white),
//               title: Text(
//                 selectionProvider.isSelectionMode
//                     ? '${selectionProvider.selectedChatIds.length} selected'
//                     : 'Inbox',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                   color: Colors.white,
//                 ),
//               ),
//               leading: selectionProvider.isSelectionMode
//                   ? IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () => selectionProvider.clearSelection(),
//                     )
//                   : Builder(
//                       builder: (context) => IconButton(
//                         icon: const Icon(Icons.menu, color: Colors.white),
//                         onPressed: () => Scaffold.of(context).openDrawer(),
//                       ),
//                     ),
//               actions: selectionProvider.isSelectionMode
//                   ? [
//                       IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.white),
//                         onPressed: () => deleteSelectedChats(context),
//                       ),
//                     ]
//                   : [
//                       IconButton(
//                         icon: const Icon(Icons.notifications, color: Colors.white),
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => Notifcationns()));
//                         },
//                       ),
//                     ],
//             ),
//             drawer: Drawer(
//     child: Container(
//       color: bgColor,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [const Color(0xFF00A86B), Colors.teal],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 35,
//                     backgroundColor: Colors.white,
//                     child: customerProvider.image != null
//                         ? ClipOval(
//                             child: Image.file(
//                               customerProvider.image!,
//                               fit: BoxFit.cover,
//                               width: 70,
//                               height: 70,
//                             ),
//                           )
//                         : Icon(
//                             Icons.person,
//                             size: 40,
//                             color: const Color(0xFF00A86B),
//                           ),
//                   ),
//                   SizedBox(height: 12),
//                   Text(
//                     customerProvider.userData?['name'] ?? 'Profile Name',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     customerProvider.userData?['email'] ?? '',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           _buildDrawerItem(
//             // context: context,
//             title: 'T H E M E',
//             icon: isDark ? Icons.light_mode : Icons.dark_mode,
//             textColor: textColor,
//             onTap: () => themeProvider.toggle_theme(),
//           ),
//           Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
//           _buildDrawerItem(
//             // context: context,
//             title: 'S E T T I N G S',
//             icon: Icons.settings_sharp,
//             textColor: textColor,
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => setting())),
//           ),
//           Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
//           _buildDrawerItem(
//             // context: context,
//             title: 'P R O F I L E',
//             icon: Icons.account_circle,
//             textColor: textColor,
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfileScreen())),
//           ),
//         ],
//       ),
//     ),
//   ),
//             bottomNavigationBar: Consumer<TabBarProvider>(
//               builder: (context, tabbarprovider, child) {
//                 return BottomNavigationBar(
//                   currentIndex: 1,
//                   type: BottomNavigationBarType.fixed,
//                   backgroundColor: isDark ? Colors.grey[900] : Colors.white,
//                   selectedItemColor: Colors.teal,
//                   unselectedItemColor: Colors.grey,
//                   selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
//                   items: [
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.home_outlined, size: 30),
//                       activeIcon: Icon(Icons.home_rounded, size: 30),
//                       label: 'Home',
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.message_outlined, size: 30),
//                       activeIcon: Icon(Icons.message_rounded, size: 30),
//                       label: 'Inbox',
//                     ),
//                     // BottomNavigationBarItem(
//                     //   icon: Icon(Icons.notifications_outlined, size: 30),
//                     //   activeIcon: Icon(Icons.notifications, size: 30),
//                     //   label: 'Notifications',
//                     // ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.account_circle_outlined, size: 30),
//                       activeIcon: Icon(Icons.account_circle, size: 30),
//                       label: 'Profile',
//                     ),
//                   ],
//                   onTap: (index) {
//                     tabbarprovider.changeIndex(index);
//                     switch (index) {
//                       case 0:
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => Homescreen()));
//                         break;
//                       case 1:
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => Inbox()));
//                         break;
                     
//                       case 2:
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfileScreen()));
//                         break;
//                     }
//                   },
//                 );
//               },
//             ),
//             body: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Column(
//                 children: [
//                   // Search Bar
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: isDark ? Colors.grey[850] : Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                           hintText: 'Search by name...',
//                           hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
//                           prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
//                           border: InputBorder.none,
//                         ),
//                         style: TextStyle(color: textColor),
//                         onChanged: (value) {
//                           searchQuery.value = value.toLowerCase();
//                         },
//                       ),
//                     ),
//                   ),
//                   // Chat List
//                   Expanded(
//                     child: StreamBuilder<Set<String>>(
//                       stream: selectionProvider.getHiddenChatIds(),
//                       builder: (context, hiddenSnapshot) {
//                         if (hiddenSnapshot.connectionState == ConnectionState.waiting) {
//                           return Center(child: CircularProgressIndicator(color: const Color(0xFF00A86B)));
//                         }
//                         final hiddenChatIds = hiddenSnapshot.data ?? {};

//                         return ValueListenableBuilder<String>(
//                           valueListenable: searchQuery,
//                           builder: (context, query, _) {
//                             return StreamBuilder<QuerySnapshot>(
//                               stream: widget.chatsCollection
//                                   .where('participants', arrayContains: widget.auth.currentUser!.uid)
//                                   .snapshots(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.connectionState == ConnectionState.waiting) {
//                                   return Center(child: CircularProgressIndicator(color: const Color(0xFF00A86B)));
//                                 }
//                                 if (snapshot.hasError) {
//                                   return Center(
//                                     child: Text(
//                                       'Error fetching chats',
//                                       style: TextStyle(color: textColor),
//                                     ),
//                                   );
//                                 }

//                                 final docs = snapshot.data!.docs;

//                                 final filteredDocs = docs.where((doc) {
//                                   final docId = doc.id;
//                                   if (hiddenChatIds.contains(docId)) {
//                                     return false;
//                                   }
//                                   final data = doc.data() as Map<String, dynamic>;
//                                   final displayName = getDisplayName(data).toLowerCase();
//                                   return displayName.contains(query);
//                                 }).toList();

//                                 if (filteredDocs.isEmpty) {
//                                   return Center(
//                                     child: Text(
//                                       'No matching chats found',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: isDark ? Colors.white70 : Colors.black54,
//                                       ),
//                                     ),
//                                   );
//                                 }

//                                 return ListView.builder(
//                                   itemCount: filteredDocs.length,
//                                   itemBuilder: (context, index) {
//                                     final doc = filteredDocs[index];
//                                     final data = doc.data() as Map<String, dynamic>;
//                                     final docId = doc.id;

//                                     final displayName = getDisplayName(data);
//                                     final lastMessage = data['lastMessage'] ?? 'No message';
//                                     final timestamp = data['timestamp'];
//                                     final formattedTime = timestamp is Timestamp
//                                         ? DateFormat('hh:mm a').format(timestamp.toDate())
//                                         : '';

//                                     final isSelected = selectionProvider.selectedChatIds.contains(docId);
//                                     final receiverUid = getOtherUserId(data['participants']);

//                                     return AnimatedContainer(
//                                       duration: Duration(milliseconds: 300),
//                                       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                       decoration: BoxDecoration(
//                                         color: isSelected
//                                             ? const Color(0xFF00A86B).withOpacity(0.2)
//                                             : isDark
//                                                 ? Colors.grey[900]
//                                                 : Colors.white,
//                                         borderRadius: BorderRadius.circular(12),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black.withOpacity(0.1),
//                                             blurRadius: 6,
//                                             offset: Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: ListTile(
//                                         contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                         onTap: () {
//                                           if (selectionProvider.isSelectionMode) {
//                                             selectionProvider.toggleSelection(docId);
//                                           } else {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => chatscreen(
//                                                   workers: {
//                                                     'uid': receiverUid,
//                                                     'name': displayName,
//                                                   },
//                                                 ),
//                                               ),
//                                             );
//                                           }
//                                         },
//                                         onLongPress: () => selectionProvider.toggleSelection(docId),
//                                         leading: CircleAvatar(
//                                           radius: 25,
//                                           backgroundColor: const Color(0xFF00A86B),
//                                           child: Icon(
//                                             Icons.person,
//                                             color: Colors.white,
//                                             size: 30,
//                                           ),
//                                         ),
//                                         title: Text(
//                                           displayName,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 16,
//                                             color: textColor,
//                                           ),
//                                         ),
//                                         subtitle: Text(
//                                           lastMessage,
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                             color: isDark ? Colors.white70 : Colors.black54,
//                                           ),
//                                         ),
//                                         trailing: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               formattedTime,
//                                               style: TextStyle(
//                                                 color: isDark ? Colors.white70 : Colors.black54,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                             if (isSelected)
//                                               Icon(
//                                                 Icons.check_circle,
//                                                 color: const Color(0xFF00A86B),
//                                                 size: 20,
//                                               ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDrawerItem({
//     required String title,
//     required IconData icon,
//     required Color textColor,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Row(
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//                 letterSpacing: 1.5,
//               ),
//             ),
//             Spacer(),
//             Icon(
//               icon,
//               color: textColor,
//               size: 28,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:servable/Inbox/chatscreen.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/customer_view/homescreen.dart';
import 'package:servable/customer_view/notifcationns.dart';
import 'package:servable/customer_view/services.dart';
import 'package:servable/customer_view/settings.dart';
import 'package:servable/theme_provider/themeprovider.dart';

// class LanguageProvider with ChangeNotifier {
//   String _language = 'en';

//   String get language => _language;
//   bool get isUrdu => _language == 'ur';

//   void toggleLanguage() {
//     _language = _language == 'en' ? 'ur' : 'en';
//     notifyListeners();
//   }
// }

class ChatSelectionProvider extends ChangeNotifier {
  final Set<String> _selectedChatIds = {};
  bool _isSelectionMode = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Set<String> get selectedChatIds => _selectedChatIds;
  bool get isSelectionMode => _isSelectionMode;
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void toggleSelection(String chatId) {
    if (_selectedChatIds.contains(chatId)) {
      _selectedChatIds.remove(chatId);
    } else {
      _selectedChatIds.add(chatId);
    }
    _isSelectionMode = _selectedChatIds.isNotEmpty;
    notifyListeners();
  }

  void clearSelection() {
    _selectedChatIds.clear();
    _isSelectionMode = false;
    notifyListeners();
  }

  Future<void> hideChats(Set<String> chatIds) async {
    final userId = _auth.currentUser!.uid;
    final hiddenChatsRef = _firestore.collection('Customers').doc(userId).collection('hiddenChats');

    WriteBatch batch = _firestore.batch();
    for (String chatId in chatIds) {
      batch.set(
        hiddenChatsRef.doc(chatId),
        {
          'chatId': chatId,
          'hiddenAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
    await batch.commit();
    notifyListeners();
  }

  Stream<Set<String>> getHiddenChatIds() {
    final userId = _auth.currentUser!.uid;
    return _firestore
        .collection('Customers')
        .doc(userId)
        .collection('hiddenChats')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }

  Future<void> unhideChat(String chatId) async {
    final userId = _auth.currentUser!.uid;
    await _firestore
        .collection('Customers')
        .doc(userId)
        .collection('hiddenChats')
        .doc(chatId)
        .delete();
    notifyListeners();
  }
}

class Inbox extends StatefulWidget {
  final auth = FirebaseAuth.instance;
  final CollectionReference chatsCollection = FirebaseFirestore.instance.collection('chats');

  Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'inbox': 'Inbox',
      'selected': 'selected',
      'searchHint': 'Search by name...',
      'noChatsFound': 'No matching chats found',
      'errorFetchingChats': 'Error fetching chats',
      'chatsRemoved': 'Chats removed from your list',
      'profileName': 'Profile Name',
      'theme': 'Theme',
      'settings': 'Settings',
      'profile': 'Profile',
      'language': 'Language',
      'home': 'Home',
      'inboxNav': 'Inbox',
      'profileNav': 'Profile',
    },
    'ur': {
      'inbox': 'ان باکس',
      'selected': 'منتخب شدہ',
      'searchHint': 'نام سے تلاش کریں...',
      'noChatsFound': 'کوئی مماثل چیٹس نہیں ملے',
      'errorFetchingChats': 'چیٹس حاصل کرنے میں خرابی',
      'chatsRemoved': 'چیٹس آپ کی فہرست سے ہٹائی گئیں',
      'profileName': 'پروفائل کا نام',
      'theme': 'تھیم',
      'settings': 'ترتیبات',
      'profile': 'پروفائل',
      'language': 'زبان',
      'home': 'ہوم',
      'inboxNav': 'ان باکس',
      'profileNav': 'پروفائل',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    searchQuery.dispose();
    super.dispose();
  }

  Future<void> deleteSelectedChats(BuildContext context, String language) async {
    final provider = Provider.of<ChatSelectionProvider>(context, listen: false);
    await provider.hideChats(provider.selectedChatIds);
    Fluttertoast.showToast(msg: _translate('chatsRemoved', language));
    provider.clearSelection();
  }

  String getOtherUserId(List participants) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return participants.firstWhere((id) => id != currentUserId, orElse: () => 'Unknown');
  }

  String getDisplayName(Map<String, dynamic> data) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    String senderId = data['senderId'] ?? '';
    String receiverId = data['receiverId'] ?? '';

    if (senderId == currentUserId) {
      return data['receiverName'] ?? 'No Name';
    } else if (receiverId == currentUserId) {
      return data['senderName'] ?? 'No Name';
    }
    return data['receiverName'] ?? data['senderName'] ?? 'No Name';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);
    final tabProvider = Provider.of<TabBarProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final isUrdu = languageProvider.isUrdu;
    final language = languageProvider.language;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Consumer<ChatSelectionProvider>(
      builder: (context, selectionProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            if (Platform.isAndroid) {
              tabProvider.changeIndex(0);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Homescreen()));
            }
            return true;
          },
          child: Scaffold(
            backgroundColor: bgColor,
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
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                selectionProvider.isSelectionMode
                    ? '${selectionProvider.selectedChatIds.length} ${_translate('selected', language)}'
                    : _translate('inbox', language),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                ),
                // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
              ),
              leading: selectionProvider.isSelectionMode
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => selectionProvider.clearSelection(),
                    )
                  : Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
              actions: selectionProvider.isSelectionMode
                  ? [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () => deleteSelectedChats(context, language),
                      ),
                    ]
                  : [
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.white),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Notifcationns()));
                        },
                      ),
                    ],
            ),
            drawer: Drawer(
              child: Container(
                color: bgColor,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [const Color(0xFF00A86B), Colors.teal],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: customerProvider.image != null
                                  ? ClipOval(
                                      child: Image.file(
                                        customerProvider.image!,
                                        fit: BoxFit.cover,
                                        width: 70,
                                        height: 70,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 40,
                                      color: const Color(0xFF00A86B),
                                    ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              customerProvider.userData?['name'] ?? _translate('profileName', language),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                              // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            Text(
                              customerProvider.userData?['email'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                              // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildDrawerItem(
                      context: context,
                      title: _translate('theme', language),
                      icon: isDark ? Icons.light_mode : Icons.dark_mode,
                      textColor: textColor,
                      onTap: () => themeProvider.toggle_theme(),
                    ),
                    Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
                    _buildDrawerItem(
                      context: context,
                      title: _translate('settings', language),
                      icon: Icons.settings_sharp,
                      textColor: textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => setting())),
                    ),
                    Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
                    _buildDrawerItem(
                      context: context,
                      title: _translate('profile', language),
                      icon: Icons.account_circle,
                      textColor: textColor,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfileScreen())),
                    ),
                    Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Text(
                            _translate('language', language),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              letterSpacing: 1.5,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                            // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                          ),
                          // EasyPaisa-styled toggle button
                          GestureDetector(
                            onTap: () {
                              languageProvider.toggleLanguage();
                            },
                            child: Container(
                              width: 80,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Color(0xFF00A86B), width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  AnimatedAlign(
                                    alignment: isUrdu ? Alignment.centerRight : Alignment.centerLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    child: Container(
                                      width: 40,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF00A86B),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'EN',
                                            style: TextStyle(
                                              color: isUrdu ? Colors.grey : Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'UR',
                                            style: TextStyle(
                                              color: isUrdu ? Colors.white : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Consumer<TabBarProvider>(
              builder: (context, tabbarprovider, child) {
                return BottomNavigationBar(
                  currentIndex: 1,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                  selectedItemColor: Colors.teal,
                  unselectedItemColor: Colors.grey,
                  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  items: [
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.home_outlined, size: 30),
                    //   activeIcon: Icon(Icons.home_rounded, size: 30),
                    //   label: _translate('home', language),
                    // ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.message_outlined, size: 30),
                    //   activeIcon: Icon(Icons.message_rounded, size: 30),
                    //   label: _translate('inboxNav', language),
                    // ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.account_circle_outlined, size: 30),
                    //   activeIcon: Icon(Icons.account_circle, size: 30),
                    //   label: _translate('profileNav', language),
                    // ),
                     BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined, size: 30),
                      activeIcon: Icon(Icons.home_rounded, size: 30),
                      label: 'Home',
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
                    tabbarprovider.changeIndex(index);
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
                    }
                  },
                );
              },
            ),
            body: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          hintText: _translate('searchHint', language),
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                          prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: textColor,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                        onChanged: (value) {
                          searchQuery.value = value.toLowerCase();
                        },
                        // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ),
                  ),
                  // Chat List
                  Expanded(
                    child: StreamBuilder<Set<String>>(
                      stream: selectionProvider.getHiddenChatIds(),
                      builder: (context, hiddenSnapshot) {
                        if (hiddenSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: const Color(0xFF00A86B)));
                        }
                        final hiddenChatIds = hiddenSnapshot.data ?? {};

                        return ValueListenableBuilder<String>(
                          valueListenable: searchQuery,
                          builder: (context, query, _) {
                            return StreamBuilder<QuerySnapshot>(
                              stream: widget.chatsCollection
                                  .where('participants', arrayContains: widget.auth.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator(color: const Color(0xFF00A86B)));
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      _translate('errorFetchingChats', language),
                                      style: TextStyle(
                                        color: textColor,
                                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                      ),
                                      // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                  );
                                }

                                final docs = snapshot.data!.docs;

                                final filteredDocs = docs.where((doc) {
                                  final docId = doc.id;
                                  if (hiddenChatIds.contains(docId)) {
                                    return false;
                                  }
                                  final data = doc.data() as Map<String, dynamic>;
                                  final displayName = getDisplayName(data).toLowerCase();
                                  return displayName.contains(query);
                                }).toList();

                                if (filteredDocs.isEmpty) {
                                  return Center(
                                    child: Text(
                                      _translate('noChatsFound', language),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isDark ? Colors.white70 : Colors.black54,
                                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                      ),
                                      // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: filteredDocs.length,
                                  itemBuilder: (context, index) {
                                    final doc = filteredDocs[index];
                                    final data = doc.data() as Map<String, dynamic>;
                                    final docId = doc.id;

                                    final displayName = getDisplayName(data);
                                    final lastMessage = data['lastMessage'] ?? 'No message';
                                    final timestamp = data['timestamp'];
                                    final formattedTime = timestamp is Timestamp
                                        ? DateFormat('hh:mm a').format(timestamp.toDate())
                                        : '';

                                    final isSelected = selectionProvider.selectedChatIds.contains(docId);
                                    final receiverUid = getOtherUserId(data['participants']);

                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF00A86B).withOpacity(0.2)
                                            : isDark
                                                ? Colors.grey[900]
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        onTap: () {
                                          if (selectionProvider.isSelectionMode) {
                                            selectionProvider.toggleSelection(docId);
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => chatscreen(
                                                  workers: {
                                                    'uid': receiverUid,
                                                    'name': displayName,
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        onLongPress: () => selectionProvider.toggleSelection(docId),
                                        leading: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: const Color(0xFF00A86B),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                        title: Text(
                                          displayName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: textColor,
                                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                          ),
                                          // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                        ),
                                        subtitle: Text(
                                          lastMessage,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isDark ? Colors.white70 : Colors.black54,
                                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                          ),
                                          // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              formattedTime,
                                              style: TextStyle(
                                                color: isDark ? Colors.white70 : Colors.black54,
                                                fontSize: 12,
                                              ),
                                              // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                            ),
                                            if (isSelected)
                                              Icon(
                                                Icons.check_circle,
                                                color: const Color(0xFF00A86B),
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final isUrdu = Provider.of<LanguageProvider>(context).isUrdu;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 1.5,
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
              // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            Spacer(),
            Icon(
              icon,
              color: textColor,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}