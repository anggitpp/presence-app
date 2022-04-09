import 'package:flutter/material.dart';
import 'package:presence_app/blocs/login/login_bloc.dart';
import 'package:presence_app/config/routes.dart';
import 'package:presence_app/screens/login/widgets/verification_dialog.dart';
import 'package:presence_app/utils/error_dialog.dart';
import 'package:validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    context
        .read<LoginBloc>()
        .add(SubmitLoginEvent(email: _email!, password: _password!));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.loginStatus == LoginStatus.error) {
            errorDialog(context, state.error);
          }
          if (state.loginStatus == LoginStatus.success) {
            Navigator.pushReplacementNamed(context, Routes.home);
          }
          if (state.loginStatus == LoginStatus.unverified) {
            verificationDialog(context, state.userCredential!);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('LOGIN')),
            body: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email required';
                      }
                      if (!isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _email = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password required';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  state.loginStatus == LoginStatus.submitting
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () => _submit(),
                          child: const Text('Login')),
                  TextButton(
                      onPressed: () {}, child: const Text('Lupa password?'))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
