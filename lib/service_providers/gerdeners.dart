
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:servable/workers_individuals_profile/gardener_individuals.dart';

// class GardenerProvider with ChangeNotifier {
//   List<Map<String, dynamic>> _gardeners = [];
//   List<Map<String, dynamic>> _filteredGardeners = [];

//   List<Map<String, dynamic>> get gardeners => _filteredGardeners;

//   Future<void> fetchGardeners() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('Worker')
//           .where('categories', arrayContains: 'Gardener')
//           .get();

//       _gardeners = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['uid'] = doc.id;
//         return data;
//       }).toList();

//       _filteredGardeners = List.from(_gardeners);
//       notifyListeners();
//     } catch (error) {
//       Fluttertoast.showToast(msg: "Error: ${error.toString()}");
//     }
//   }

//   void searchGardeners(String query) {
//     if (query.isEmpty) {
//       _filteredGardeners = List.from(_gardeners);
//     } else {
//       _filteredGardeners = _gardeners
//           .where((gardener) =>
//               gardener['city'] != null &&
//               gardener['city'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }
// }

// class Gardeners extends StatefulWidget {
//   const Gardeners({super.key});

//   @override
//   State<Gardeners> createState() => _GardenersState();
// }

// class _GardenersState extends State<Gardeners> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final gardenerProvider = Provider.of<GardenerProvider>(context);
//     final themeProvider = Provider.of<Themeprovider>(context);
//     final isDark = themeProvider.themeMode == ThemeMode.dark;

//     const greenColor = Color(0xFF00A86B);
//     final cardColor = isDark ? Colors.grey[850] : const Color(0xFFDFFFE0);
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final subtitleColor = isDark ? Colors.grey[300] : Colors.grey[700];

//     return Scaffold(
//       backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF00A86B), Colors.teal],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Gardeners',
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
//               onChanged: gardenerProvider.searchGardeners,
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
//             child: FutureBuilder(
//               future: gardenerProvider.fetchGardeners(),
//               builder: (context, AsyncSnapshot<void> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(greenColor),
//                     ),
//                   );
//                 }
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       'Error: ${snapshot.error}',
//                       style: TextStyle(color: textColor, fontSize: 16),
//                     ),
//                   );
//                 }
//                 if (gardenerProvider.gardeners.isEmpty) {
//                   return Center(
//                     child: Text(
//                       'No Gardeners Found',
//                       style: TextStyle(
//                         color: textColor,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 }
//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   itemCount: gardenerProvider.gardeners.length,
//                   itemBuilder: (context, index) {
//                     var gardener = gardenerProvider.gardeners[index];
//                     return Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       elevation: 4,
//                       color: cardColor,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(15),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   GardenerIndividuals(gardener: gardener),
//                             ),
//                           );
//                         },
//                         leading: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: LinearGradient(
//                               colors: [Color(0xFF00A86B), Colors.teal],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                           ),
//                           child: CircleAvatar(
//                             backgroundColor: Colors.transparent,
//                             radius: 30,
//                             child: const Icon(Icons.grass, size: 30, color: Colors.white),
//                           ),
//                         ),
//                         title: Text(
//                           gardener['name'] ?? 'No Name',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: textColor,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 6),
//                             Row(
//                               children: [
//                                 const Icon(Icons.location_on,
//                                     size: 16, color: Colors.grey),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   gardener['city'] ?? 'Unknown',
//                                   style: TextStyle(
//                                     color: subtitleColor,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Icon(Icons.star,
//                                     size: 16, color: Colors.orange),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   "${gardener['rating'] ?? 0.0} / 5",
//                                   style: TextStyle(
//                                     color: subtitleColor,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Experience: ${gardener['experience'] ?? 'N/A'} years",
//                               style: TextStyle(
//                                 color: subtitleColor,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing: const Icon(
//                           Icons.arrow_forward_ios,
//                           size: 18,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
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
import 'package:servable/workers_individuals_profile/gardener_individuals.dart';

class GardenerProvider with ChangeNotifier {
  List<Map<String, dynamic>> _gardeners = [];
  List<Map<String, dynamic>> _filteredGardeners = [];

  List<Map<String, dynamic>> get gardeners => _filteredGardeners;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchGardeners() async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Gardener')
          .get();

      _gardeners = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredGardeners = List.from(_gardeners);
      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: ${error.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchGardeners(String query) {
    if (query.isEmpty) {
      _filteredGardeners = List.from(_gardeners);
    } else {
      _filteredGardeners = _gardeners
          .where((gardener) =>
              gardener['city'] != null &&
              gardener['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class Gardeners extends StatefulWidget {
  const Gardeners({super.key});

  @override
  State<Gardeners> createState() => _GardenersState();
}

class _GardenersState extends State<Gardeners> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GardenerProvider>(context, listen: false).fetchGardeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gardenerProvider = Provider.of<GardenerProvider>(context);
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A86B), Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Gardeners',
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
              onChanged: gardenerProvider.searchGardeners,
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
            child: gardenerProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    ),
                  )
                : gardenerProvider.gardeners.isEmpty
                    ? const Center(
                        child: Text(
                          'No Gardeners Found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: gardenerProvider.gardeners.length,
                        itemBuilder: (context, index) {
                          var gardener = gardenerProvider.gardeners[index];
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
                                    builder: (context) =>
                                        GardenerIndividuals(gardener: gardener),
                                  ),
                                );
                              },
                              leading: Container(
                                decoration: BoxDecoration(
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
                                  child: const Icon(Icons.grass, size: 30, color: Colors.white),
                                ),
                              ),
                              title: Text(
                                gardener['name'] ?? 'No Name',
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
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        gardener['city'] ?? 'Unknown',
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
                                      const Icon(Icons.star,
                                          size: 16, color: Colors.orange),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${gardener['rating'] ?? 0.0} / 5",
                                        style: TextStyle(
                                          color: subtitleColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Experience: ${gardener['experience'] ?? 'N/A'} years",
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