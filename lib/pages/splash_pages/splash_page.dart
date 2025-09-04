import 'package:flutter/material.dart';
import 'package:logosophy/pages/splash_pages/animated_logo.dart';

/// A simple splash page that displays a loading indicator.
///
/// The redirection logic is now handled by the `redirect` function
/// in the GoRouter configuration, making this widget purely visual.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: BreathingLogo()));
  }
}
