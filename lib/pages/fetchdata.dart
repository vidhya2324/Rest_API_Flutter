import 'dart:convert';
import 'form_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchData extends StatefulWidget {
  const FetchData({super.key});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  List data = [];
  Future<void> fetchdata() async {
    final res = await http.get(Uri.parse("https://retoolapi.dev/JPRqGs/data"));
    // print(res.body.toString());
    setState(() {
      data = jsonDecode(res.body);
    });

    print(data.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final newUser = await showAddUserDialog(context);
              if (newUser != null) {
                setState(() {
                  data.add(newUser);
                });

                //snackbar after adding:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "User Successfully added!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            icon: Icon(Icons.add_circle_outline_rounded, color: Colors.white),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 233, 75, 64),
        title: Text("User Details"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 197, 191, 191),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 150,
                            width: 160,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                image: NetworkImage(data[index]['logo']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index]['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),

                              Text(
                                data[index]['email'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                data[index]['phonenumber'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                data[index]['rating'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Delete button
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      tooltip: "Delete User",
                      onPressed: () async {
                        //confirmation
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "Delete User",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            content: Text(
                              "Are you sure you want to delete this user",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          if (!mounted) return;
                          setState(() {
                            data.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'User successfully deleted',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: Colors.black,
                                ),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      // icon: icon,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
