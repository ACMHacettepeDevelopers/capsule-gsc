import "package:capsule_app/screens/medication_details.dart";
import "package:capsule_app/services/medications_local_service.dart";
import "package:flutter/material.dart";
import "package:capsule_app/models/medication.dart";

class Medications extends StatelessWidget {
  const Medications({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final MedicationsService medicationsService = MedicationsService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medications"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/add-medication");
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: StreamBuilder(
          stream: medicationsService.getMedications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You have no medications."),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/add-medication");
                      },
                      child: const Text("Add Medication"),
                    ),
                  ],
                ),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Medication medication = snapshot.data![index];
                // card with background image based on medication type
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MedicationDetails(medication: medication)));
                  },
                  onLongPress: (){
                    medicationsService.deleteMedication(medication);
                  },
                  child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: medication.medicationType == MedicationType.pill ? Image.asset(
                                "lib/assets/pill.jpeg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150.0,
                              ): Image.asset("lib/assets/needle.jpeg",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150.0,
                              ),  
                            ),
                            Positioned(
                              bottom: 8.0,
                              left: 8.0,
                              child: Text(
                                medication.name,
                                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                );

                
              },
            );
          }),
    );
  }
}
