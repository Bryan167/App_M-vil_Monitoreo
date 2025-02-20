import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuarios {
//Generar instancia 


  static late SharedPreferences _prefs;
//esto es para Inicializar las preferencias 
  static Future init () async{
    _prefs = await SharedPreferences.getInstance();
  }


  String get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login' ;
  }

  set ultimaPagina(String value){
    _prefs.setString('ultimaPagina', value);

  }


}