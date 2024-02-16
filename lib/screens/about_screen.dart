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
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Kerem Üzer",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
             SizedBox(width: 30),
             Text("Developer",style: TextStyle(fontSize: 12)),
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Ahmet Hakan Paksoy",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
             SizedBox(width: 30),
             Text("Developer",style: TextStyle(fontSize: 12)),
          ],
        ),  SizedBox(height: 30),    
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Osman Tırpan",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
             SizedBox(width: 30),
             Text("Developer",style: TextStyle(fontSize: 12)),
          ],
        ),
     
              ],
            ),
    );
  }
}
