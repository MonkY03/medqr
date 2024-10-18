import 'verification_screen.dart'; // Asegúrate de importar la pantalla de verificación
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Agrega el parámetro 'key'

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'medQR',
      home: SplashScreen(), // Usa const para la SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Constructor con 'key'

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simula una carga de 5 segundos
    Timer(const Duration(seconds: 5), () {
      // Navega a la siguiente pantalla de verificación
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const VerificationScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF172329), // Color de fondo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
          children: [
            Image.asset(
              'assets/images/logo medQR.jpg', // Nombre de la imagen
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'Bienvenido a medQR',
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Agrega el parámetro 'key'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text(
          'Esta es la pantalla principal',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
