import 'package:flutter/material.dart';
import 'package:wilde_buren/config/app_config.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/views/auth/verification_view.dart';
import 'package:wilde_buren/widgets/custom_scaffold.dart';
import 'package:wildlife_api_connection/auth_api.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 100),
          Image.asset(
            'assets/images/wildlife-logo.png',
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 30),
          const Text(
            "Welkom bij Wilde Buren!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CustomColors.primary,
            ),
          ),
          const Text(
            "Login in met je email.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20.0),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email*',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field cannot be empty.';
                    }

                    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$';
                    RegExp regex = RegExp(pattern);

                    if (!regex.hasMatch(value)) {
                      return 'Give a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  minWidth: double.maxFinite,
                  color: CustomColors.primary,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final email = _emailController.text;
                      await AuthApi(AppConfig.shared.apiClient)
                          .authenticate('Wilde buren', email);

                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerificationView(
                            email: email,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Inloggen',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
