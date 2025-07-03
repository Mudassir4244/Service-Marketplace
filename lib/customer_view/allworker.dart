

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class WorkerDataProvider with ChangeNotifier {
  List<Map<String, dynamic>> _workers = [];
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = false;
  List<Map<String, dynamic>> get customers =>_customers;
  List<Map<String, dynamic>> get workers => _workers;
  bool get isLoading => _isLoading;

  Future<void> deleteWorker(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('Worker').doc(uid).delete();

      _workers.removeWhere((worker) => worker['uid'] == uid);
      notifyListeners();

      Fluttertoast.showToast(msg: "Worker deleted successfully");
    } catch (error) {
      Fluttertoast.showToast(msg: "Error deleting worker: ${error.toString()}");
    }
  }
  Future<void> fetchcustomers()async{
    try{
      _isLoading = true; 
      notifyListeners();
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Customers').get();
      _customers =  snapshot.docs.map((doc){
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();
    }
    catch(e){
      _isLoading = false; 
      notifyListeners();
      Fluttertoast.showToast(msg: "Error is ${e.toString()}");}}
  Future<void> fetchWorkers() async {
    try {
      _isLoading = true;
      notifyListeners();
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Worker').get();
      _workers = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: "Error: ${error.toString()}");
    }
  }
}

class AllWorkerData extends StatefulWidget {
  const AllWorkerData({super.key});

  @override
  State<AllWorkerData> createState() => _AllWorkerDataState();
}

class _AllWorkerDataState extends State<AllWorkerData> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkerDataProvider>(context, listen: false).fetchWorkers();
    });
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this worker?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workerProvider = Provider.of<WorkerDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        
        title: const Text(
          'All Workers',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: workerProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : workerProvider.workers.isEmpty
              ? const Center(
                  child: Text(
                    'No workers found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: workerProvider.workers.length,
                  itemBuilder: (context, index) {
                    var worker = workerProvider.workers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Card(
                        elevation: 2,
                        color: const Color.fromARGB(255, 149, 201, 196),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    worker['name']?.toString() ?? 'No Name',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    worker['email']?.toString() ?? 'No Email',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    worker['city']?.toString() ?? 'No City',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    worker['phonenumber']?.toString() ??
                                        'No Phone Number',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    worker['categories']?.toString() ??
                                        'Unknown',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                onPressed: () async {
                                  final shouldDelete =
                                      await _showDeleteConfirmationDialog(
                                          context);
                                  if (shouldDelete == true) {
                                    workerProvider.deleteWorker(worker['uid']);
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkerDataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        home: const AllWorkerData(),
      ),
    );
  }
}