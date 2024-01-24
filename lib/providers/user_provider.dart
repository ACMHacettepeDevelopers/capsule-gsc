import 'package:capsule_app/models/client_user.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:firebase_auth/firebase_auth.dart";

class UserProvider extends Notifier<ClientUser> {
  @override
  ClientUser build() {  
    return ClientUser(id: FirebaseAuth.instance.currentUser!.uid);
  }
  void fetchUser(Map<String,dynamic> parsedJson){
    state = ClientUser.fromJson(parsedJson);

  }
  
}