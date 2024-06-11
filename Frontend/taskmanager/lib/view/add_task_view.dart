import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  Future<void> addItemToQueue(String item) async {
    final url = Uri.parse('http://localhost:8000/add_item');
    final response = await http.post(
      url,
      body: jsonEncode({'item': item}),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Item added to the queue: $item');
    } else {
      print('Failed to add item to the queue');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final oneFourthHeight = screenHeight / 4;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add task'),
      ),
      body: Column(
        children: [
          SizedBox(height: oneFourthHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: () => addItemToQueue('Watering'),
                  child: Text('Watering'),
                ),
              ),
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: () => addItemToQueue("Planting"),
                  child: Text("Planting"),
                ),
              ),
            ],
          ),
          SizedBox(height: oneFourthHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: () => addItemToQueue('Harvesting'),
                  child: Text('Harvesting'),
                ),
              ),
              Container(
                width: screenWidth / 5,
                child: ElevatedButton(
                  onPressed: () => addItemToQueue("PesticideAdding"),
                  child: Text("PesticideAdding"),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight / 7),
          IconButton(
            icon: Icon(Icons.home, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
