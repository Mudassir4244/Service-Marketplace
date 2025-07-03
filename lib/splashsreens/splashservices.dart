// ignore_for_file: unused_import, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, unused_local_variable, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:servable/Screens/worker_homescreen.dart';
import 'package:servable/customer_view/homescreen.dart';
import 'package:servable/customer_view/services.dart';
import 'package:servable/splashsreens/splashcreen1.dart';
import 'package:servable/splashsreens/splashscreen2.dart';
 
class Splashservices {
   void isLogin(BuildContext context){
    User? user = FirebaseAuth.instance.currentUser;
    if(user==null)
   {
     Timer(const Duration(seconds: 3), ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>const Splashscreen1())));
   }
   
   
   else{
    Timer(Duration(seconds: 3), ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Homescreen())));
   }
   }
}
