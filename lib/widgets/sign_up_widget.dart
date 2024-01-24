import "package:capsule_app/utils/validators.dart";
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:capsule_app/providers/sign_state_provider.dart";

final _firebase = FirebaseAuth.instance;

class SignUpWidget extends ConsumerStatefulWidget {
  const SignUpWidget({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SignUpWidgetState();
  }
}

class _SignUpWidgetState extends ConsumerState<SignUpWidget> {
  FirebaseFirestore fStore = FirebaseFirestore.instance;
  final _form = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  var _enteredEmail = "";
  var _enteredPassword = "";
  var _enteredName = "";
  var _enteredLastName = "";

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      await fStore.collection("users").doc(userCredentials.user!.uid).set({
        'id': userCredentials.user!.uid,
        'firstName': _enteredName,
        'lastName': _enteredLastName,
      });
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$error:Auth failed.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(labelText: "Name"),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: Validator.credentialValidator,
            onSaved: (newValue) {
              _enteredName = newValue!;
            }),
        TextFormField(
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(labelText: "Surname"),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: Validator.credentialValidator,
            onSaved: (newValue) {
              _enteredLastName = newValue!;
            }),
        TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "E-mail Address"),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            validator: Validator.emailValidator,
            onSaved: (newValue) {
              _enteredEmail = newValue!;
            }),
        TextFormField(
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
              child: const Text("Sign up"),
            ),
            const SizedBox(
              width: 40,
            ),
            TextButton(
                onPressed: () {
                  ref.read(loginFormProvider.notifier).state =
                      AuthFormState.login;
                },
                child: const Text("Already have an account")),
          ],
        ),
      ]),
    );
  }
}
