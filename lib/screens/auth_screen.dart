import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:capsule_app/widgets/sign_in_widget.dart";
import "package:capsule_app/widgets/sign_up_widget.dart";
import "package:capsule_app/providers/sign_state_provider.dart";


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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                  margin: const EdgeInsets.all(16),
                  child: authState == AuthFormState.login ? const SignInWidget() : const SignUpWidget() ),
            ],
          ),
        ),
      ),
    );
  }
}
