import "package:flutter/material.dart";
class ContactScreen extends StatelessWidget {
  const ContactScreen
({Key? key}) : super(key: key);
  //build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: const Center(
        child: Text("Contact us Screen"),
      ),
    );
  }
}