import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'home_page.dart';

void main() {
  runApp(UAVA());
}

class UAVA extends StatelessWidget {
  const UAVA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAVA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NameEntryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NameEntryPage extends StatefulWidget {
  const NameEntryPage({super.key});

  @override
  _NameEntryPageState createState() => _NameEntryPageState();
}

class _NameEntryPageState extends State<NameEntryPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        _animationController.forward(); // Start the fade-in animation
      } else {
        _animationController
            .reverse(); // Reverse the animation when text is cleared
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onEnterPressed() async {
    try {
      Vibration.vibrate(duration: 500);
    } catch (e) {
      print('Error vibrating: $e');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          podName: _controller.text,
          remainingBatteryPercentage: 100,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate button dimensions based on screen size for responsiveness
    double buttonHeight = screenHeight * 0.12; // 12% of the screen height
    double buttonPaddingHorizontal =
        screenWidth * 0.07; // 7% of the screen width
    double buttonPaddingVertical =
        screenHeight * 0.03; // 3% of the screen height
    double buttonTextSize = screenWidth * 0.05; // 5% of the screen width

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 43, 41, 41),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'NAME YOUR DEVICE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth *
                              0.09, // 95% of screen width for the title
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _controller,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        cursorColor: Color.fromARGB(255, 43, 41, 41), // Change the cursor color
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 43, 41, 41)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 43, 41, 41)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 43, 41, 41)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 21,
            right: 21,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ElevatedButton(
                onPressed: _onEnterPressed,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.lightGreen,
                  padding: EdgeInsets.symmetric(
                    horizontal: buttonPaddingHorizontal,
                    vertical: buttonPaddingVertical,
                  ),
                  minimumSize: Size(double.infinity, buttonHeight * 2.8),
                ),
                child: Text(
                  'ENTER',
                  style: TextStyle(
                    fontSize: buttonTextSize * 3.8,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 43, 41, 41),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
