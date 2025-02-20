import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:monitoreo_lugares_tk/services/FirebaseService.dart';

class GraficaPages extends StatefulWidget {
  static const String routename = 'Grafica de datos ';

  const GraficaPages({Key? key}) : super(key: key);

  @override
  State<GraficaPages> createState() => _GraficaPagesState();
}

class _GraficaPagesState extends State<GraficaPages> {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic> _datos = {};
  Map<String, dynamic> _datosFiltrados = {};
  bool _cargando = true;
  String? _fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  /// Cargar los datos desde Firebase
  Future<void> _cargarDatos() async {
    try {
      final datos = await _firebaseService.leerDatos();
      setState(() {
        _datos = datos;
        _fechaSeleccionada = _obtenerFechasDisponibles().first;
        _filtrarDatosPorFecha(_fechaSeleccionada!);
        _cargando = false;
      });
    } catch (e) {
      print("Error al cargar datos: $e");
      setState(() {
        _cargando = false;
      });
    }
  }

  /// Obtener las fechas únicas disponibles en los datos
  List<String> _obtenerFechasDisponibles() {
    final fechas = _datos.keys.map((key) => key.split(' ')[0]).toSet().toList();
    fechas.sort(); // Ordenar cronológicamente
    return fechas;
  }

  /// Filtrar los datos para una fecha específica
  void _filtrarDatosPorFecha(String fecha) {
    final datosFiltrados = Map.fromEntries(
      _datos.entries.where((entry) => entry.key.startsWith(fecha)),
    );
    setState(() {
      _datosFiltrados = datosFiltrados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gráfica de datos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
    Navigator.pop(context); 
  },
),
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _datos.isEmpty
              ? const Center(
                  child: Text(
                    "No hay registros disponibles.",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    // Fila con texto y selector de fecha
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Escoger fecha: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: DropdownButton<String>(
                              value: _fechaSeleccionada,
                              items: _obtenerFechasDisponibles()
                                  .map((fecha) => DropdownMenuItem(
                                        value: fecha,
                                        child: Text(fecha),
                                      ))
                                  .toList(),
                              onChanged: (nuevaFecha) {
                                if (nuevaFecha != null) {
                                  setState(() {
                                    _fechaSeleccionada = nuevaFecha;
                                    _filtrarDatosPorFecha(nuevaFecha);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gráficos
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildChart(
                                'Temperatura', 'temperature', Colors.red, 0, 100),
                            _buildChart(
                                'Humedad', 'humidity', Colors.yellow, 0, 100),
                            _buildChart('Gas', 'gas', Colors.green, 0, 300),
                            _buildChart('ph', 'pH_value', Colors.blue, 0, 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  /// Método para construir un gráfico lineal
  Widget _buildChart(String titulo, String keyParam, Color color, double minY, double maxY) {
    final List<FlSpot> spots = [];
    int index = 0;

    // Ordenar las claves de _datosFiltrados cronológicamente
    final sortedKeys = _datosFiltrados.keys.toList()..sort();

    for (var dateTimeKey in sortedKeys) {
      final values = _datosFiltrados[dateTimeKey];
      final value = values[keyParam];
      if (value != null) {
        spots.add(FlSpot(index.toDouble(), value.toDouble()));
        index++;
      }
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  minX: 0,
                  maxX: spots.isEmpty ? 0 : (spots.length - 1).toDouble(),
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: (maxY - minY) / 4,
                    drawVerticalLine: false,
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: (maxY - minY) / 4,
                        getTitlesWidget: (value, meta) {
                          return value % 1 == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < sortedKeys.length) {
                            final key = sortedKeys[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                key.split(' ')[1], // Mostrar solo la hora
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border.symmetric(
                      horizontal: BorderSide(width: 1),
                      vertical: BorderSide(width: 1),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            'Valor: ${spot.y.toStringAsFixed(2)}',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}