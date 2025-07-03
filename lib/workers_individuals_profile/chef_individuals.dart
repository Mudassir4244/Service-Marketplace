

// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/service_providers/worker_account.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:servable/Inbox/chatscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChefIndividuals extends StatefulWidget {
  final Map<String, dynamic> chef;

  const ChefIndividuals({super.key, required this.chef});

  @override
  State<ChefIndividuals> createState() => _ChefIndividualsState();
}

class _ChefIndividualsState extends State<ChefIndividuals> {
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
        .doc(widget.chef['uid'])
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
        .doc(widget.chef['uid'])
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
          widget.chef['name'] ?? 'Chef Profile',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => chatscreen(workers: widget.chef)),
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
              backgroundImage: NetworkImage(widget.chef['imageUrl'] ?? ''),
              onBackgroundImageError: (_, __) => Icon(Icons.person, size: 80, color: Colors.black),
              backgroundColor: isDark ? Colors.grey[900] : Colors.teal[100],
              child: widget.chef['imageUrl'] == null ? const Icon(Icons.person, size: 80) : null,
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
            _buildInfo("Name", widget.chef['name'], isDark),
            _buildInfo("Email", widget.chef['email'], isDark),
            _buildInfo("Phone", widget.chef['phonenumber'], isDark, isPhoneNumber: true),
            _buildInfo("City", widget.chef['city'], isDark),
            _buildInfo("Experience", "${widget.chef['experience']} years", isDark),
            _buildInfo("Category", widget.chef['categories']?.join(', ') ?? 'N/A', isDark),
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
        Container(
           
            decoration: BoxDecoration(
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
          .doc(widget.chef['uid'])
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
