import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart'; // Import the vibration package
import 'searchscreen.dart';
import 'dart:ui'; // Import for blur effect

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _fadeAnimation;
  Animation<double>? _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Animation duration
    )
      ..repeat(reverse: true); // Repeat the animation

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );

    _blurAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _searchForUAVA() {
    // Vibrate when the button is pressed
    Vibration.vibrate(duration: 500); // Vibrates for 500 milliseconds

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: SearchScreen(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/UAVA.png',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 0),
              const Text(
                'TO PAIR YOUR UAVA PRESS',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Static color for text
                ),
              ),
              const SizedBox(height: 15),
              Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 1, // Static blur radius
                          sigmaY: 1, // Static blur radius
                        ),
                        child: Container(
                          color: Colors
                              .transparent, // Transparent container for blur only
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _searchForUAVA,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      backgroundColor:
                      Colors.white, // Static white color for the button
                      shadowColor:
                      Colors.transparent, // Remove any shadow effect
                    ),
                    child: AnimatedBuilder(
                      animation: _controller!,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Fade and blur effect on the text
                            Opacity(
                              opacity: _fadeAnimation!.value,
                              child: const Text(
                                'SEARCH',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 43, 41, 41),
                                ),
                              ),
                            ),
                            // Blur effect applied to the text
                            Positioned.fill(
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: _blurAnimation!.value,
                                    sigmaY: _blurAnimation!.value,
                                  ),
                                  child: Container(
                                    color: const Color.fromRGBO(0, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Adding the animated small white circle at the top, responsive position
          Positioned(
            top: screenHeight * 0.208, // 21% of the screen height
            left: screenWidth / 2 -
                ((screenWidth < screenHeight ? screenWidth : screenHeight) *
                    0.10 /
                    2), // Centered horizontally
            child: AnimatedBuilder(
              animation: _controller!,
              builder: (context, child) {
                final double circleSize =
                    (screenWidth < screenHeight ? screenWidth : screenHeight) *
                        0.12;
                return Opacity(
                  opacity: _fadeAnimation!.value,
                  child: ClipOval(
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: const BoxDecoration(
                        color: Colors.white, // Color of the circle
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: _blurAnimation!.value,
                          sigmaY: _blurAnimation!.value,
                        ),
                        child: Container(
                          color: Colors.transparent, // Blur effect
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}