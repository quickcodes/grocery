import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grocery/constants/routes.dart';
import 'package:grocery/enums/menu_action.dart';
import 'package:grocery/utilities/dialogs/logout_dialog.dart';
import 'dart:developer' as dev show log;

import 'package:grocery/utilities/dialogs/show_popup_dialog.dart';

class GroceryView extends StatefulWidget {
  const GroceryView({super.key});

  @override
  State<GroceryView> createState() => _GroceryViewState();
}

class _GroceryViewState extends State<GroceryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grocerry Shop"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              dev.log(value.toString());
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDailog(context);
                  dev.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
                case MenuAction.setting:
                  showPopupDialog(
                    context,
                    "Setting",
                    "This section is under work",
                  );
                // break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log out"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.setting,
                  child: Text("Setting"),
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          const Text("THis is gRoCERy shOp"),
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
