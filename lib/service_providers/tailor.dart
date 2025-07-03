
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:servable/workers_individuals_profile/tailor_individuals.dart';

class TailorProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tailors = [];
  List<Map<String, dynamic>> _filteredTailors = [];

  List<Map<String, dynamic>> get tailors => _filteredTailors;

  Future<void> fetchTailors() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Tailor')
          .get();

      _tailors = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredTailors = List.from(_tailors);
      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: ${error.toString()}");
    }
  }

  void searchTailors(String query) {
    if (query.isEmpty) {
      _filteredTailors = List.from(_tailors);
    } else {
      _filteredTailors = _tailors
          .where((tailor) =>
              tailor['city'] != null &&
              tailor['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class Tailors extends StatefulWidget {
  const Tailors({super.key});

  @override
  State<Tailors> createState() => _TailorsState();
}

class _TailorsState extends State<Tailors> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TailorProvider>(context, listen: false).fetchTailors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tailorProvider = Provider.of<TailorProvider>(context);
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
          'Tailors',
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
              onChanged: tailorProvider.searchTailors,
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
            child: tailorProvider.tailors.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: tailorProvider.tailors.length,
                    itemBuilder: (context, index) {
                      var tailor = tailorProvider.tailors[index];
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
                                builder: (context) => TailorIndividuals(tailor: tailor),
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
                              child: const Icon(Icons.person, size: 30, color: Colors.white),
                            ),
                          ),
                          title: Text(
                            tailor['name'] ?? 'No Name',
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
                                    tailor['city'] ?? 'Unknown',
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
                                    "${tailor['rating'] ?? 0.0} / 5",
                                    style: TextStyle(
                                      color: subtitleColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Experience: ${tailor['experience'] ?? 'N/A'} years",
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
