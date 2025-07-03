import 'package:flutter/material.dart';
class Addcategory extends StatefulWidget {
  const Addcategory({super.key});

  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Categories"),
      ),
    );
  }
}