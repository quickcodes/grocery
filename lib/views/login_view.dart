import 'package:flutter/material.dart';
import 'package:grocery/constants/routes.dart';
import 'package:grocery/services/auth/auth_exceptioins.dart';
import 'package:grocery/services/auth/auth_service.dart';
import 'dart:developer' as dev show log;

import 'package:grocery/utilities/dialogs/show_popup_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text("Login View"),
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
                await AuthService.firebase()
                    .logIn(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // email is verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    groceryRoute,
                    (route) => false,
                  );
                } else {
                  // not verified
                  showPopupDialog(context, "Email not verified",
                      "Please verify your email first");
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException catch (e) {
                await showPopupDialog(
                  context,
                  "An Error occured",
                  "User Not Found",
                );
              } on WrongPasswordAuthException catch (e) {
                await showPopupDialog(
                  context,
                  "An Error occured",
                  "Wrong password",
                );
              } on GenericAuthException catch (e) {
                await showPopupDialog(
                  context,
                  "An Error occured",
                  "SOMETHING WENT WRONG",
                );
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Not login yet? Register Here!"),
          ),
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
