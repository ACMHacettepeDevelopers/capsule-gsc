import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:capsule_app/providers/sign_state_provider.dart";
import "package:capsule_app/utils/validators.dart";
import "package:sign_in_button/sign_in_button.dart";

final _firebase = FirebaseAuth.instance;

class SignInWidget extends ConsumerStatefulWidget {
  const SignInWidget({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SignInWidgetState();
  }
}

class _SignInWidgetState extends ConsumerState<SignInWidget> {
    final FirebaseAuth _auth = FirebaseAuth.instance;
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("The entered email or password is incorrect.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "E-mail"),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  validator: Validator.emailValidator,
                  onSaved: (newValue) {
                    _enteredEmail = newValue!;
                  }),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: Validator.passwordValidator,
                onSaved: (newValue) {
                  _enteredPassword = newValue!;
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 77, 144, 200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: TextButton(
                  onPressed: () => _submit(),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?",style: TextStyle(fontWeight: FontWeight.bold),),
            TextButton(
                onPressed: () => ref.read(loginFormProvider.notifier).state =
                    AuthFormState.register,
                child: const Text("Register Now!",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))
          ],
        ),
        SizedBox(
                height: 30,
                child: SignInButton(Buttons.google,
                    text: "Continue with Google",
                    onPressed: () async => _handleGoogleSignIn()),
              ),
      ]),
    );
  }
  Future<void> _handleGoogleSignIn() async {
    final googleProvider = GoogleAuthProvider();
    try {
      await _auth.signInWithProvider(googleProvider);
    } catch (e) {
      print(e);
    }
  }
}
