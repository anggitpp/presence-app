import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presence_app/blocs/blocs.dart';

import '../../config/routes.dart';
import '../../utils/error_dialog.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({Key? key}) : super(key: key);

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _password;

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    context.read<NewPasswordCubit>().changePassword(_password);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Focus.of(context).unfocus(),
      child: BlocConsumer<NewPasswordCubit, NewPasswordState>(
        listener: (context, state) {
          if (state.newPasswordStatus == NewPasswordStatus.error) {
            errorDialog(context, state.error);
          }
          if (state.newPasswordStatus == NewPasswordStatus.success) {
            Navigator.pushReplacementNamed(context, Routes.home);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('New Password')),
            body: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password required';
                      }

                      if (value == 'password' || value == 'Password') {
                        return 'Password tidak boleh sama dengan sebelumnya!';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  state.newPasswordStatus == NewPasswordStatus.submitting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () => _submit(),
                          child: const Text('Continue')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
