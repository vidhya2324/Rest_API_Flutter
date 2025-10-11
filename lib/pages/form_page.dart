import 'package:flutter/material.dart';

Future<Map<String, String>?> showAddUserDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String phone = '';
  String logo = '';
  String rating = '';

  return await showDialog<Map<String, String>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Add New User",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter the Name'),
                  onSaved: (val) => name = val ?? '',
                  validator: (val) => val!.isEmpty ? "Enter Name" : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter the Email'),
                  onSaved: (val) => email = val ?? '',
                  validator: (val) => val!.isEmpty ? "Enter Email" : null,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter the Phone Number',
                  ),
                  onSaved: (val) => phone = val ?? '',
                  validator: (val) =>
                      val!.isEmpty ? "Enter Phone Number" : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter the Logo URL'),
                  onSaved: (val) => logo = val ?? '',
                  validator: (val) => val!.isEmpty ? "Enter Logo URL" : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter the Rating'),
                  onSaved: (val) => rating = val ?? '',
                  validator: (val) => val!.isEmpty ? "Enter Rating" : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.pop(context, {
                  'name': name,
                  'email': email,
                  'phonenumber': phone,
                  'logo': logo, // ✅ lowercase
                  'rating': rating,
                });
              }
            },
            child: Text("Add"),
          ),
        ],
      );
    },
  );
}
