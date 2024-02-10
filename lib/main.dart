import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:capsule_app/firebase_options.dart';
import 'package:capsule_app/screens/about_screen.dart';
import 'package:capsule_app/screens/add_medication.dart';
import 'package:capsule_app/screens/auth_screen.dart';
import 'package:capsule_app/screens/chat_screen.dart';
import 'package:capsule_app/screens/contact_us_screen.dart';
import 'package:capsule_app/screens/main_screen.dart';
import 'package:capsule_app/screens/medication_details.dart';
import 'package:capsule_app/screens/medications.dart';
import 'package:capsule_app/services/notification_controller.dart';
import 'package:capsule_app/widgets/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:firebase_auth/firebase_auth.dart";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: "basic_channel_group",
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notifications scheduled by the app',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
    channelGroups: [NotificationChannelGroup(channelGroupKey: "basic_channel_group", channelGroupName: "Basic Group")]
  );
  bool isNotificationsAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isNotificationsAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );
  }
 @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Capsule App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return const SplashScreen();

        }
        if (snapshot.hasData){
          return const MainScreen();
        }
        else{
          return const AuthScreen();
        }
      })
      ,
      routes: {
        "/chat": (ctx) => const ChatScreen(),
        "/medications": (ctx) => const Medications(),
        "/chat-screen": (ctx) => const ChatScreen(),
        "/about-us": (ctx) => const AboutScreen(),
        "/contact-us": (ctx) => const ContactScreen(),
        "/add-medication": (ctx) => const AddMedication(),
        "/medication-details": (ctx) =>  const MedicationDetails(medication: null),
      }
    );
  }
}

