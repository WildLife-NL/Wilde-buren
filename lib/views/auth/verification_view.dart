import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wilde_buren/app.dart';
import 'package:wilde_buren/config/app_config.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/widgets/custom_scaffold.dart';
import 'package:wildlife_api_connection/auth_api.dart';
import 'package:wildlife_api_connection/models/user.dart';

class VerificationView extends StatefulWidget {
  final String email;

  const VerificationView({
    super.key,
    required this.email,
  });

  @override
  VerificationViewState createState() => VerificationViewState();
}

class VerificationViewState extends State<VerificationView> {
  final FocusNode pincodeFocusNode = FocusNode();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    pincodeFocusNode.requestFocus();
  }

  void checkVerificationCode() async {
    try {
      User user = await AuthApi(AppConfig.shared.apiClient)
          .authorize(widget.email, _verificationCodeController.text);
      debugPrint(user.name);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Initializer(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Email verificatie',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CustomColors.primary,
            ),
          ),
          const SizedBox(height: 30),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text:
                      'We hebben u een mail gestuurd met een 6 cijferige code erin om te verifiëren dat dit email van u is: ',
                ),
                TextSpan(
                  text: widget.email,
                  style: const TextStyle(
                    color: CustomColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PinCodeTextField(
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: CustomColors.light200,
              inactiveFillColor: CustomColors.light200,
              selectedFillColor: CustomColors.light250,
            ),
            appContext: context,
            length: 6,
            focusNode: pincodeFocusNode,
            controller: _verificationCodeController,
            onCompleted: (p0) {
              checkVerificationCode();
            },
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              children: [
                const TextSpan(
                  text: 'Heeft u geen mail ontvangen? klik dan ',
                ),
                TextSpan(
                  text: "hier",
                  style: const TextStyle(
                    color: CustomColors.primary,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await AuthApi(AppConfig.shared.apiClient)
                          .authenticate('Wilde buren', widget.email);
                    },
                ),
                const TextSpan(
                  text: ' om een nieuwe mail te ontvangen.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
