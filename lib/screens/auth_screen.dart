import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:capsule_app/widgets/sign_in_widget.dart";
import "package:capsule_app/widgets/sign_up_widget.dart";
import "package:capsule_app/providers/sign_state_provider.dart";
import "package:google_fonts/google_fonts.dart";
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends ConsumerState<AuthScreen> {

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(loginFormProvider);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("lib/assets/logo.png", height: 175, width: 175),
                const SizedBox(height: 50),
                 Text(
                  "Nice to see you!",
                  style:  GoogleFonts.bebasNeue(fontSize: 54),
                ),const Text(
                  "Let's sign you in!",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                authState == AuthFormState.login
                    ? const SignInWidget()
                    : const SignUpWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
}
