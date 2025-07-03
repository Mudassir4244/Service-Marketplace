
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/customer_view/allworker.dart';

class customerfetching extends StatefulWidget {
  const customerfetching({super.key});

  @override
  State<customerfetching> createState() => _customerfetchingState();
}

class _customerfetchingState extends State<customerfetching> {
  @override
  Widget build(BuildContext context) {
    final workerprovider = Provider.of<WorkerDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cusomters'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: workerprovider.customers.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Column(
              children: [
                Text(workerprovider.customers.toString())
              ],
            ),
          );
        },
      ),
    );
  }
}

