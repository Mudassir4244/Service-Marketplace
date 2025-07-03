
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:servable/workers_individuals_profile/labour_individuals.dart'; // Ensure this file defines the LaboursIndividual widget

class LabourProvider with ChangeNotifier {
  List<Map<String, dynamic>> _labours = [];
  List<Map<String, dynamic>> _filteredLabours = [];

  List<Map<String, dynamic>> get labours => _filteredLabours;

  Future<void> fetchLabours() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Labour')
          .get();

      _labours = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredLabours = List.from(_labours);
      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: ${error.toString()}");
    }
  }

  void searchLabours(String query) {
    if (query.isEmpty) {
      _filteredLabours = List.from(_labours);
    } else {
      _filteredLabours = _labours
          .where((labour) =>
              labour['city'] != null &&
              labour['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class Labours extends StatefulWidget {
  const Labours({super.key});

  @override
  State<Labours> createState() => _LaboursState();
}

class _LaboursState extends State<Labours> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LabourProvider>(context, listen: false).fetchLabours();
    });
  }

  @override
  Widget build(BuildContext context) {
    final labourProvider = Provider.of<LabourProvider>(context);
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
          'Labours',
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
              onChanged: labourProvider.searchLabours,
              decoration: InputDecoration(
                hintText: 'Search by City..',
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
            child: labourProvider.labours.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: labourProvider.labours.length,
                    itemBuilder: (context, index) {
                      var labour = labourProvider.labours[index];
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
                                    LabourIndividuals(labour: labour),
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
                              backgroundColor:Colors.transparent,
                              radius: 30,
                              child: const Icon(Icons.engineering, size: 30, color: Colors.white),
                            ),
                          ),
                          title: Text(
                            labour['name'] ?? 'No Name',
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
                                    labour['city'] ?? 'Unknown',
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
                                    "${labour['rating'] ?? 0.0} / 5",
                                    style: TextStyle(
                                      color: subtitleColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Experience: ${labour['experience'] ?? 'N/A'} years",
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
