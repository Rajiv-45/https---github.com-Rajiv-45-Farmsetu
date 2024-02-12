import 'package:farmsetu/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Farmsetu",
                style: TextStyle(
                  color: Color(0xff612467),
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  fontFamily: "Urbanist",
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                backgroundColor: Color(0xffD9D9D9),
                valueColor: AlwaysStoppedAnimation(Color(0xff612467)),
                strokeWidth: 4,
              )
            ],
          ),
        ),
      ),
    );
  }
}
