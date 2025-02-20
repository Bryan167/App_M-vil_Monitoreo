import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:monitoreo_lugares_tk/pages/Home2_pages.dart';
import 'package:monitoreo_lugares_tk/pages/login_pages.dart';

class RegistroPages extends StatelessWidget {
  RegistroPages({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpswController = TextEditingController();

  Future<void> signUpAndSaveData(
    String emailAddress, String password, String username, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    await saveUserData(credential.user!.uid, emailAddress, username);

    // Navegar a Home2Pages después del registro exitoso
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home2Pages()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The password provided is too weak.')),
      );
      passwordController.clear();
      confirmpswController.clear();
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The account already exists for that email.')),
      );
      emailController.clear();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred: $e')),
    );
  }
}

  Future<void> saveUserData(String userId, String emailAddress, String username) async {
    try {
      final databaseReference = FirebaseDatabase.instance.ref();

      await databaseReference.child('user').child(userId).set({
        'email': emailAddress,
        'username': username,
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
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
              // Logo de registro
              Center(
                child: Image.asset(
                  'assets/logo_register.png',
                  height: 350,
                ),
              ),
              const SizedBox(height: 20),

              // Campo: Nombre de usuario
              TextFormField(
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The username is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Enter username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Campo: Correo electrónico
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The email is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Enter email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Campo: Contraseña
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
                  labelText: "Enter password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Campo: Confirmar contraseña
              TextFormField(
                controller: confirmpswController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Confirm password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botón de registro
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final String username = usernameController.text;
                    final String emailAddress = emailController.text;
                    final String password = passwordController.text;
                    signUpAndSaveData(emailAddress, password, username, context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 15),

              // Botón para iniciar sesión
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPages()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.blueAccent),
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
