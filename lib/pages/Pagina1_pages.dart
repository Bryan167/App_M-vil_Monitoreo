
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monitoreo_lugares_tk/pages/Home2_pages.dart';

class Pagina1 extends StatefulWidget {
  @override
  _Pagina1State createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> with TickerProviderStateMixin {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.ref();

  AnimationController? progressController;
  double temp = 0; 
  double humidity = 0;
  int gas = 0;
  double ph = 0;

  String airQuality = "Loading...";
  int peopleCount = 0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
  }

  void _updateAnimations(double temp, double humid, double gas, double ph) {

  progressController!.forward(from: 0);
}
  String airQualityStatus(double gasValue) {
    if (gasValue > 0 && gasValue <= 50) return "Good";
    if (gasValue > 50 && gasValue <= 100) return "Average";
    if (gasValue > 100 && gasValue <= 150) return "Little Bad";
    if (gasValue > 150 && gasValue <= 200) return "Bad";
    if (gasValue > 200 && gasValue <= 300) return "Worse";
    return "Very Bad";
  }

  @override
  void dispose() {
    progressController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guayabal'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home2Pages()),
            );
          },
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
  stream: databaseReference.child('sensors/lugar1').onValue,
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
        return const Center(child: CircularProgressIndicator());
      }

      // 🔍 Depuración: Ver datos de Firebase
      print("🔥 Datos de Firebase: ${snapshot.data?.snapshot.value}");

      final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

      // Conversión segura
      double temp = (data['temperature'] is num) ? (data['temperature'] as num).toDouble() : 0.0;
      double humidity = (data['humidity'] is num) ? (data['humidity'] as num).toDouble() : 0.0;
      double gas = (data['gas'] is num) ? (data['gas'] as num).toDouble() : 0.0;
      double ph = (data['pH_value'] is num) ? (data['pH_value'] as num).toDouble() : 0.0;
      int newPeopleCount = (data['Cantidad_de_Personas'] ?? 0).toInt();

      // ✅ Actualizar las variables de la UI y animaciones
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            peopleCount = newPeopleCount;
            airQuality = airQualityStatus(gas);
          });

          // ✅ Llamar a `_updateAnimations` solo si los valores han cambiado
          _updateAnimations(temp, humidity, gas, ph);
        }
      });

      return Container(
        color: Colors.teal[50],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                  Container(
                    height: 115,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage('assets/Guayabal1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Guayabal es un lugar turístico que ofrece una experiencia única con múltiples servicios, como piscinas, toboganes y áreas deportivas. Este panel muestra información en tiempo real sobre las condiciones ambientales y el número de personas presentes, asegurando una experiencia cómoda y segura para todos los visitantes.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      buildRectIndicator(
                        icon: Icons.thermostat,
                        label: 'Temperature',
                        value: '${temp.round()}°C',
                        color: Colors.red,
                      ),
                      buildRectIndicator(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '${humidity.round()}°C',
                        color: Colors.blue,
                      ),
                      buildRectIndicator(
                        icon: Icons.gas_meter,
                        label: 'Gas',
                        value: '${gas.round()}ppm',
                        color: Colors.black,
                      ),
                      buildRectIndicator(
                        icon: Icons.science,
                        label: 'pH Level',
                        value: '${ph.toStringAsFixed(2)}',
                        color: Colors.green,
                      ),
                      buildRectIndicator(
                        icon: Icons.air,
                        label: 'Air Quality',
                        value: airQuality,
                        color: Colors.purple,
                      ),
                      buildRectIndicator(
                        icon: Icons.people,
                        label: 'People',
                        value: '$peopleCount',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRectIndicator({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 160,
      height: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
