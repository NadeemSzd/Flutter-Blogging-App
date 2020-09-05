import 'package:flutter/material.dart';
import 'package:simpleblogingapp/screens/Authentication/RegistrationScreen.dart';
import 'package:simpleblogingapp/screens/firebase_more_operations.dart';
import 'package:simpleblogingapp/screens/home.dart';
import 'package:simpleblogingapp/screens/splash_screen.dart';


void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Blogging App',
  home: SplashScreen(),
  theme: ThemeData(primarySwatch: Colors.pink),
));