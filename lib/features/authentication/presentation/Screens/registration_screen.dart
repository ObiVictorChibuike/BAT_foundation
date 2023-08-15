import 'package:batnf/features/authentication/presentation/widgets/text_field_widget.dart';
import 'package:batnf/router/routes.dart';
import 'package:batnf/universal.dart/main_btn.dart';
import 'package:batnf/universal.dart/text_widget.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _textEditingController_1 = TextEditingController();
  final _textEditingController_2 = TextEditingController();
  final _textEditingController_3 = TextEditingController();

  @override
  void dispose() {
    _textEditingController_1.dispose();
    _textEditingController_2.dispose();
    _textEditingController_3.dispose();
    super.dispose();
  }

  final formfieldkey_1 = GlobalKey<FormFieldState>();
  final formfieldkey_2 = GlobalKey<FormFieldState>();
  final formfieldkey_3 = GlobalKey<FormFieldState>();

  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Center(child: Image.asset("assets/images/transparent_logo.png")),
              Form(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: "Register",
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                          TextWidget(
                            text: "Step 1 of 2",
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 70,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      fieldKey: formfieldkey_1,
                      controller: _textEditingController_1,
                      label: "Email address",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFieldWidget(
                      fieldKey: formfieldkey_2,
                      obscureText: obscureText,
                      toggleVisibility: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      showVisibility: true,
                      controller: _textEditingController_2,
                      label: "Password",
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFieldWidget(
                      fieldKey: formfieldkey_3,
                      obscureText: obscureText,
                      toggleVisibility: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      showVisibility: true,
                      controller: _textEditingController_3,
                      label: "Confirm password",
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      height: 20,
                    ),
                    MainButton(
                      onTap: () {
                        final data = {
                          "email": _textEditingController_1.text,
                          "password": _textEditingController_2.text,
                          "confirmPassword": _textEditingController_3.text,
                        };
                        Navigator.pushNamed(context, Routes.profile,
                            arguments: data);
                      },
                      label: "Create account",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TextWidget(
                          text: "Already have an account? ",
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.login);
                          },
                          child: const TextWidget(
                            text: "Login",
                            color: Color.fromARGB(255, 0, 80, 146),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),
        ));
  }
}
