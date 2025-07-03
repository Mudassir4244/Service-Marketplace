
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:servable/workers_individuals_profile/gardener_individuals.dart';

// class pestproviders with ChangeNotifier {
//   List<Map<String, dynamic>> _pestcontollers = [];
//   List<Map<String, dynamic>> _filteredpestcontollers = [];

//   List<Map<String, dynamic>> get pestcontollers => _filteredpestcontollers;

//   Future<void> fetchpestcontollers() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('Worker')
//           .where('categories', arrayContains: 'Pest Control')
//           .get();

//       _pestcontollers = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['uid'] = doc.id;
//         return data;
//       }).toList();

//       _filteredpestcontollers = List.from(_pestcontollers);
//       notifyListeners();
//     } catch (error) {
//       Fluttertoast.showToast(msg: "Error: ${error.toString()}");
//     }
//   }

//   void searchpestcontollers(String query) {
//     if (query.isEmpty) {
//       _filteredpestcontollers = List.from(_pestcontollers);
//     } else {
//       _filteredpestcontollers = _pestcontollers
//           .where((gardener) =>
//               gardener['city'] != null &&
//               gardener['city'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }
// }

// class pestcontollers extends StatefulWidget {
//   const pestcontollers({super.key});

//   @override
//   State<pestcontollers> createState() => _pestcontollersState();
// }

// class _pestcontollersState extends State<pestcontollers> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<pestproviders>(context, listen: false).fetchpestcontollers();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final gardenerProvider = Provider.of<pestproviders>(context);
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
//           'pestcontollers',
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
//               onChanged: gardenerProvider.searchpestcontollers,
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
//             child: gardenerProvider.pestcontollers.isEmpty
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(greenColor),
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     itemCount: gardenerProvider.pestcontollers.length,
//                     itemBuilder: (context, index) {
//                       var gardener = gardenerProvider.pestcontollers[index];
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
//                                 builder: (context) =>
//                                     GardenerIndividuals(gardener: gardener),
//                               ),
//                             );
//                           },
//                           leading: Container(
                        
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [Color(0xFF00A86B), Colors.teal],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
            
//           ),
//                             child: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               radius: 30,
//                               child: const Icon(Icons.grass, size: 30, color: Colors.white),
//                             ),
//                           ),
//                           title: Text(
//                             gardener['name'] ?? 'No Name',
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
//                                   const Icon(Icons.location_on,
//                                       size: 16, color: Colors.grey),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     gardener['city'] ?? 'Unknown',
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
//                                   const Icon(Icons.star,
//                                       size: 16, color: Colors.orange),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     "${gardener['rating'] ?? 0.0} / 5",
//                                     style: TextStyle(
//                                       color: subtitleColor,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 "Experience: ${gardener['experience'] ?? 'N/A'} years",
//                                 style: TextStyle(
//                                   color: subtitleColor,
//                                   fontSize: 14,
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
// Assuming a PestControllerIndividual screen exists; replace with correct import if needed
import 'package:servable/workers_individuals_profile/gardener_individuals.dart';

class PestControllersProvider with ChangeNotifier {
  List<Map<String, dynamic>> _pestControllers = [];
  List<Map<String, dynamic>> _filteredPestControllers = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get pestControllers => _filteredPestControllers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPestControllers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Pest Control')
          .get();

      _pestControllers = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredPestControllers = List.from(_pestControllers);
    } catch (error) {
      _error = error.toString();
      Fluttertoast.showToast(msg: "Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPestControllers(String query) {
    if (query.isEmpty) {
      _filteredPestControllers = List.from(_pestControllers);
    } else {
      _filteredPestControllers = _pestControllers
          .where((controller) =>
              controller['city'] != null &&
              controller['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class PestControllers extends StatefulWidget {
  const PestControllers({super.key});

  @override
  State<PestControllers> createState() => _PestControllersState();
}

class _PestControllersState extends State<PestControllers> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<PestControllersProvider>(context, listen: false).fetchPestControllers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PestControllersProvider>(context);
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
          'Pest Controllers',
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
              onChanged: provider.searchPestControllers,
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
                    : provider.pestControllers.isEmpty
                        ? Center(
                            child: Text(
                              'No pest controllers found',
                              style: TextStyle(color: textColor, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: provider.pestControllers.length,
                            itemBuilder: (context, index) {
                              var controller = provider.pestControllers[index];
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
                                        builder: (context) => GardenerIndividuals(gardener: controller),
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
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 30,
                                      child: Icon(Icons.bug_report, size: 30, color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    controller['name'] ?? 'No Name',
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
                                            controller['city'] ?? 'Unknown',
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
                                            "${controller['rating'] ?? 0.0} / 5",
                                            style: TextStyle(
                                              color: subtitleColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Experience: ${controller['experience'] ?? 'N/A'} years",
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