import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  //build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ABOUT US",
          style: GoogleFonts.bebasNeue(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Capsule is a medication reminder and tracker app! This application aims to assist users in managing their medications effectively. The app features a user-friendly interface, medication reminders, and an AI chatbot to help users understand their medications better.",
              style: GoogleFonts.rubik(),
            ),
          ),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Kerem Üzer",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 30),
              Text("Developer", style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ahmet Hakan Paksoy",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 30),
              Text("Developer", style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Osman Tırpan",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 30),
              Text("Developer", style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
