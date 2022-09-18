import 'package:flutter/material.dart';
import 'package:grocery/constants/routes.dart';
import 'package:grocery/services/auth/auth_service.dart';
import 'package:grocery/views/grocery/grocery_view.dart';
import 'package:grocery/views/login_view.dart';
import 'package:grocery/views/register_view.dart';
import 'package:grocery/views/verify_email.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      groceryRoute: ((context) => const GroceryView()),
      verifyEmailRoute: ((context) => const VerifyEmailView()),
    },
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              // if (user.isEmailVerified) {
              //   return const GroceryView();
              // } else {
              //   return const VerifyEmailView();
              // }
              return const GroceryView();
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
