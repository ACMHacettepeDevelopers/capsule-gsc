import 'package:capsule_app/widgets/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout))
      ]),
      drawer: Drawer(
        child: Container(
          color: Colors.deepPurple[200],
          child: ListView(
            children: const [
              DrawerHeader(
                  child: Center(
                child: Text("C A P S U L E", style: TextStyle(fontSize: 35)),
                
              )),
              DrawerWidget(title: "Home Screen",),
              DrawerWidget(title: "Calendar",),
              DrawerWidget(title: "Profile",),
              DrawerWidget(title: "Theme",),
              
            ],
          ),
        ),
    ));
  }
}
