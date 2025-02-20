
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monitoreo_lugares_tk/pages/Home2_pages.dart';

class Pagina3 extends StatefulWidget {
  const Pagina3({super.key});

  @override
  _Pagina3State createState() => _Pagina3State();
}


class _Pagina3State extends State<Pagina3> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.ref();

  AnimationController? progressController;
  Animation<double>? tempAnimation;
  Animation<double>? humidityAnimation;
  Animation<double>? gasAnimation;
  Animation<double>? phAnimation;

  String airQuality = "";
  int peopleCount = 0;

  @override
  void initState() {
    super.initState();

    // Fetch data from Firebase
    databaseReference.child('sensors/lugar2').once().then((snapshot) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      double temp = data['temperature'];
      double humidity = data['humidity'];
      double gas = data['gas'];
      double ph = data['pH_value'] ?? 0;
      peopleCount = data['Cantidad de Personas'] ?? 0;

      setState(() {
        isLoading = true;
        airQuality = airQualityStatus(gas);
      });
      _Pagina1Init(temp, humidity, gas, ph);
    });
  }

  void _Pagina1Init(double temp, double humid, double gas, double ph) {
    progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    );

    tempAnimation = Tween<double>(begin: 0, end: temp).animate(progressController!)
      ..addListener(() {
        setState(() {});
      });

    humidityAnimation = Tween<double>(begin: 0, end: humid).animate(progressController!)
      ..addListener(() {
        setState(() {});
      });

    gasAnimation = Tween<double>(begin: 0, end: gas).animate(progressController!)
      ..addListener(() {
        setState(() {});
      });

    phAnimation = Tween<double>(begin: 0, end: ph).animate(progressController!)
      ..addListener(() {
        setState(() {});
      });

    progressController!.forward();
  }

  String airQualityStatus(double gasValue) {
    if (gasValue > 0 && gasValue <= 50) {
      return "Good";
    } else if (gasValue > 50 && gasValue <= 100) {
      return "Average";
    } else if (gasValue > 100 && gasValue <= 150) {
      return "Little Bad";
    } else if (gasValue > 150 && gasValue <= 200) {
      return "Bad";
    } else if (gasValue > 200 && gasValue <= 300) {
      return "Worse";
    } else {
      return "Very Bad";
    }
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
        title: const Text('Tropical Club'),
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
      body: Container(
        color: Colors.teal[50], // Fondo de pantalla
        child: isLoading
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Imagen en la parte superior
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
                            image: AssetImage('assets/tropical_log.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Descripción
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
                          "Tropical Club es un lugar turístico que ofrece una experiencia única con múltiples servicios, como piscinas, sauna, turco e hidromasaje. Este panel muestra información en tiempo real sobre las condiciones ambientales y el número de personas presentes, asegurando una experiencia cómoda y segura para todos los visitantes.",

                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Indicadores
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          // Temperature
                          buildRectIndicator(
                            icon: Icons.thermostat,
                            label: 'Temperature',
                            value: '${tempAnimation!.value.toInt()} °C',
                            color: Colors.red,
                          ),
                          // Humidity
                          buildRectIndicator(
                            icon: Icons.water_drop,
                            label: 'Humidity',
                            value: '${humidityAnimation!.value.toInt()} %',
                            color: Colors.blue,
                          ),
                          // Gas
                          buildRectIndicator(
                            icon: Icons.gas_meter,
                            label: 'Gas',
                            value: '${gasAnimation!.value.toInt()} ppm',
                            color: Colors.black,
                          ),
                          // pH
                          buildRectIndicator(
                            icon: Icons.science,
                            label: 'pH Level',
                            value: '${phAnimation!.value.toStringAsFixed(1)}',
                            color: Colors.green,
                          ),
                          // Air Quality
                          buildRectIndicator(
                            icon: Icons.air,
                            label: 'Air Quality',
                            value: airQuality,
                            color: Colors.purple,
                          ),
                          // People Count
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
              )
            : const Center(child: CircularProgressIndicator()),
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
