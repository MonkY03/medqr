import 'package:flutter/material.dart';

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
