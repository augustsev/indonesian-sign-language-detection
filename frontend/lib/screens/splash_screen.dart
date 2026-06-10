import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();


    _textController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _textAnimation = Tween<double>(begin: 0, end: 1).animate(_textController);
    _textController.forward();


    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });

  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
 
          Image.asset(
            'assets/images/splash_logo/sign.jpeg',
            fit: BoxFit.cover,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: FadeTransition(
                opacity: _textAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'to Sign Language App',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}