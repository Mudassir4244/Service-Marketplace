
// ignore_for_file: unused_import

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_homescreen.dart';
import 'package:servable/customer_view/services.dart';
import 'package:servable/theme_provider/themeprovider.dart';

// WorkerAccount Provider (Handles Firestore Data)
class WorkerAccount with ChangeNotifier {
  File? image;
  final ImagePicker _imagePicker = ImagePicker();
  Map<String, dynamic>? _workers;
  bool _isLoading = false;

  Map<String, dynamic>? get workers => _workers;
  bool get isLoading => _isLoading;

  Future<void> pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    notifyListeners();
  }

  Future<void> fetchWorkerData() async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User is not logged in.");
        _isLoading = false;
        notifyListeners();
        return;
      }

      print("Fetching data for User ID: ${user.uid}");
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Worker').doc(user.uid).get();

      if (userDoc.exists) {
        _workers = userDoc.data() as Map<String, dynamic>;
        print("User data fetched: $_workers");
      } else {
        print("User document does not exist.");
        _workers = null;
      }
    } catch (e) {
      print("Error fetching worker data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// Worker Profile Screen (Displays Worker Data)
class WorkerProfileScreen extends StatefulWidget {
  const WorkerProfileScreen({super.key});

  @override
  State<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkerAccount>(context, listen: false).fetchWorkerData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final workerProvider = Provider.of<WorkerAccount>(context);
    final themeProvider = Provider.of<Themeprovider>(context);

    return WillPopScope(
      onWillPop: ()async{
         Provider.of<Workertabbar>(context, listen: false).changeIndex(0);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkerHomescreen()));
        return true;
      },
      child: Scaffold(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
        Provider.of<Workertabbar>(context, listen: false).changeIndex(0); // ✅ Reset index to Home
        Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkerHomescreen())); // ✅ Close Profile Screen & Go Back to Home
      }
      
      
      
          ),
          backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          title: Text(workerProvider.workers?['name'] ?? 'Worker Profile'),
          centerTitle: true,
        ),
        body: workerProvider.isLoading
            ? Center(child:Transform.scale(
            scale: 2.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ))
            : workerProvider.workers == null
                ? const Center(child: Text('No User Data'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailTile('Name', workerProvider.workers?['name'] ?? 'No Name'),
                        _buildDetailTile('Email', workerProvider.workers?['email'] ?? 'No Email'),
                        _buildDetailTile('Phone', workerProvider.workers?['phonenumber'] ?? 'No Phone Number'),
                        _buildDetailTile('City', workerProvider.workers?['city'] ?? 'No City'),
                        _buildDetailTile('Experience', workerProvider.workers?['experience'] ?? 'No Experience'),
                        const SizedBox(height: 20),
                        Text(
                          'Categories:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (workerProvider.workers?['categories'] != null)
                          ...workerProvider.workers!['categories'].map<Widget>((category) {
                            return ListTile(
                              title: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        if (workerProvider.workers?['categories'] == null ||
                            workerProvider.workers!['categories'].isEmpty)
                          Text(
                            'No categories found.',
                            style: TextStyle(
                              fontSize: 16,
                              color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String value) {
    final themeProvider = Provider.of<Themeprovider>(context);
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}