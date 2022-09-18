import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

import 'package:grocery/constants/routes.dart';
import 'package:grocery/services/auth/auth_exceptioins.dart';
import 'package:grocery/services/auth/auth_provider.dart';
import 'package:grocery/services/auth/auth_service.dart';
import 'package:grocery/services/auth/firebase_auth_provider.dart';
import 'package:grocery/utilities/dialogs/show_popup_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Yourself here!"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: true,
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final UserCredential = await AuthService.firebase()
                    .createUser(email: email, password: password);
                // // send email verification on registration
                // final user = AuthService.firebase().currentUser;
                // AuthService.firebase().sendEmailVerification();

                Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute, (route) => false);
              } on WeakPasswordAuthException {
                await showPopupDialog(
                  context,
                  "An Error occured",
                  "Weak password",
                );
              } on EmailAlreadyInUseAuthException {
                await showPopupDialog(
                  context,
                  "An Error occured",
                  "This email is already in use",
                );
              } on InvalidEmailAuthException {
                await showPopupDialog(
                  context,
                  "An Error occured",
                  "Invalid email",
                );
              } on GenericAuthException {
                await showPopupDialog(
                  context,
                  "An error occured",
                  "SOMETHING WENT WRONG",
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Login"),
          )
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
