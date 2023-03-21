import 'package:flutter/material.dart';
import 'package:fox_http/fox_http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var text = 'no data';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(text),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final response = await http.get(
              Uri.parse('https://httpbin.org/get'),
              headers: {
                'accept': 'application/json',
              }
            );

            setState(() {
              text = response.body;
            });
          },
          label: const Text('fetch'),
        ),
      ),
    );
  }
}
