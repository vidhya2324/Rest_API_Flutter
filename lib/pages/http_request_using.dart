import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class request_http extends StatefulWidget {
  const request_http({super.key});

  @override
  State<request_http> createState() => _request_httpState();
}

class _request_httpState extends State<request_http> {
  List<dynamic> dataList = [];
  bool isLoading = false;
  bool isRefreshing = false;

  final TextEditingController phoneNameController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController capactiyController = TextEditingController();
  @override
  //get the data from api--> get request
  Future<void> getData() async {
    setState(() {
      isLoading = true;
      isRefreshing = true;
    });
    final res = await http.get(
      Uri.parse("https://api.restful-api.dev/objects"),
    );
    if (res.statusCode == 200) {
      setState(() {
        dataList = jsonDecode(res.body);
        //isLoading = false;
      });
      await Future.delayed(const Duration(milliseconds: 300));
    } else {
      // isLoading = false;
      print("Error: ${res.statusCode}");
    }
    setState(() {
      isLoading = false;
      isRefreshing = false;
    });
  }

  //add the data to api --> post request
  Future<void> postData(String phone, String color, String capacity) async {
    final res = await http.post(
      Uri.parse("https://api.restful-api.dev/objects"),
      headers: {"content-type": "application/json"},
      body: jsonEncode({
        "name": phone,
        "data": {"Color": color, "Capacity": capacity},
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final newItem = jsonDecode(res.body);
      print("Post response: ${res.body.toString()}");
      setState(() {
        dataList.insert(0, newItem);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "New data added successfully!",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.green,
          ),
        );
      });

      // getData();
    } else {
      //print("Error: ${res.statusCode}");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add data."),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Phone Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneNameController,
                decoration: InputDecoration(labelText: "Phone name"),
              ),
              TextField(
                controller: colorController,
                decoration: InputDecoration(labelText: "Phone Color"),
              ),
              TextField(
                controller: capactiyController,
                decoration: InputDecoration(labelText: "Phone Capacity"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (phoneNameController.text.isEmpty ||
                    colorController.text.isEmpty ||
                    capactiyController.text.isEmpty) {
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please fill all the fields!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                  return;
                }
                final phone = phoneNameController.text;
                final color = colorController.text;
                final capacity = capactiyController.text.trim();
                Navigator.pop(context);
                postData(phone, color, capacity);
                phoneNameController.clear();
                colorController.clear();
                capactiyController.clear();
              },
              child: Text("ADD"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    //postData();
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Phone Details",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 98, 160),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedOpacity(
              opacity: isRefreshing ? 0.5 : 1.0,
              duration: Duration(milliseconds: 500),
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final item = dataList[index];
                  final name = item['name'] ?? "no name";
                  final id = item['id'] ?? 'N/A';
                  final data = item['data'] ?? {};

                  return AnimatedContainer(
                    duration: Duration(seconds: 5),
                    color: isRefreshing
                        ? Colors.red.shade50
                        : Colors.transparent,
                    child: Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 4,

                      child: ListTile(
                        title: Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(data.toString()),
                        trailing: Text("ID: $id"),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog();
        },
        child: Icon(Icons.add, color: Colors.pinkAccent),
      ),
    );
  }
}
