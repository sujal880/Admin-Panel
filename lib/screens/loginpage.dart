import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rolebased_authentication/screens/student.dart';
import 'package:rolebased_authentication/screens/teacher.dart';
import 'package:rolebased_authentication/uihelper/uihelper.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  CheckValues()async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    if(email=="" || password==""){
      UiHelper.CustomShowDialog(context,"Enter Required Fields");
    }
    else{
      UserCredential? userCredential;
      try{
        userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        route();
      }
      on FirebaseAuthException catch(ex){
        UiHelper.CustomShowDialog(context,ex.code.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UiHelper.CustomTextField(emailController,"Email", Icons.mail),
          UiHelper.CustomTextField(passwordController,"Password", Icons.password),
          SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            CheckValues();
          }, child: Text("Login"))
        ],
      ),
    );
  }

  route()async{
    User? user=FirebaseAuth.instance.currentUser;
    var check=FirebaseFirestore.instance.collection("Users").doc(user!.uid).get().then((DocumentSnapshot documentSnapshot
    ){
      if(documentSnapshot.exists){
        if(documentSnapshot.get("role")=="Teacher"){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>Teacher()));
        }
        else{
          Navigator.push(context,MaterialPageRoute(builder: (context)=>Student()));
        }
      }
      else{
        return print("Data Doesnt Exist");
      }
    });
  }
}
