import 'package:crud_app/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomePage(title: 'Simple CRUD SQLite')));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/icons/crud_logo.png',
                            ),
                            fit: BoxFit.contain)),
                  ),
                  SizedBox(width: 8,),
                  Text(
                    'Simple CRUD',
                    style: GoogleFonts.outfit(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              SizedBox(height: 14,),
              Text('By Glyph Dev ID', style: GoogleFonts.outfit(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal))
            ],
          ),
        ),
      ),
    );
  }
}
