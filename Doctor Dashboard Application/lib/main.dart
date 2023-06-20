import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_dashboard/screens/panel.dart';
import 'package:doctor_dashboard/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async{
    auth.authStateChanges().listen((User? user) {
      if(user != null && mounted){
        setState(() {
          isLogin = true;
        });
      }
    });
  }
  
  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(
          primaryColor: const Color.fromRGBO(237, 237, 237, 1.0),
          accentColor: const Color.fromRGBO(68, 193, 246, 1.0),
          appBarTheme: const AppBarTheme(centerTitle: true),
          snackBarTheme: const SnackBarThemeData(
              backgroundColor: Color.fromRGBO(68, 193, 246, 1.0),
              contentTextStyle: TextStyle(color: Colors.white))),
      home: isLogin? Panel() : Register(),
    );
  }
}
