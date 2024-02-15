import 'package:capsule_app/models/medication.dart';
import 'package:capsule_app/services/medications_local_service.dart';
import 'package:capsule_app/widgets/main_screen_med_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}


class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    MedicationsService().updateMedicationsStatusUpdate();
  }
  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout))
      ]),
      drawer: Drawer(
        child: Container(
          color: Colors.deepPurple[200],
          width: 300,
          child: ListView(
            children: [
              const DrawerHeader(
                  child: Center(
                child: Text("C A P S U L E", style: TextStyle(fontSize: 35)),
              )),
              ListTile(
                title: const Text("Home"),
                leading: const Icon(Icons.home),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text("Ask a Question"),
                leading: const Icon(Icons.question_answer),
                onTap: () => Navigator.of(context).pushNamed("/chat-screen"),
              ),
              ListTile(
                title: const Text("My medications"),
                leading: const Icon(Icons.medication),
                onTap: () => Navigator.of(context).pushNamed("/medications"),
              ),
              ExpansionTile(
                title: const Text("Info"),
                leading: const Icon(Icons.info),
                children: [
                  ListTile(
                    title: const Text("About Us"),
                    leading: const Icon(Icons.info),
                    onTap: () => Navigator.of(context).pushNamed("/about-us"),
                  ),
                  ListTile(
                    title: const Text("Contact Us"),
                    leading: const Icon(Icons.info),
                    onTap: () => Navigator.of(context).pushNamed("/contact-us"),
                  ),
                  Padding(padding: const EdgeInsets.only(top:30,bottom: 5),child: IconButton(onPressed: () async => await firebaseAuth.signOut() ,icon: const Icon(Icons.output_sharp)),)
                ],
              ),
            ],
          ),
        ),
      ),
     body: FutureBuilder<List<Medication>>(
  future: MedicationsService().getMedicationsFromLocal(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    }
    final medications = snapshot.data ?? [];
    return ListView.builder(
      itemCount: medications.length,
      itemBuilder: (context, index) {
        return MedicationCard(medication: medications[index]);
      },
    );
  },
),

    );
  }
}
