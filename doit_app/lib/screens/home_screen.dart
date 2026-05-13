import 'package:doit_app/app_constants.dart';
import 'package:doit_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppConstants.brandPurple, Colors.black],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const CustomText(
            text: 'Home',
            fontSize: 22,
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConstants.brandPurple,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 32),
                const CustomText(
                  text: 'Bem-vindo ao DoIt!',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const CustomText(
                  text: 'Imagine se você fizesse... Agora, torne real!',
                  fontSize: 14,
                  color: Color(0xFFAAAAAA),
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
