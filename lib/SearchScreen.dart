import 'package:flutter/material.dart';
import 'dart:ui';

import 'connectionscreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  bool _deviceConnected = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800), // Faster pulse: 0.5 seconds
      vsync: this,
    )..repeat(reverse: true); // Repeat animation in reverse for pulsing effect

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Simulate device connection after 3 seconds
    _simulateDeviceConnection();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _simulateDeviceConnection() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _deviceConnected = true;
      });

      // Navigate to next screen if device is connected
      if (_deviceConnected) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ConnectionScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 41, 41),
      body: Center(
        child: _deviceConnected
            ? const CircularProgressIndicator()
            : AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // First (Largest) Hexagon Icon
                Transform.scale(
                  scale: 1.25 +
                      (_animation.value *
                          0.3), // Scale instead of size change
                  child: Icon(
                    Icons.hexagon_rounded,
                    size: 270, // Base size for the largest hexagon
                    color: const Color.fromARGB(255, 64, 65, 66)
                        .withOpacity(0.5),
                  ),
                ),
                // Second Hexagon Icon
                Transform.scale(
                  scale: 1.25 + (_animation.value * 0.3),
                  child: Icon(
                    Icons.hexagon_rounded,
                    size: 240, // Base size for the second hexagon
                    color: const Color.fromARGB(255, 98, 102, 105)
                        .withOpacity(0.2),
                  ),
                ),
                // Third Hexagon Icon
                Transform.scale(
                  scale: 1.25 + (_animation.value * 0.3),
                  child: Icon(
                    Icons.hexagon_rounded,
                    size: 210, // Base size for the third hexagon
                    color: const Color.fromARGB(255, 149, 152, 155)
                        .withOpacity(0.3),
                  ),
                ),
                // Fourth Hexagon Icon
                Transform.scale(
                  scale: 1.25 + (_animation.value * 0.3),
                  child: Icon(
                    Icons.hexagon_rounded,
                    size: 180, // Base size for the fourth hexagon
                    color: const Color.fromARGB(255, 198, 200, 202)
                        .withOpacity(0.4),
                  ),
                ),
                // Fifth (Smallest) Hexagon Icon
                Transform.scale(
                  scale: 1.25 + (_animation.value * 0.3),
                  child: Icon(
                    Icons.hexagon_rounded,
                    size: 150, // Base size for the smallest hexagon
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.5),
                  ),
                ),
                // Searching Text
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: AnimatedText(
                    text: 'SEARCHING',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 43, 41, 41),
                      fontWeight: FontWeight.bold, // Make text bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const AnimatedText(
      {super.key,
        required this.text,
        required this.style,
        required this.textAlign});

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Animation duration
      vsync: this,
    )..repeat(
        reverse: true); // Repeat animation in reverse for pulsating effect

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _blurAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Text with blur effect
            Opacity(
              opacity: _fadeAnimation.value,
              child: Text(
                widget.text,
                style: widget.style,
                textAlign: widget.textAlign,
              ),
            ),
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurAnimation.value,
                    sigmaY: _blurAnimation.value,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
