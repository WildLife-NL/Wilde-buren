import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wilde_buren/config/theme/custom_theme.dart';
import 'package:wilde_buren/views/auth/login_view.dart';
import 'package:wilde_buren/views/home/home_view.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CustomTheme(context).themeData,
      title: 'Wilde Buren',
      debugShowCheckedModeBanner: false,
      home: const Initializer(),
    );
  }
}

class Initializer extends StatefulWidget {
  const Initializer({super.key});

  @override
  State<Initializer> createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  Future<bool>? _isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    _isUserLoggedIn = _checkUserLoginStatus();
  }

  Future<bool> _checkUserLoginStatus() async {
    String? token = await _getBearerToken();
    return token != null && token != "";
  }

  Future<String?> _getBearerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('bearer_token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isUserLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong"),
            ),
          );
        } else if (snapshot.data != null && snapshot.data == true) {
          return const HomeView();
        } else {
          return const LoginView();
        }
      },
    );
  }
}
