import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Professional App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _navigateToSecondScreen() async {
    Map<String, dynamic> data = await fetchData();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen(data: data),
      ),
    );
  }

  void _clearTextField(TextEditingController controller) {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professional App Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTextFieldWithClearButton(
              controller: mobileController,
              labelText: 'Mobile Number',
            ),
            SizedBox(height: 16),
            buildTextFieldWithClearButton(
              controller: dobController,
              labelText: 'Date of Birth',
            ),
            SizedBox(height: 16),
            buildTextFieldWithClearButton(
              controller: roleController,
              labelText: 'Role',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToSecondScreen,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                elevation: 5,
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldWithClearButton({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextField(
                controller: controller,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: TextStyle(color: Colors.blue),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _clearTextField(controller);
            },
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  SecondScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Team Information: ${data['team']}'),
            Text('Player Information: ${data['player']}'),
          ],
        ),
      ),
    );
  }
}
