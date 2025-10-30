import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                  keyboardType: TextInputType.name,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                  onSaved: (val) => name = val ?? '',
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter Your Name";
                    if (!RegExp(r'[a-zA-Z\s]').hasMatch(val)) {
                      return "Name can only contain Letters";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter the Email'),
                  keyboardType: TextInputType.emailAddress,

                  onSaved: (val) => email = val ?? '',
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter Email";
                    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(val)) {
                      return "Enter a valid Email";
                    
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter the Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onSaved: (val) => phone = val ?? '',
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter Phone Number";
                    if (!RegExp(r'^\d{10}$').hasMatch(val)) {
                      return "Enter a valid 10-digit number";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter the Logo URL'),
                  keyboardType: TextInputType.url,
                  onSaved: (val) => logo = val ?? '',
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter Logo URL";
                    if (!Uri.parse(val).isAbsolute) return "Enter a valid URL";
                    return null;
                  },
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
                  'logo': logo, 
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
