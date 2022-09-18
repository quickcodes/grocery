import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

import 'package:grocery/constants/routes.dart';
import 'package:grocery/services/auth/auth_service.dart';
import 'package:grocery/utilities/dialogs/show_popup_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify your email"),
      ),
      body: Column(
        children: [
          const Text("Please verify your email address"),
          TextButton(
            onPressed: () async {
              final user = AuthService.firebase().sendEmailVerification();
              // await user?.sendEmailVerification();
              dev.log("Email send");
              // dev.log((user?.email).toString());
              await showPopupDialog(
                context,
                "Email Sent",
                "We have sent a verification email, Please Verify Yourself",
              );
            },
            child: const Text("Send Email Verification"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
