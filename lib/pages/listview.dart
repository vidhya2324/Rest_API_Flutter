import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_flutter/pages/form_page.dart';
import 'package:rest_api_flutter/pages/http_request_using.dart';

class RestApiScreen extends StatefulWidget {
  const RestApiScreen({super.key});

  @override
  State<RestApiScreen> createState() => _RestApiScreenState();
}

class _RestApiScreenState extends State<RestApiScreen> {
  List data = [];

  Future<void> fetchData() async {
    final res = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/users"),
    );
    print("API Start");
    print(res.body.toString());

    setState(() {
      data = jsonDecode(res.body);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void deleteItem(int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () async {
              final newUser = await showAddUserDialog(context);
              if (newUser != null) {
                setState(() {
                  data += [
                    {
                      "id": data.length + 1,
                      "name": newUser['name'],
                      "username": "Bret",
                      "email": newUser['email'],
                      "address": {
                        "street": "Kulas Light",
                        "suite": "Apt. 556",
                        "city": "custom city",
                        "zipcode": "92998-3874",
                        "geo": {"lat": "-37.3159", "lng": "81.1496"},
                      },
                    },
                  ];
                });
                //print("added button");
              }
            },
            icon: Icon(Icons.add_outlined, color: Colors.white),
          ),
        ],
        title: const Text(
          "API + ListView",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            final deletedItem = data[index];
                            final deletedIndex = index;
                            setState(() {
                              data.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${deletedItem['name']} deleted successfully',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.red,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                duration: Duration(seconds: 5),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  textColor: Colors.green,
                                  onPressed: () {
                                    setState(() {
                                      data.insert(deletedIndex, deletedItem);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        title: Text(
                          data[index]['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          data[index]['address']['city'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.blueAccent,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => request_http(),
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_forward),
                      label: Text(
                        "Go to HTTP Request",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,color: Colors.black
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 245, 199, 214),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // child: child,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
