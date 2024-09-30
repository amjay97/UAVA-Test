import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(
        podName: 'UAVA',
        remainingBatteryPercentage: 50,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String podName;
  final int remainingBatteryPercentage;

  const HomePage({
    super.key,
    required this.podName,
    required this.remainingBatteryPercentage,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _showTemporaryButtons = false;
  bool _showMainButton = true;
  bool _isPinging = false;
  String _selectedPingLevel = 'Low';
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(seconds: 1), // Blinking speed
      vsync: this,
    )..repeat(reverse: true); // Blinks continuously

    // Debugging: Check the battery percentage passed to the widget
    print('Battery Percentage: ${widget.remainingBatteryPercentage}');
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  void _onMainButtonPressed() {
    setState(() {
      _showTemporaryButtons = true;
      _showMainButton = false;
    });

    // Keep the temporary buttons visible for 8 seconds
    Timer(const Duration(seconds: 8), () {
      setState(() {
        _showTemporaryButtons = false;
        if (!_isPinging) {
          _showMainButton = true;
        }
      });
    });
  }

  void _onHexagonButtonPressed() {
    setState(() {
      _isPinging = true;
      _showTemporaryButtons = false;
    });

    // Trigger vibration
    Vibration.vibrate(duration: 500); // Vibrates for 500 milliseconds

    // Revert to "Tap To\nPING" after 10 seconds and show VOLUME button again
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isPinging = false;
          _showMainButton = true;
        });
      }
    });
  }

  void _onPingButtonPressed(String level) {
    setState(() {
      _selectedPingLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Define breakpoints for different device sizes (phones, tablets, etc.)
    bool isTablet = screenWidth > 600; // Adjust as necessary for tablet detection

    // Define responsive font sizes
    double tapToFontSize = isTablet ? screenWidth * 0.06 : screenWidth * 0.085; // Adjust for tablets
    double pingFontSize = isTablet ? screenWidth * 0.095 : screenWidth * 0.11;
    double pingingFontSize = isTablet ? screenWidth * 0.08 : screenWidth * 0.09;

    // Scale values for responsive design
    double hexagonSize = isTablet ? screenWidth * 0.45 : screenWidth * 0.60;
    double batteryFontSize = isTablet ? screenWidth * 0.1 : screenWidth * 0.12;
    double boltIconSize = isTablet ? screenWidth * 0.08 : screenWidth * 0.1;

    // Change hexagon color based on battery percentage
    Color hexagonColor =
    _getBatteryPercentageColor(widget.remainingBatteryPercentage);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 41, 41),
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: isTablet ? screenHeight * 0.03 : screenHeight * 0.05),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  widget.podName,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 113, 113, 113),
                    fontSize: isTablet ? screenWidth * 0.04 : screenWidth * 0.06, // Scaled font size for tablets
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Top Hexagon with Rounded Corners and Battery Percentage
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.hexagon_rounded, // Use the hexagon rounded icon
                    size: hexagonSize, // Scaled size of the hexagon
                    color:
                    hexagonColor, // Color of the hexagon changes with battery
                  ),
                  Text(
                    '${widget.remainingBatteryPercentage}%',
                    style: TextStyle(
                      color: const Color.fromARGB(
                          255, 43, 41, 41), // Text color constant
                      fontSize:
                      batteryFontSize, // Scaled font size for battery percentage
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Icon(
                Icons.bolt,
                color: Colors.lightGreen,
                size: boltIconSize, // Scaled size for the bolt icon
              ),
              const SizedBox(height: 12),
              // Bottom Hexagon with Rounded Corners
              GestureDetector(
                onTap: _onHexagonButtonPressed,
                child: AnimatedBuilder(
                  animation: _blinkController,
                  builder: (context, child) {
                    // Calculate the opacity for the fade-in/fade-out effect
                    double opacity = _isPinging
                        ? 0.4 + (0.4 * _blinkController.value) // Fade between 40% and 80%
                        : 1.0; // Full opacity when not pinging

                    return Opacity(
                      opacity: opacity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.hexagon_rounded,
                            size: hexagonSize * 1.04, // Slightly larger hexagon
                            color: Colors.white,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!_isPinging)
                                Transform.translate(
                                  offset: const Offset(0, 10), // Adjust position
                                  child: Opacity(
                                    opacity: 0.4 + (0.6 * _blinkController.value), // Pulse opacity
                                    child: Text(
                                      'TAP TO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 43, 41, 41),
                                        fontSize: tapToFontSize, // Responsive "TAP TO" size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              Transform.translate(
                                offset: const Offset(0, -1), // Adjust position
                                child: Opacity(
                                  opacity: 0.4 + (0.6 * _blinkController.value), // Pulse opacity for "PING" as well
                                  child: Text(
                                    _isPinging ? 'PINGING' : 'PING',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 43, 41, 41),
                                      fontSize: _isPinging
                                          ? pingingFontSize // Responsive "PINGING" size
                                          : pingFontSize, // Responsive "PING" size
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Visibility(
                  visible: _showTemporaryButtons,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildTemporaryButton('LOW', _selectedPingLevel == 'LOW'),
                      const SizedBox(width: 10),
                      _buildTemporaryButton(
                          'MEDIUM', _selectedPingLevel == 'MEDIUM'),
                      const SizedBox(width: 10),
                      _buildTemporaryButton(
                          'HIGH', _selectedPingLevel == 'HIGH'),
                    ],
                  ),
                ),
                Visibility(
                  visible: _showMainButton,
                  child: GestureDetector(
                    onTap: _onMainButtonPressed,
                    child: Container(
                      width: screenWidth * (isTablet ? 0.2 : 0.3), // Adjust for tablets
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Text(
                          'VOLUME',
                          style: TextStyle(
                            color: Color.fromARGB(255, 43, 41, 41),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2), // This spacer keeps the buttons higher up
        ],
      ),
    );
  }

  // Function to get the color of the hexagon based on battery percentage
  Color _getBatteryPercentageColor(int percentage) {
    if (percentage <= 25) {
      return Colors.red; // Low battery: red hexagon
    } else if (percentage <= 50) {
      return Colors.orange; // Medium battery: orange hexagon
    } else if (percentage <= 75) {
      return Colors.yellow; // High battery: yellow hexagon
    } else {
      return Colors.lightGreen; // Full battery: green hexagon
    }
  }

  // Function to build temporary button
  Widget _buildTemporaryButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => _onPingButtonPressed(label),
      child: Container(
        width: 110,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightGreen : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(255, 43, 41, 41),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
