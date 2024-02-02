import "package:flutter/material.dart";
class Medications extends StatelessWidget {
  const Medications({Key? key}) : super(key: key);
  //build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medications"),
      ),
      body: const Center(
        child: Text("Medications Screen"),
      ),
    );
  }
}