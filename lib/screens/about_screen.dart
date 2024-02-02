import "package:flutter/material.dart";
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  //build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
      ),
      body: const Center(
        child: Text("About us Screen"),
      ),
    );
  }
}