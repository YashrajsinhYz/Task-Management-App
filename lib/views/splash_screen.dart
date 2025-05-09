import 'package:flutter/material.dart';
import 'package:task_management/utility/app_theme.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Container(
              height: 100,
              width: 100,
              // color: Colors.white,
              margin: EdgeInsets.only(bottom: 10),
              child: Image.asset("assets/images/tasks.png"),
            ),
            Text(
              "Everything Tasks",
              style: TextStyle(color: Colors.white,fontSize: 35, fontFamily: "Poppins"),
            ),
            Text(
              "Schedule your tasks with ease",
              style: TextStyle(color: Colors.white,fontFamily: "Poppins"),
            ),
          ],
        ),
      ),
    );
  }
}
