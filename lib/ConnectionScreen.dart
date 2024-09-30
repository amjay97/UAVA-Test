import 'package:flutter/material.dart';
import 'name_entry_page.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen>
    with TickerProviderStateMixin {
  bool _isConnected = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _connectDevice();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _connectDevice() {
    // Simulate a connection delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isConnected = true;
      });
      _animationController.forward();

      // Navigate to the next screen after displaying "Connected" for 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NameEntryPage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color.fromARGB(255, 43, 41, 41), // Change background color to grey
      body: Center(
        child: _isConnected
            ? AnimatedBuilder(
          animation: _animation,
          child: const Text(
            'CONNECTED',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold, // Make text bold
            ),
          ),
          builder: (context, child) {
            return FadeTransition(
              opacity: _animation,
              child: child,
            );
          },
        )
            : Container(), // Remove the connecting button
      ),
    );
  }
}
