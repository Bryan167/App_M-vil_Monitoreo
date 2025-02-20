import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:monitoreo_lugares_tk/pages/Home2_pages.dart';
import 'package:monitoreo_lugares_tk/pages/registro_pages.dart';

class LoginPages extends StatelessWidget {
  static const String routename = 'login';
  LoginPages({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signWithEmailAndPassword(String emailAddress, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      print('User logged in successfully: ${credential.user!.email}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home2Pages()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    await saveUserData(userCredential.user);

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home2Pages()));
    return userCredential;
  }

  Future<void> saveUserData(User? user) async {
    if (user == null) return;

    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference.child('users').child(user.uid).set({
      'displayName': user.displayName,
      'email': user.email,
    });
  }

  @override
Widget build(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return Scaffold(
    appBar: AppBar(
      title: const Text("WELCOME"),
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: Colors.blue,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 28,
      ),
    ),
    backgroundColor: Colors.blue[50],
    body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo de la aplicación
            Center(
              child: Image.asset(
                'assets/logo_login.jpg',
                height: 350,
              ),
            ),
            const SizedBox(height: 30),

            // Campo de texto: Correo
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The email is required';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Colors.blue),
                labelText: "Enter email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Campo de texto: Contraseña
            TextFormField(
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The password is required';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                labelText: "Enter Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Botón de inicio de sesión
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final String emailAddress = emailController.text;
                  final String password = passwordController.text;
                  signWithEmailAndPassword(emailAddress, password, context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "LOGIN",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

            // Botón de Google
            Center(
              child: Column(
                children: [
                  const Text("Or sign in with"),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent, width: 2),
                    ),
                    child: IconButton(
                      onPressed: () {
                        signInWithGoogle(context);
                      },
                      icon: const Icon(
                        FontAwesomeIcons.google,
                        color: Colors.redAccent,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Registro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account yet?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistroPages()),
                    );
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}
