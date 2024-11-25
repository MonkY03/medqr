import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'verification_screen.dart'; // Importa la nueva pantalla de verificación
import 'login_screen.dart'; // Importa la pantalla de inicio de sesión

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: '+51'); // Prefijo +51

  bool _passwordsMatch = true;
  bool _isEmailValid = true;
  bool _isPhoneValid = true; // Nueva variable para controlar la validez del número de teléfono

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch = _passwordController.text == _confirmPasswordController.text;
    });
  }

  bool _validateEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Nueva función para validar el número de teléfono
  bool _validatePhone(String phone) {
    final RegExp phoneRegex = RegExp(r'^\+51\s*9\d{8}$');
    return phoneRegex.hasMatch(phone);
  }

  Future<void> _registerUser() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      _showErrorDialog('Todos los campos son obligatorios.');
      return;
    }

    if (!_validateEmail(_emailController.text)) {
      setState(() {
        _isEmailValid = false;
      });
      _showErrorDialog('Por favor, ingresa un correo electrónico válido.');
      return;
    }

    if (!_validatePhone(_phoneController.text)) {
      setState(() {
        _isPhoneValid = false; // Número de teléfono no válido
      });
      _showErrorDialog('Por favor, ingresa un número de teléfono válido.');
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = _emailController.text;
    String password = _passwordController.text;

    await prefs.setString(email, password);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registro Terminado'),
          content: const Text('Tu cuenta ha sido registrada exitosamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Regresa a la pantalla anterior
                // Navegar a la pantalla de verificación
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VerificationScreen()),
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF172329),
      appBar: AppBar(
        title: const Text('Registro'),
        backgroundColor: const Color(0xFF172329),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    errorText: !_isEmailValid ? 'Correo inválido' : null,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Número de Teléfono',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    errorText: !_isPhoneValid ? 'Número inválido. Debe empezar con 9 y tener 9 dígitos.' : null, // Mensaje de error si es inválido
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isPhoneValid = _validatePhone(value); // Valida en tiempo real
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  onChanged: (value) => _checkPasswordsMatch(),
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    errorText: !_passwordsMatch ? 'Las contraseñas no coinciden' : null,
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _passwordsMatch ? _registerUser : null,
                      child: const Text('Registrar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()), // Navegar a la pantalla de inicio de sesión
                        );
                      },
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
