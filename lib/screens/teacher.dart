import 'package:flutter/material.dart';
class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher"),
        centerTitle: true,
      ),
    );
  }
}
