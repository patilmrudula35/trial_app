import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trial_app/speech_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
  
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SpeechScreen(),
      debugShowCheckedModeBanner: false,
      title: 'sahgfaj',
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
      ),
    );
  }
}