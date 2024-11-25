import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; // Asegúrate de importar tu pantalla de inicio (dashboard)

class RegistroDatosScreen extends StatefulWidget {
  const RegistroDatosScreen({super.key});

  @override
  RegistroDatosScreenState createState() => RegistroDatosScreenState();
}

class RegistroDatosScreenState extends State<RegistroDatosScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _numeroContactoController = TextEditingController();
  String? _tipoSangre; // Para el tipo de sangre
  bool _esSaludSeleccionado = false; // Para el tipo de seguro
  bool _otrosSeleccionado = false; // Para el tipo de seguro
  final TextEditingController _otrosSeguroController = TextEditingController(); // Para otros tipos de seguro
  String _numeroError = ""; // Para almacenar el mensaje de error del número de contacto

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _numeroContactoController.dispose();
    _otrosSeguroController.dispose();
    super.dispose();
  }

  void _guardarDatos() {
    // Validar todos los campos
    if (_nombreController.text.isEmpty || _apellidoController.text.isEmpty ||
        _numeroContactoController.text.isEmpty || _tipoSangre == null || 
        (!_esSaludSeleccionado && !_otrosSeleccionado)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    // Guardar nombre en SharedPreferences
    _guardarNombre();

    // Aquí puedes guardar los datos, por ahora solo mostramos un mensaje
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Éxito'),
          content: const Text('Los datos se guardaron con éxito.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Redirigir al dashboard
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _guardarNombre() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre_usuario', _nombreController.text);
  }

  void _validarNumeroContacto(String value) {
    // Validar si el número es correcto
    if (value.isNotEmpty) {
      final bool esCelular = value.startsWith('9') && value.length == 9; // Celular
      final bool esFijo = value.startsWith('01') && value.length >= 7 && value.length <= 9; // Fijo
      if (!esCelular && !esFijo) {
        setState(() {
          _numeroError = "El número debe comenzar con 9 (celular) o 01 (fijo) y ser válido.";
        });
      } else {
        setState(() {
          _numeroError = ""; // Limpiar mensaje de error si el número es válido
        });
      }
    } else {
      setState(() {
        _numeroError = ""; // Limpiar mensaje de error si el campo está vacío
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF172329),
      appBar: AppBar(
        title: const Text('Registro de Datos'),
        backgroundColor: const Color(0xFF172329),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DATOS DEL USUARIO',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombres Completos',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _apellidoController,
              decoration: const InputDecoration(
                labelText: 'Apellidos Completos',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'TIPO DE SANGRE',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _tipoSangre,
              hint: const Text(
                'Selecciona un tipo de sangre',
                style: TextStyle(color: Colors.white),
              ),
              dropdownColor: const Color(0xFF172329),
              iconEnabledColor: Colors.white,
              items: const [
                DropdownMenuItem(
                  value: 'A+',
                  child: Text('A+', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'A-',
                  child: Text('A-', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'B+',
                  child: Text('B+', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'B-',
                  child: Text('B-', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'AB+',
                  child: Text('AB+', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'AB-',
                  child: Text('AB-', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'O+',
                  child: Text('O+', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'O-',
                  child: Text('O-', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _tipoSangre = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'NÚMERO DE CONTACTO',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numeroContactoController,
              decoration: const InputDecoration(
                labelText: 'Número de Contacto',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.phone,
              onChanged: _validarNumeroContacto, // Validación en tiempo real
            ),
            const SizedBox(height: 5),
            if (_numeroError.isNotEmpty) // Mostrar mensaje de error
              Text(
                _numeroError,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            const SizedBox(height: 20),
            const Text(
              'TIPO DE SEGURO',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Checkbox(
                  value: _esSaludSeleccionado,
                  onChanged: (bool? value) {
                    setState(() {
                      _esSaludSeleccionado = value!;
                      if (_esSaludSeleccionado) {
                        _otrosSeleccionado = false; // Desactivar "Otros" si se selecciona "EsSalud"
                      }
                    });
                  },
                ),
                const Text('EsSalud', style: TextStyle(color: Colors.white)),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _otrosSeleccionado,
                  onChanged: (bool? value) {
                    setState(() {
                      _otrosSeleccionado = value!;
                      if (_otrosSeleccionado) {
                        _esSaludSeleccionado = false; // Desactivar "EsSalud" si se selecciona "Otros"
                      }
                    });
                  },
                ),
                const Text('Otros', style: TextStyle(color: Colors.white)),
              ],
            ),
            if (_otrosSeleccionado) // Mostrar campo adicional si "Otros" está seleccionado
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Indica el tipo de seguro y el nombre de la clínica:',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextField(
                    controller: _otrosSeguroController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Seguro',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarDatos,
              child: const Text('Guardar Datos'),
            ),
          ],
        ),
      ),
    );
  }
}
