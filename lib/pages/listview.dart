import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
            onPressed: () {
              setState(() {
                data += [
                  {
                    "id": 1,
                    "name": "Leanne Graham",
                    "username": "Bret",
                    "email": "Sincere@april.biz",
                    "address": {
                      "street": "Kulas Light",
                      "suite": "Apt. 556",
                      "city": "Gwenborough",
                      "zipcode": "92998-3874",
                      "geo": {"lat": "-37.3159", "lng": "81.1496"},
                    },
                  },
                ];
              });
              //print("added button");
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
          : ListView.builder(
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
    );
  }
}
