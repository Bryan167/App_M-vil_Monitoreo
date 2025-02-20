import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// Método para leer datos desde Firebase
  Future<Map<String, dynamic>> leerDatos() async {
    try {
      DatabaseReference ref = _database.child('sensors/registros2');
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        Map<String, dynamic> processedData = {};
        Map<dynamic, dynamic> nestedData = snapshot.value as Map;

        // Iterar por cada nivel de la estructura jerárquica
        nestedData.forEach((yearKey, yearValue) {
          (yearValue as Map).forEach((monthKey, monthValue) {
            (monthValue as Map).forEach((dayKey, dayValue) {
              (dayValue as Map).forEach((timeKey, timeValue) {
                // Combinar las claves con formato completo
                String fullDateTime = "$yearKey-$monthKey-$dayKey $timeKey";
                processedData[fullDateTime] = timeValue; // Guardar con clave de fecha completa
              });
            });
          });
        });

        print("Datos procesados correctamente: $processedData");
        return processedData;
      } else {
        print("No se encontraron datos.");
        return {};
      }
    } catch (e) {
      print("Error al leer datos de Firebase: $e");
      return {};
    }
  }
}