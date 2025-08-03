import 'package:flutter/material.dart';
import 'package:pulse_of_words/screens/favourite_screen.dart';
import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    
    );
    _fadeIn = Tween<double>(begin: 0,end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    Timer(const Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFF0F2027),
          Color(0xFF203A43),
          Color(0xFF2C5364),
          Color(0xFF1F4068),
          Color(0xFF5C258D),
          Color(0xFF4389A2),
        ])
      ),
      child: Scaffold(
        body: FadeTransition(opacity: _fadeIn,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/splash.png',
              height: 100,),
              SizedBox(
                height: 20,),
              Text('Pulse Of Words',style: TextStyle(
                fontSize: 32,fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
                letterSpacing: 1.2,
              ),),
              SizedBox(
                height: 20,
              ),
              Text('Words That Spark the Soul',style: TextStyle(
                fontSize: 16,fontStyle: FontStyle.italic,color: isDark ? Colors.white70 : Colors.black54
              ),)
            ],
          ),
        ),
        ),
      ),
    );
  }
}