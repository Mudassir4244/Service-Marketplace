// // ignore_for_file: unused_local_variable, unused_import

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/Inbox/chatscreen.dart';
// import 'package:servable/service_providers/worker_account.dart';
// import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class GardenersIndividual extends StatelessWidget {
//   final Map<String, dynamic> Gardeners; // Receive Gardeners details

//   const GardenersIndividual({super.key, required this.Gardeners});

//   @override
//   Widget build(BuildContext context) {
//     final workerProvider = Provider.of<WorkerAccount>(context);
//     final themeProvider = Provider.of<Themeprovider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           Gardeners['name'] ?? 'Gardeners Profile',
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//       bottomNavigationBar:  Padding(
//                     padding: const EdgeInsets.all( 20),
//                     child: GestureDetector(
//                       onTap: (){
//                         Navigator.push(context, MaterialPageRoute(builder: (context)=>chatscreen(workers: Gardeners, )));
//                       },
//                       child: Container(
//                         height: 60,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(20)
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text('Send Message',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold , fontSize: 24),),
//                             SizedBox(width: 10),
//                             Icon(Icons.send_rounded ,color: Colors.white,)
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// **Category Image (At the Top)**
//               if (Gardeners['categoryImage'] != null) 
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: Image.network(
//                     Gardeners['categoryImage'] ?? 'https://via.placeholder.com/300', // Placeholder if no image
//                     height: 150,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Icon(Icons.build, size: 100, color: Colors.grey);
//                     },
//                   ),
//                 ),
//               const SizedBox(height: 15),

//               /// **Profile Image**
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(100), // Circular Image
//                 child: Image.network(
//                   Gardeners['imageUrl'] ?? 'https://via.placeholder.com/150', // Placeholder if no image
//                   height: 120,
//                   width: 120,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Center(child: CircleAvatar(
//                       radius: 70,
//                       child: const Icon(Icons.person, size: 100, color: Colors.black)));
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),

//               /// **Gardeners Details (Bold Labels)**
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: const Color.fromARGB(255, 194, 255, 196),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 20, top: 15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       buildRichText("Name:", Gardeners['name'] ?? 'N/A'),
//                       const SizedBox(height: 10),

//                       buildRichText("Email:", Gardeners['email'] ?? 'N/A'),
//                       const SizedBox(height: 10),

//                       // **Tappable Phone Number**
//                       buildRichText("Phone:", Gardeners['phonenumber'] ?? 'N/A', isPhoneNumber: true),
//                       const SizedBox(height: 10),

//                       buildRichText("City:", Gardeners['city'] ?? 'N/A'),
//                       const SizedBox(height: 10),

//                       buildRichText("Experience:", "${Gardeners['experience'] ?? 'N/A'} years"),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               Container(
//                 width: double.infinity,
//                 height: 60 ,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                    color: const Color.fromARGB(255, 194, 255, 196),
//                 ),
//                 child: Center(child: Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: buildRichText("Category:", Gardeners['categories']?.join(', ') ?? 'N/A'),
//                 ))),
//                 SizedBox(
                  
//                   height :MediaQuery.of(context).size.height*0.2),

                 
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// **Helper Method to Create Bold Labels**
//   Widget buildRichText(String label, String value, {bool isPhoneNumber = false}) {
//     return GestureDetector(
//       onTap: isPhoneNumber ? () => _launchDialer(value) : null, // Call dialer if it's a phone number
//       child: RichText(
//         text: TextSpan(
//           style: const TextStyle(fontSize: 18, color: Colors.black),
//           children: [
//             TextSpan(
//               text: "$label ", // Label
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             TextSpan(
//               text: value, // Value
//               style: TextStyle(
//                 decoration: isPhoneNumber ? TextDecoration.underline : null, // Underline if phone number
//                 color: isPhoneNumber ? Colors.blue : Colors.black, // Make it look like a link
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// **Method to Open Dial Pad**
//   void _launchDialer(String phoneNumber) async {
//     final Uri url = Uri.parse("tel:$phoneNumber");
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url);
//     } else {
//       debugPrint("Could not launch $url");
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:servable/Inbox/chatscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GardenerIndividuals extends StatefulWidget {
  final Map<String, dynamic> gardener;

  const GardenerIndividuals({super.key, required this.gardener});

  @override
  State<GardenerIndividuals> createState() => _GardenerIndividualsState();
}

class _GardenerIndividualsState extends State<GardenerIndividuals> {
  double _currentRating = 0.0;
  final TextEditingController _reviewController = TextEditingController();
  String? _reviewIdToEdit;

