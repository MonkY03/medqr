import 'package:flutter/material.dart';
import 'dart:async';
import 'registro_datos.dart'; // Importar la pantalla de registro de datos

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  String? _selectedMethod; // Método de envío (correo o celular)
  final TextEditingController _codeController = TextEditingController();
  bool _isCodeValid = false; // Variable para controlar la validez del código
  bool _isResendButtonEnabled = true; // El botón de reenviar está habilitado inicialmente
  Timer? _timer; // Temporizador para el código de verificación
  Timer? _resendTimer; // Temporizador para el botón de reenviar
  int _remainingTime = 240; // 4 minutos en segundos para el temporizador de verificación
  int _resendCooldown = 0; // Tiempo restante para habilitar el botón de reenviar
  bool _isSendButtonPressed = false; // Variable para controlar si el botón de enviar ha sido presionado

  @override
  void dispose() {
    _codeController.dispose();
    _timer?.cancel(); // Cancelar el temporizador al salir
    _resendTimer?.cancel(); // Cancelar el temporizador del botón reenviar
    super.dispose();
  }

  // Método para enviar el código y empezar el temporizador de verificación
  void _sendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código enviado!')),
    );

    setState(() {
      _selectedMethod = null; // Eliminar selección
      _isResendButtonEnabled = false; // Deshabilitar el botón de reenviar temporalmente
      _startResendCooldownTimer(); // Iniciar cooldown de 2 minutos
      _isSendButtonPressed = true; // Indicar que se ha presionado el botón de enviar
      _startTimer(); // Iniciar el temporizador de verificación
    });
  }

  // Iniciar el temporizador de 4 minutos para la verificación
  void _startTimer() {
    _remainingTime = 240; // Reiniciar el tiempo a 4 minutos
    _timer?.cancel(); // Cancelar cualquier temporizador existente

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel(); // Detener el temporizador
        }
      });
    });
  }

  // Validar el código ingresado
  void _validateCode() {
    String testCode = "12345"; // Código de prueba predeterminado

    setState(() {
      _isCodeValid = _codeController.text == testCode || _codeController.text == "MAR05"; // Validar el código ingresado
    });

    if (_isCodeValid) {
      // Mostrar mensaje de validación correcta
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código aceptado. Validación correcta.')),
      );

      // Navegar a la siguiente pantalla si el código es correcto
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegistroDatosScreen()), // Navegar a la pantalla de registro de datos
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código incorrecto. Inténtalo de nuevo.')),
      );
    }
  }

  // Método para reenviar el código y reiniciar el temporizador de verificación
  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Se volvió a enviar el código!')),
    );

    setState(() {
      _isResendButtonEnabled = false; // Deshabilitar el botón de reenviar
      _resendCooldown = 120; // Tiempo de cooldown: 2 minutos
      _startResendCooldownTimer(); // Iniciar temporizador para reenviar
      _startTimer(); // Reiniciar el temporizador de verificación
    });
  }

  // Iniciar el temporizador de cooldown de 2 minutos para el botón de reenviar
  void _startResendCooldownTimer() {
    _resendTimer?.cancel(); // Cancelar cualquier temporizador existente

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCooldown > 0) {
          _resendCooldown--;
        } else {
          _resendTimer?.cancel(); // Detener el temporizador
          _isResendButtonEnabled = true; // Habilitar el botón de reenviar
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF172329),
      appBar: AppBar(
        title: const Text('Verificación'),
        backgroundColor: const Color(0xFF172329),
      ),
      body: SingleChildScrollView( // Asegurarse de envolver el contenido en SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Se validarán los datos ingresados. Elige cómo deseas recibir tu código:',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedMethod,
                hint: const Text(
                  'Selecciona...',
                  style: TextStyle(color: Colors.white),
                ),
                dropdownColor: const Color(0xFF172329),
                iconEnabledColor: Colors.white,
                items: const [
                  DropdownMenuItem(
                    value: 'Correo',
                    child: Text(
                      'Correo Electrónico',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Celular',
                    child: Text(
                      'Número de Celular',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_selectedMethod != null && !_isSendButtonPressed) // Solo mostrar este botón si se seleccionó un método y no se ha presionado "Enviar"
                ElevatedButton(
                  onPressed: _sendCode,
                  child: const Text('Enviar Código'),
                ),
              const SizedBox(height: 20),
              TextField(
                controller: _codeController,
                maxLength: 5, // Limitar la longitud del código
                decoration: const InputDecoration(
                  labelText: 'Código de Verificación',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateCode,
                child: const Text('Validar Código'),
              ),
              const SizedBox(height: 20),
              // Botón para reenviar el código, siempre visible
              ElevatedButton(
                onPressed: _isResendButtonEnabled ? _resendCode : null, // Se desactiva si no se puede reenviar
                child: Text('Reenviar Código ${_resendCooldown > 0 ? '(${_resendCooldown}s)' : ''}'),
              ),
              const SizedBox(height: 20),
              Text(
                'Tiempo restante: ${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Volver a la pantalla anterior
                },
                child: const Text('Volver', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
