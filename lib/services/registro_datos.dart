import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// Método para registrar datos con fecha y hora
  Future<void> registrarDatos({
    required int cantidadPersonas,
    required String airQuality,
    required double gas,
    required double humidity,
    required double pH,
    required double temperature,
  }) async {
    try {
      // Obtén la fecha y hora actual
      DateTime now = DateTime.now();
      String year = now.year.toString(); // Cambiado de "año" a "year"
      String month = now.month.toString().padLeft(2, '0'); // Cambiado de "mes"
      String day = now.day.toString().padLeft(2, '0'); // Cambiado de "dia"
      String time = "${now.hour}:${now.minute}:${now.second}"; // Cambiado de "hora"

      // Construye la referencia de la base de datos
      DatabaseReference ref = _database.child('sensors/registros/$year/$month/$day/$time');

      // Datos a guardar
      Map<String, dynamic> data = {
        'Cantidad_de_Personas': cantidadPersonas,
        'airQuality': airQuality,
        'gas': gas,
        'humidity': humidity,
        'pH_value': pH,
        'temperature': temperature,
      };

      // Subir datos a Firebase
      await ref.set(data);

      print("Datos registrados correctamente en $year-$month-$day $time.");
    } catch (e) {
      print("Error al registrar datos: $e");
    }
  }
}
