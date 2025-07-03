import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:servable/workers_individuals_profile/electrician_individual.dart';

class civilprovider with ChangeNotifier {
  List<Map<String, dynamic>> _CivilEngineers = [];
  List<Map<String, dynamic>> _filteredCivilEngineers = [];

  List<Map<String, dynamic>> get CivilEngineers => _filteredCivilEngineers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCivilEngineers() async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Civil Engineer')
          .get();

      _CivilEngineers = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredCivilEngineers = List.from(_CivilEngineers);
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCivilEngineers(String query) {
    if (query.isEmpty) {
      _filteredCivilEngineers = List.from(_CivilEngineers);
    } else {
      _filteredCivilEngineers = _CivilEngineers
          .where((electrician) =>
              electrician['city'] != null &&
              electrician['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class CivilEngineers extends StatefulWidget {
  const CivilEngineers({super.key});

  @override
  State<CivilEngineers> createState() => _CivilEngineersState();
}

class _CivilEngineersState extends State<CivilEngineers> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<civilprovider>(context, listen: false).fetchCivilEngineers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final civil = Provider.of<civilprovider>(context);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CivilEngineers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                civil.searchCivilEngineers(value);
              },
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
            child: civil.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    ),
                  )
                : civil.CivilEngineers.isEmpty
                    ? const Center(
                        child: Text(
                          'No CivilEngineers found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: civil.CivilEngineers.length,
                        itemBuilder: (context, index) {
                          var electrician = civil.CivilEngineers[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: cardColor,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ElectricianIndividual(
                                        electrician: electrician,
                                      ),
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
                                    child: const Icon(
                                      Icons.electrical_services,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  electrician['name']?.toString() ?? 'No Name',
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
                                          electrician['city']?.toString() ?? 'No city',
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
                                          "${electrician['rating'] ?? 0.0} / 5",
                                          style: TextStyle(
                                            color: subtitleColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Experience: ${electrician['experience'] ?? 'N/A'} years",
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