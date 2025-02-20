import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:monitoreo_lugares_tk/firebase_options.dart';
import 'package:monitoreo_lugares_tk/pages/Dashboard1_pages.dart';
import 'package:monitoreo_lugares_tk/pages/Dashboard2_pages.dart';
import 'package:monitoreo_lugares_tk/pages/Dashboard3_pages.dart';
import 'package:monitoreo_lugares_tk/pages/Grafica2_pages.dart';
import 'package:monitoreo_lugares_tk/pages/Grafica_pages.dart';
import 'package:monitoreo_lugares_tk/pages/Home2_pages.dart';
import 'package:monitoreo_lugares_tk/pages/Pagina2_pages.dart';
import 'package:monitoreo_lugares_tk/pages/login_pages.dart';
import 'package:monitoreo_lugares_tk/preferencias/pre_usuarios.dart';
import 'package:monitoreo_lugares_tk/services/ui_provider_dashboard1.dart';
import 'package:provider/provider.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {


  print("Handling a background message: ${message.messageId}");
}

bool userauth = false;

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  await PreferenciasUsuarios.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  requestNotificationPermission();
   await FirebaseMessaging.instance.setAutoInitEnabled(true);
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
   FirebaseMessaging.onMessage.listen((RemoteMessage message){
    print('got a message whilst in the foreground');
    print('Message data: ${message.data}');

    if(message.notification != null){
      print('Message also contained a notification: ${message.notification}');
    }

   });
   final fcmToken = await FirebaseMessaging.instance.getToken();
   print('Message data: $fcmToken');
  
   FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
      userauth= false;
    } else {
      print('User is signed in!');
      userauth= true;
    }
  });
  
  
     runApp(MyApp());
}

Future<void> requestNotificationPermission() async{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: false,

  );
  print('Notification permission grated: ${settings.authorizationStatus}');
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

    final prefs = PreferenciasUsuarios();

  @override
  Widget build(BuildContext context) {
    
   return MultiProvider(
    providers: [ChangeNotifierProvider(create:(_)=> UiProvider())],

    child:  MaterialApp(
     debugShowCheckedModeBanner: false,
     initialRoute: LoginPages.routename,
     routes: {
      LoginPages.routename  :(context) => LoginPages(),
      Dashboard1.routename :(context) => const Dashboard1(),
      FloatingPage.routename   :(context) => const FloatingPage(),
      Pagina2.routename    :(context) => const Pagina2(),
      Dashboard3.routename :(context) => const Dashboard3(),
      '/GraficaDatos': (context) => GraficaPages(),  
      '/Grafica2Datos': (context) => Grafica2Pages(),  
       },
       home: userauth? Home2Pages(): LoginPages(),
    ),
   );
  }
  
}