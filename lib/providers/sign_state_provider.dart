import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthFormState { login, register }

final loginFormProvider = StateProvider((ref) => AuthFormState.login);
