

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:servable/workers_individuals_profile/mechanic_individuls.dart';

// class MechanicProvider with ChangeNotifier {
//   List<Map<String, dynamic>> _mechanics = [];
//   List<Map<String, dynamic>> _filteredMechanics = [];

//   List<Map<String, dynamic>> get mechanics => _filteredMechanics;

//   Future<void> fetchMechanics() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('Worker')
//           .where('categories', arrayContains: 'Mechanic')
//           .get();

//       _mechanics = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['uid'] = doc.id;
//         return data;
//       }).toList();

//       _filteredMechanics = List.from(_mechanics);
//       notifyListeners();
//     } catch (error) {
//       Fluttertoast.showToast(msg: "Error: ${error.toString()}");
//     }
//   }

//   void searchMechanics(String query) {
//     if (query.isEmpty) {
//       _filteredMechanics = List.from(_mechanics);
//     } else {
//       _filteredMechanics = _mechanics
//           .where((mechanic) =>
//               mechanic['city'] != null &&
//               mechanic['city'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }
// }

// class Mechanics extends StatefulWidget {
//   const Mechanics({super.key});

//   @override
//   State<Mechanics> createState() => _MechanicsState();
// }

// class _MechanicsState extends State<Mechanics> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<MechanicProvider>(context, listen: false).fetchMechanics();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mechanicProvider = Provider.of<MechanicProvider>(context);
//     final themeProvider = Provider.of<Themeprovider>(context);
//     final isDark = themeProvider.themeMode == ThemeMode.dark;

//     const greenColor = Color(0xFF00A86B);
//     final cardColor = isDark ? Colors.grey[850] : const Color(0xFFDFFFE0);
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final subtitleColor = isDark ? Colors.grey[300] : Colors.grey[700];

//     return Scaffold(
//       backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
//       appBar: AppBar(
//          flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFF00A86B), Colors.teal],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//         centerTitle: true,
//         title: const Text(
//           'Mechanics',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: TextField(
//               controller: _searchController,
//               onChanged: mechanicProvider.searchMechanics,
//               decoration: InputDecoration(
//                 hintText: 'Search by City...',
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: mechanicProvider.mechanics.isEmpty
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(greenColor),
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     itemCount: mechanicProvider.mechanics.length,
//                     itemBuilder: (context, index) {
//                       var mechanic = mechanicProvider.mechanics[index];
//                       return Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 4,
//                         color: cardColor,
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(15),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => MechanicIndividuls(mechanic: mechanic)
//                               ),
//                             );
//                           },
//                           leading: CircleAvatar(
//                             backgroundColor: greenColor.withOpacity(0.8),
//                             radius: 30,
//                             child: const Icon(Icons.person, size: 30, color: Colors.white),
//                           ),
//                           title: Text(
//                             mechanic['name'] ?? 'No Name',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: textColor,
//                             ),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 6),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.location_on, size: 16, color: Colors.grey),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     mechanic['city'] ?? 'Unknown',
//                                     style: TextStyle(
//                                       color: subtitleColor,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   const Icon(Icons.star, size: 16, color: Colors.orange),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     "${mechanic['rating'] ?? 0.0} / 5",
//                                     style: TextStyle(
//                                       color: subtitleColor,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 "Experience: ${mechanic['experience'] ?? 'N/A'} years",
//                                 style: TextStyle(
//                                   color: subtitleColor,
//                                   fontSize: 14
//                                 ),
//                               ),
//                             ],
//                           ),
//                           trailing: const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 18,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:servable/workers_individuals_profile/mechanic_individuls.dart';

class MechanicProvider with ChangeNotifier {
  List<Map<String, dynamic>> _mechanics = [];
  List<Map<String, dynamic>> _filteredMechanics = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get mechanics => _filteredMechanics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMechanics() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Mechanic')
          .get();

      _mechanics = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredMechanics = List.from(_mechanics);
    } catch (error) {
      _error = error.toString();
      Fluttertoast.showToast(msg: "Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchMechanics(String query) {
    if (query.isEmpty) {
      _filteredMechanics = List.from(_mechanics);
    } else {
      _filteredMechanics = _mechanics
          .where((mechanic) =>
              mechanic['city'] != null &&
              mechanic['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class Mechanics extends StatefulWidget {
  const Mechanics({super.key});

  @override
  State<Mechanics> createState() => _MechanicsState();
}

class _MechanicsState extends State<Mechanics> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<MechanicProvider>(context, listen: false).fetchMechanics();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MechanicProvider>(context);
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    const greenColor = Color(0xFF00A86B);
    final cardColor = isDark ? Colors.grey[850] : const Color(0xFFDFFFE0);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[300] : Colors.grey[700];

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A86B), Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Mechanics',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: provider.searchMechanics,
              decoration: InputDecoration(
                hintText: 'Search by City...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    ),
                  )
                : provider.error != null
                    ? Center(
                        child: Text(
                          'Error: ${provider.error}',
                          style: TextStyle(color: textColor, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : provider.mechanics.isEmpty
                        ? Center(
                            child: Text(
                              'No mechanics found',
                              style: TextStyle(color: textColor, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: provider.mechanics.length,
                            itemBuilder: (context, index) {
                              var mechanic = provider.mechanics[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                color: cardColor,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(15),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MechanicIndividuls(mechanic: mechanic),
                                      ),
                                    );
                                  },
                                  leading: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF00A86B), Colors.teal],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 30,
                                      child: mechanic['imageUrl'] != null
                                          ? ClipOval(
                                              child: Image.network(
                                                mechanic['imageUrl'],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => const Icon(
                                                  Icons.build,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : const Icon(
                                              Icons.build,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                  title: Text(
                                    mechanic['name'] ?? 'No Name',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            mechanic['city'] ?? 'Unknown',
                                            style: TextStyle(
                                              color: subtitleColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, size: 16, color: Colors.orange),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${mechanic['rating'] ?? 0.0} / 5",
                                            style: TextStyle(
                                              color: subtitleColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Experience: ${mechanic['experience'] ?? 'N/A'} years",
                                        style: TextStyle(
                                          color: subtitleColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}