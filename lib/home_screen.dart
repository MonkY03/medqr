import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF172329), // Fondo oscuro
      appBar: AppBar(
        title: const Text('Dashboard de Datos Médicos'),
        backgroundColor: const Color(0xFF172329), // Color del AppBar igual que el fondo
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Espaciado alrededor de la cuadrícula
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centra la cuadrícula verticalmente
            children: [
              FutureBuilder<String?>(
                future: _cargarNombre(), // Carga el nombre guardado
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Muestra un cargador mientras se carga el nombre
                  } else if (snapshot.hasError) {
                    return const Text('Error al cargar el nombre'); // Manejo de errores
                  } else {
                    final nombre = snapshot.data ?? 'Usuario'; // Nombre por defecto si no se encuentra
                    return Text(
                      'Hola, $nombre!', // Saludo con el nombre
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 40), // Espacio entre el saludo y la cuadrícula
              GridView.count(
                shrinkWrap: true, // Evita que ocupe más espacio del necesario
                crossAxisCount: 2, // 2 columnas en la cuadrícula
                mainAxisSpacing: 16.0, // Espaciado vertical entre los botones
                crossAxisSpacing: 16.0, // Espaciado horizontal entre los botones
                children: [
                  _buildCustomButton(
                    context,
                    'Registrar Datos Médicos',
                    Icons.add_circle,
                    Colors.green,
                    () {
                      // Acción del botón Registrar Datos Médicos
                    },
                  ),
                  _buildCustomButton(
                    context,
                    'Ver Datos Médicos',
                    Icons.visibility,
                    Colors.blue,
                    () {
                      // Acción del botón Ver Datos Médicos
                    },
                  ),
                  _buildCustomButton(
                    context,
                    'Eliminar Datos Médicos',
                    Icons.delete,
                    Colors.red,
                    () {
                      // Acción del botón Eliminar Datos Médicos
                    },
                  ),
                  _buildCustomButton(
                    context,
                    'Editar Datos Médicos',
                    Icons.edit,
                    Colors.orange,
                    () {
                      // Acción del botón Editar Datos Médicos
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método que carga el nombre del usuario desde SharedPreferences
  Future<String?> _cargarNombre() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nombre = prefs.getString('nombre_usuario');
    debugPrint('Nombre cargado: $nombre'); // Usa debugPrint para mostrar el nombre cargado
    return nombre; // Devuelve el nombre guardado
  }

  // Método que crea un botón personalizado
  Widget _buildCustomButton(BuildContext context, String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Color de fondo del botón
        foregroundColor: Colors.white, // Color del texto/icono
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0), // Tamaño del botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
        ),
        elevation: 8, // Sombra
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48), // Icono de tamaño grande
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Texto del botón
          ),
        ],
      ),
    );
  }
}