  Future<void> _submitReview(String uid, String reviewerName) async {
    if (_currentRating == 0.0) {
      Fluttertoast.showToast(msg: 'Please provide a rating.');
      return;
    }

    final reviewRef = FirebaseFirestore.instance
        .collection('Worker')
        .doc(widget.gardener['uid'])
        .collection('reviews')
        .doc(uid); // 1 review per user

    final existingReview = await reviewRef.get();
    if (existingReview.exists && _reviewIdToEdit == null) {
      Fluttertoast.showToast(msg: 'You have already submitted a review.');
      return;
    }

    try {
      if (_reviewIdToEdit == null) {
        await reviewRef.set({
          'reviewerUid': uid,
          'reviewerName': reviewerName,
          'rating': _currentRating,
          'comment': _reviewController.text.trim().isEmpty ? null : _reviewController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });
        Fluttertoast.showToast(msg: 'Review submitted successfully.');
      } else {
        await reviewRef.update({
          'rating': _currentRating,
          'comment': _reviewController.text.trim().isEmpty ? null : _reviewController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });
        Fluttertoast.showToast(msg: 'Review updated successfully.');
      }

      _reviewController.clear();
      setState(() {
        _currentRating = 0.0;
        _reviewIdToEdit = null;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to submit review.');
    }
  }

  void _editReview(String reviewId, String existingComment, double existingRating) {
    _reviewController.text = existingComment;
    setState(() {
      _currentRating = existingRating;
      _reviewIdToEdit = reviewId;
    });
  }

  Future<void> _deleteReview(String reviewId) async {
    await FirebaseFirestore.instance
        .collection('Worker')
        .doc(widget.gardener['uid'])
        .collection('reviews')
        .doc(reviewId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final customerprovider = Provider.of<CustomerProvider>(context);
    final reviewerUid = customerprovider.userData?['uid'] ?? '';
    final reviewerName = customerprovider.userData?['name'] ?? 'Anonymous';

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF1FCF7),
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
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          widget.gardener['name'] ?? 'gardener Profile',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => chatscreen(workers: widget.gardener)),
            );
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              
              gradient: LinearGradient(
                colors: [Color(0xFF00A86B), Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            
          
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Send Message", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Icon(Icons.send_rounded, color: Colors.white)
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(widget.gardener['imageUrl'] ?? ''),
            onBackgroundImageError: (_, __) => Icon(Icons.person, size: 80,
             color: Colors.black
            ),
            backgroundColor: isDark?Colors.grey[900]:Colors.teal[100],
            child: widget.gardener['imageUrl'] == null ? const Icon(Icons.person, size: 80) : null,
                          ),
            const SizedBox(height: 20),
            _buildInfoCard(isDark),
            const SizedBox(height: 30),
            _buildRatingSection(reviewerUid, reviewerName, isDark),
            const SizedBox(height: 20),
            _buildReviewsSection(reviewerUid, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark) {
    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfo("Name", widget.gardener['name'], isDark),
            _buildInfo("Email", widget.gardener['email'], isDark),
            _buildInfo("Phone", widget.gardener['phonenumber'], isDark, isPhoneNumber: true),
            _buildInfo("City", widget.gardener['city'], isDark),
            _buildInfo("Experience", "${widget.gardener['experience']} years", isDark),
            _buildInfo("Category", widget.gardener['categories']?.join(', ') ?? 'N/A', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String? value, bool isDark, {bool isPhoneNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: isPhoneNumber ? () => _launchDialer(value ?? '') : null,
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 17, color: isDark ? Colors.white : Colors.black87),
            children: [
              TextSpan(
                text: "$label: ",
                style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              ),
              TextSpan(
                text: value ?? 'N/A',
                style: TextStyle(
                  color: isPhoneNumber ? Colors.blueAccent : (isDark ? Colors.white70 : Colors.black87),
                  decoration: isPhoneNumber ? TextDecoration.underline : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchDialer(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Widget _buildRatingSection(String reviewerUid, String reviewerName, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Rate & Review", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                Icons.star,
                color: _currentRating > index ? Colors.amber : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _currentRating = index + 1.0;
                });
              },
            );
          }),
        ),
        TextField(
          controller: _reviewController,
          maxLines: 3,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: "Write your review (optional)...",
            hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            filled: true,
            fillColor: isDark ? Colors.grey[850] : Colors.white,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        Container(             decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [Color(0xFF00A86B), Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          
          child: TextButton(
          
          
            onPressed: () => _submitReview(reviewerUid, reviewerName),
            child: const Text("Submit Review", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(String reviewerUid, bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Worker')
          .doc(widget.gardener['uid'])
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 10),
            ...reviews.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final reviewId = doc.id;

              return Card(
                color: isDark ? Colors.grey[900] : Colors.white,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['reviewerName'] ?? 'Anonymous',
                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                      ),
                      if (data['reviewerUid'] == reviewerUid)
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editReview(reviewId, data['comment'], data['rating']);
                            } else if (value == 'delete') {
                              _deleteReview(reviewId);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            color: index < data['rating'] ? Colors.amber : Colors.grey,
                          );
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(data['comment'] ?? 'No comment', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
