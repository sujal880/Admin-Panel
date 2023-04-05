import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rolebased_authentication/uihelper/uihelper.dart';

import 'loginpage.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  CheckValues() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();

    if (name == "" || email == "" || password == "" || phone == "") {
      UiHelper.CustomShowDialog(context, "Enter Required Fields");
    } else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (ex) {
        UiHelper.CustomShowDialog(context, ex.code.toString());
      }
      if (usercredential != null) {
        String uid = usercredential.user!.uid;
        FirebaseFirestore.instance.collection("Users").doc(uid).set({
          "email": email,
          "phone": phone,
          "role": role,
          "uid": uid
        }).then((value) {
          log("Data Uploaded");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        });
      }
    }
  }

  var options = ["Student", "Teacher"];
  var currentItemSelected = "Student";
  var role = "Student";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(nameController, "Name", Icons.person),
          UiHelper.CustomTextField(emailController, "Email", Icons.mail),
          UiHelper.CustomTextField(
              passwordController, "Password", Icons.password),
          UiHelper.CustomTextField(phoneController, "Phone", Icons.phone),
          SizedBox(height: 20),
          Text(
            "Role",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Rool : ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          DropdownButton<String>(
            dropdownColor: Colors.blue[900],
            isDense: true,
            isExpanded: false,
            iconEnabledColor: Colors.white,
            focusColor: Colors.white,
            items: options.map((String dropDownStringItem) {
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(
                  dropDownStringItem,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValueSelected) {
              setState(() {
                currentItemSelected = newValueSelected!;
                role = newValueSelected;
              });
            },
            value: currentItemSelected,
          ),
          ElevatedButton(
              onPressed: () {
                CheckValues();
              },
              child: Text("Register")),
          ElevatedButton(onPressed: () {}, child: Text("Sign In"))
        ],
      ),
    );
  }
}
