import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Acerca de")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              SizedBox(height: 20),
              Text(
                "App de Libros",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text("Versión 2.0.0"),
              SizedBox(height: 20),
              Text(
                "Desarrollado por:\nDavid Daniel Lucana Mamani",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Instituto Tecnológico INFOCAL — La Paz\nMateria: Programación Móvil II",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
