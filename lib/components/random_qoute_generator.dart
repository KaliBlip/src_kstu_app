import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:src_kstu_app/components/colors.dart';

class RandomQouteGenerator extends StatefulWidget {
  const RandomQouteGenerator({super.key});

  @override
  State<RandomQouteGenerator> createState() => _RandomQouteGeneratorState();
}

class _RandomQouteGeneratorState extends State<RandomQouteGenerator> {
  final List<String> qoutes = [
    "You're not behind. You're on your path.",
    "Keep learning, keep growing.",
    "You're doing better than you think.",
    "Every expert was once a beginner."
  ];
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % qoutes.length;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            qoutes[_currentIndex],
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: bottomColor
            ),
          ),
          )
      ],
    );
  }
}