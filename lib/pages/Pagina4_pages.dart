
import 'package:flutter/material.dart';
import 'package:monitoreo_lugares_tk/pages/FirebaseSerDatos.dart';
import 'package:monitoreo_lugares_tk/pages/Pagina3_pages.dart';

class Pagina4 extends StatefulWidget {
  const Pagina4({super.key});

  @override
  _Pagina4State createState() => _Pagina4State();
}

class _Pagina4State extends State<Pagina4> {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic> _datos = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final datos = await _firebaseService.leerDatos();
      setState(() {
        _datos = datos;
        _cargando = false;
      });
    } catch (e) {
      print("Error al cargar datos: $e");
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registros de Datos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Pagina3()), // Redirige a Pagina1
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _datos.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay registros disponibles.",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: _datos.entries.map((entry) {
                            final time = entry.key;
                            final dynamic value = entry.value;

                            if (value is! Map) {
                              return _buildErrorCard(entry.key, value);
                            }

                            final Map<String, dynamic> data =
                                Map<String, dynamic>.from(value);

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Fecha y Hora: $time",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildRow(
                                        Icons.thermostat, "Temperatura", data['temperature'], suffix: "°C"),
                                    _buildRow(Icons.opacity, "Humedad", data['humidity'], suffix: "%"),
                                    _buildRow(Icons.cloud, "Calidad del Aire", data['airQuality']),
                                    _buildRow(Icons.gas_meter, "Gas", data['gas'], suffix: " ppm"),
                                    _buildRow(Icons.water, "pH", data['pH_value'], suffix: " "),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0), // Espacio alrededor del botón
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Color de fondo
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/Grafica2Datos');
                },
                child: const Text(
                  "Gráfico de Datos",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white, // Texto blanco
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, dynamic value, {String suffix = ""}) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text("$label: ${value ?? 'No disponible'}$suffix"),
      ],
    );
  }

  Widget _buildErrorCard(String key, dynamic value) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fecha y Hora: $key",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Error: Estructura de datos inválida.",
              style: const TextStyle(color: Colors.red),
            ),
            Text(
              "Valor recibido: $value",
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
