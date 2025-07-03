

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/service_providers/carwash.dart';
// import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:servable/workers_individuals_profile/mechanic_individuls.dart';

// class Carprovider with ChangeNotifier {
//   List<Map<String, dynamic>> _Carwash = [];
//   List<Map<String, dynamic>> _filteredCarwash = [];

//   List<Map<String, dynamic>> get Carwash => _filteredCarwash;

//   Future<void> fetchCarwash() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('Worker')
//           .where('categories', arrayContains: 'Car Wash')
//           .get();

//       _Carwash = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['uid'] = doc.id;
//         return data;
//       }).toList();

//       _filteredCarwash = List.from(_Carwash);
//       notifyListeners();
//     } catch (error) {
//       Fluttertoast.showToast(msg: "Error: ${error.toString()}");
//     }
//   }

//   void searchCarwash(String query) {
//     if (query.isEmpty) {
//       _filteredCarwash = List.from(_Carwash);
//     } else {
//       _filteredCarwash = _Carwash
//           .where((carwash) =>
//               carwash['city'] != null &&
//               carwash['city'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }
// }

// class Carwash extends StatefulWidget {
//   const Carwash({super.key});

//   @override
//   State<Carwash> createState() => _CarwashState();
// }

// class _CarwashState extends State<Carwash> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<Carprovider>(context, listen: false).fetchCarwash();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final carprovider = Provider.of<Carprovider>(context);
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
//           'Carwash',
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
//               onChanged: carprovider.searchCarwash,
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
//             child: carprovider.Carwash.isEmpty
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(greenColor),
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     itemCount: carprovider.Carwash.length,
//                     itemBuilder: (context, index) {
//                       var cars = carprovider.Carwash[index];
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
//                                 builder: (context) => MechanicIndividuls(mechanic: cars)
//                               ),
//                             );
//                           },
//                           leading: CircleAvatar(
//                             backgroundColor: greenColor.withOpacity(0.8),
//                             radius: 30,
//                             child: const Icon(Icons.person, size: 30, color: Colors.white),
//                           ),
//                           title: Text(
//                             cars['name'] ?? 'No Name',
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
//                                     cars['city'] ?? 'Unknown',
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
//                                     "${cars['rating'] ?? 0.0} / 5",
//                                     style: TextStyle(
//                                       color: subtitleColor,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 "Experience: ${cars['experience'] ?? 'N/A'} years",
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
// Placeholder import; replace with actual CarWashIndividual screen
import 'package:servable/workers_individuals_profile/mechanic_individuls.dart';

class CarWashProvider with ChangeNotifier {
  List<Map<String, dynamic>> _carWashProviders = [];
  List<Map<String, dynamic>> _filteredCarWashProviders = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get carWashProviders => _filteredCarWashProviders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCarWashProviders() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Car Wash')
          .get();

      _carWashProviders = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredCarWashProviders = List.from(_carWashProviders);
    } catch (error) {
      _error = error.toString();
      Fluttertoast.showToast(msg: "Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCarWashProviders(String query) {
    if (query.isEmpty) {
      _filteredCarWashProviders = List.from(_carWashProviders);
    } else {
      _filteredCarWashProviders = _carWashProviders
          .where((provider) =>
              provider['city'] != null &&
              provider['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class CarWashProviders extends StatefulWidget {
  const CarWashProviders({super.key});

  @override
  State<CarWashProviders> createState() => _CarWashProvidersState();
}

class _CarWashProvidersState extends State<CarWashProviders> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CarWashProvider>(context, listen: false).fetchCarWashProviders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarWashProvider>(context);
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
          'Car Wash Providers',
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
              onChanged: provider.searchCarWashProviders,
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
                    : provider.carWashProviders.isEmpty
                        ? Center(
                            child: Text(
                              'No car wash providers found',
                              style: TextStyle(color: textColor, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: provider.carWashProviders.length,
                            itemBuilder: (context, index) {
                              var carWash = provider.carWashProviders[index];
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
                                        // Replace with actual CarWashIndividual screen
                                        builder: (context) => MechanicIndividuls(mechanic: carWash),
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
                                      child: carWash['imageUrl'] != null
                                          ? ClipOval(
                                              child: Image.network(
                                                carWash['imageUrl'],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => const Icon(
                                                  Icons.local_car_wash,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : const Icon(
                                              Icons.local_car_wash,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                  title: Text(
                                    carWash['name'] ?? 'No Name',
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
                                            carWash['city'] ?? 'Unknown',
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
                                            "${carWash['rating'] ?? 0.0} / 5",
                                            style: TextStyle(
                                              color: subtitleColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Experience: ${carWash['experience'] ?? 'N/A'} years",
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