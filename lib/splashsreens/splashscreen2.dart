// // ignore_for_file: unused_import, duplicate_ignore
// // ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables

// import "package:flutter/material.dart";
// import "package:servable/Screens/choice.dart";
// import "package:servable/customer_view/customer_profilescreen.dart";
// import "package:servable/customer_view/registration.dart";

 
// class Splashscreen2 extends StatefulWidget {
//   const Splashscreen2({super.key});

//   @override
//   State<Splashscreen2> createState() => _Splashcreen1State();
// }

// class _Splashcreen1State extends State<Splashscreen2> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
            
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
              
//               GestureDetector(
//                 onTap: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ChoiceScreen()));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 280,top: 30),
//                   child: Container(
//                     width: 70,
//                     height: 30,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       color: const Color.fromARGB(68, 109, 162, 255)),
//                     child: Center(
//                       child: Text('Skip',style: TextStyle(color:Color.fromARGB(255, 1, 38, 101),
//                       fontSize: 16
//                       ),),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 30,),
//               Center(child: Flexible(child: Image.asset('assets/splashscreen3.png'))),
//               SizedBox(height: 5),
//               GestureDetector(
//                 onTap: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ChoiceScreen()));
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 10,bottom: 100),
//                   child: Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
                      
//                       color: Colors.green),
                    
//                     child: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 35,)),
//                 ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// ignore_for_file: unused_import, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:servable/Screens/choice.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/customer_view/registration.dart';

class Splashscreen2 extends StatefulWidget {
  const Splashscreen2({super.key});

  @override
  State<Splashscreen2> createState() => _Splashscreen2State();
}

class _Splashscreen2State extends State<Splashscreen2> with SingleTickerProviderStateMixin {
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    // Start scale animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    print("Building Splashscreen2");

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      try {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ChoiceScreen()),
                        );
                      } catch (e) {
                        print("Navigation error to ChoiceScreen: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    child: AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(68, 109, 162, 255),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Color.fromARGB(255, 1, 38, 101),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              // Image
              Center(
                child: AnimatedScale(
                  scale: _scale,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeOutBack,
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/splashscreen3.png',
                        fit: BoxFit.cover,
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.5,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.error,
                          size: 100,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Next Button
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20, bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      try {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ChoiceScreen()),
                        );
                      } catch (e) {
                        print("Navigation error to ChoiceScreen: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    child: AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                                colors: [Color(0xFF00A86B), Colors.teal],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}