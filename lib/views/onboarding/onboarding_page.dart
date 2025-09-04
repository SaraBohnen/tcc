import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onNext;

  const OnboardingPage({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Image.asset(imageAsset, fit: BoxFit.contain)),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          child: Text(buttonText),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
