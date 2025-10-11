// 

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_api_flutter/app/routes.dart';
import 'package:rest_api_flutter/pages/listview.dart';
//import 'screens/rest_api_screen.dart'; // ✅ Import your separated file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // title: "API + ListView Demo",
      // theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/fetchdata',
      getPages: appRoutes(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pushNamed(context, '/api'); // ✅ Navigate to API screen
          },
         
          child: const Text("Go to API Page"),

        ),
      ),
    );
  }
}
