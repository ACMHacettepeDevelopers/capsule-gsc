
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:capsule_app/providers/sign_state_provider.dart";
import "package:capsule_app/utils/validators.dart";

final _firebase = FirebaseAuth.instance;

class SignInWidget extends ConsumerStatefulWidget {
  const SignInWidget({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SignInWidgetState();
  }
}

class _SignInWidgetState extends ConsumerState<SignInWidget> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = "";
  var _enteredPassword = "";
  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      await _firebase.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );


    } on FirebaseAuthException catch (error) {
      print(error.message);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("The entered email or password is incorrect.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
            keyboardType: TextInputType.emailAddress,
            initialValue: "1@1.com",
            decoration: const InputDecoration(labelText: "E-mail Address"),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: Validator.emailValidator,
            onSaved: (newValue) {
              _enteredEmail = newValue!;
            }),
        TextFormField(
          initialValue: "123456",
          decoration: const InputDecoration(labelText: "Password"),
          obscureText: true,
          validator: Validator.passwordValidator,
          onSaved: (newValue) {
            _enteredPassword = newValue!;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer),
              child: const Text("Login"),
            ),
            const SizedBox(
              width: 40,
            ),
            TextButton(
                onPressed: () {
                  ref.read(loginFormProvider.notifier).state =
                      AuthFormState.register;
                },
                child: const Text("Create account")),
          ],
        ),
      ]),
    );
  }
}
