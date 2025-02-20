import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monitoreo_lugares_tk/pages/Dashboard1_pages.dart';
import 'package:monitoreo_lugares_tk/pages/Dashboard3_pages.dart';
import 'package:monitoreo_lugares_tk/pages/login_pages.dart';

class Home2Pages extends StatelessWidget {
  Home2Pages({super.key});
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _handleSignOut(BuildContext context) async {
    try {
      FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPages()),
      );
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagina de Inicio"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.lightBlue[200],
          fontWeight: FontWeight.w800,
          fontSize: 28,
        ),
        actions: [
          IconButton(
            onPressed: () => _handleSignOut(context),
            icon: const Icon(Icons.logout, color: Colors.black),
            tooltip: "Logout",
          ),
        ],
      ),
    body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: SingleChildScrollView( // ← Agregado para permitir el desplazamiento
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botón AGUAMANIA
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, Dashboard1.routename);
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    'assets/logo_guayabal.jpg', 
                    height: 305,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Guayabal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Botón GUAYABAL
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, Dashboard3.routename);
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    'assets/tropical.png', 
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Tropical Club',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),
);
  }
}
