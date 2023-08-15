import 'package:batnf/features/authentication/bloc/auth_bloc.dart';
import 'package:batnf/features/authentication/presentation/controller/auth_controller.dart';
import 'package:batnf/features/authentication/presentation/widgets/text_field_widget.dart';
import 'package:batnf/features/home/presentation/widgets/flush_bar.dart';
import 'package:batnf/router/routes.dart';
import 'package:batnf/universal.dart/loader.dart';
import 'package:batnf/universal.dart/main_btn.dart';
import 'package:batnf/universal.dart/text_widget.dart';
import 'package:batnf/utilities/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _textEditingController_1 = TextEditingController();
  final _textEditingController_2 = TextEditingController();
  final formfieldkey_1 = GlobalKey<FormFieldState>();
  final formfieldkey_2 = GlobalKey<FormFieldState>();

  @override
  void dispose() {
    _textEditingController_1.dispose();
    _textEditingController_2.dispose();

    super.dispose();
  }

  bool isLoading = false;
  bool? isValid = false;

  bool obscureText = true;
  final _controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();
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
                      child: TextWidget(
                        text: "Login",
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
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
                      label: "Email address:",
                      validator: (value) {
                        final error = Validator.validateEmail(value!);

                        return error;
                      },
                      onChanged: (val) {
                        isValid = formfieldkey_1.currentState?.validate();
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFieldWidget(
                      fieldKey: formfieldkey_2,
                      obscureText: obscureText,
                      validator: (val) {
                        final error = Validator.validatePassword(val);

                        return error;
                      },
                      toggleVisibility: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      onChanged: (val) {
                        // isValid = formfieldkey_2.currentState?.validate();
                      },
                      showVisibility: true,
                      controller: _textEditingController_2,
                      label: "Password",
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, Routes.resetPassword),
                            child: const TextWidget(
                              text: "Forgot password?",
                              color: Color.fromARGB(255, 0, 80, 146),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MainButton(
                      onTap: () {
                        if (isValid == true){
                          _controller.login(email: formfieldkey_1.currentState?.value, password: formfieldkey_2.currentState?.value);
                        }
                      },
                      label: "Login",
                    ),
                    // BlocConsumer<AuthBloc, AuthState>(
                    //   listener: (context, state) {
                    //     if (state is AuthStateError) {
                    //       FlushBar(
                    //               context,
                    //               state.errorMessage == "Login Failed"
                    //                   ? "Login Failed. Please check your username or password"
                    //                   : state.errorMessage,
                    //               "Error")
                    //           .showErrorBar;
                    //     } else if (state is AuthStateLoginSuccess) {
                    //       Navigator.pushNamed(context, Routes.home);
                    //     }
                    //   },
                    //   builder: (context, state) {
                    //     return state is AuthStateIsLoading
                    //         ? const LoaderWidget()
                    //         : MainButton(
                    //             onTap: () {
                    //               if (isValid == true) {
                    //                 authBloc.add(AuthEventLogin(
                    //                     email:
                    //                         formfieldkey_1.currentState?.value,
                    //                     password: formfieldkey_2
                    //                         .currentState?.value));
                    //               }
                    //             },
                    //             label: "Login",
                    //           );
                    //   },
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TextWidget(
                          text: "Don't have an account? ",
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.register);
                          },
                          child: const TextWidget(
                            text: "Register",
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
