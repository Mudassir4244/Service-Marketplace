// ignore_for_file: unused_import, prefer_const_constructors, unused_field, prefer_final_fields, must_call_super

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/splashsreens/splashservices.dart';
import 'package:servable/theme_provider/themeprovider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  Splashservices _splashservices = Splashservices();
  bool _isLoading = true;
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    // Start scale animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _scale = 1.0;
      });
    });
    // Call isLogin with error handling and delay
    Future.delayed(Duration(seconds: 2), () async {
      try {
        _splashservices.isLogin(context);
      } catch (e) {
        print("Splashscreen error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;

    print("Building Splashscreen");

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              AnimatedScale(
                scale: _scale,
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeOutBack,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00A86B), Colors.teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo.jpg',
                      fit: BoxFit.cover,
                      width: 180,
                      height: 180,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // SERVABLE Text
              AnimatedOpacity(
                opacity: _isLoading ? 1.0 : 0.7,
                duration: Duration(milliseconds: 500),
                child: Text(
                  'SERVABLE',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Loading Indicator
              if (_isLoading)
                CircularProgressIndicator(
                  color: Color(0xFF00A86B),
                  strokeWidth: 3,
                ),
            ],
          ),
        ),
      ),
    );
  }
}