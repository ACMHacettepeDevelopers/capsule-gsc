import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:capsule_app/widgets/sign_in_widget.dart";
import "package:capsule_app/widgets/sign_up_widget.dart";
import "package:capsule_app/providers/sign_state_provider.dart";
import "package:sign_in_button/sign_in_button.dart";


class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loginFormProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                  margin: const EdgeInsets.all(16),
                  child: authState == AuthFormState.login ? const SignInWidget() : const SignUpWidget() ),
                  SizedBox(height: 30,child: SignInButton(Buttons.google,text: "Continue with Google", onPressed: () async => _handleGoogleSignIn() ),),
              
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final googleProvider = GoogleAuthProvider();
    try{
    await _auth.signInWithProvider(googleProvider);}
    catch(e){
      print(e);
    }
  }
}
