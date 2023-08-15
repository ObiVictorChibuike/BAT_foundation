import 'package:batnf/features/authentication/bloc/auth_bloc.dart';
import 'package:batnf/features/authentication/presentation/controller/auth_controller.dart';
import 'package:batnf/features/authentication/presentation/widgets/dob_input.dart';
import 'package:batnf/features/authentication/presentation/widgets/drop_down_text_field.dart';
import 'package:batnf/features/authentication/presentation/widgets/text_field_widget.dart';
import 'package:batnf/router/routes.dart';
import 'package:batnf/universal.dart/main_btn.dart';
import 'package:batnf/universal.dart/text_widget.dart';
import 'package:batnf/utilities/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key, required this.data});
  final Map<String, String> data;
  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _textEditingController_1 = TextEditingController();
  final _textEditingController_2 = TextEditingController();
  final _textEditingController_3 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController_1.dispose();
    _textEditingController_2.dispose();
    _textEditingController_3.dispose();
    super.dispose();
  }

  String? formattedDate;
  DateTime _selectedDate = DateTime.now();
  bool obscureText = false;
  String date = "Select";
  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = ThemeData(
      buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
          .copyWith(secondary: Colors.blue),
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(3030),
      builder: (context, child) {
        return Theme(
          data: theme,
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        date = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  final formfieldkey_1 = GlobalKey<FormFieldState>();
  final formfieldkey_2 = GlobalKey<FormFieldState>();
  bool? isValid = false;
  String? location;
  final _controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    final authBloc = context.watch<AuthBloc>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
            child: Stack(
              children: [
                Center(child: Image.asset("assets/images/transparent_logo.png")),
                ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_rounded)),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: "Create profile",
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                          TextWidget(
                            text: "Step 2 of 2",
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
                      label: "First name",
                      validator: (value) {
                        final error =
                            Validator.validateText(value, "First name");
                        return error;
                      },
                      onChanged: (value) {
                        isValid = formfieldkey_1.currentState?.validate();
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFieldWidget(
                      fieldKey: formfieldkey_2,
                      onChanged: (value) {
                        isValid = formfieldkey_1.currentState?.validate();
                      },
                      toggleVisibility: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      controller: _textEditingController_2,
                      label: "Last name",
                      validator: (value) {
                        final error =
                            Validator.validateText(value, "Last name");
                        return error;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DropDownInput(
                      onChanged: (val) {
                        location = val.value;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DateOfBirthInput(
                      date: date,
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MainButton(
                      onTap: () {
                        if (isValid == true) {
                          _controller.registration(
                              firstname: _textEditingController_1.text,
                              lastname: _textEditingController_2.text,
                              email: widget.data["email"]!,
                              password: widget.data["password"]!,
                              passwordconfirm: widget.data["confirmPassword"]!,
                              location: location!,
                              date: date);
                        }
                      },
                      label: "Register",
                    ),
                    // BlocConsumer<AuthBloc, AuthState>(
                    //   listener: (context, state) {
                    //     if (state is AuthStateError) {
                    //       FlushBar(context, state.errorMessage ?? "", "Error")
                    //           .showErrorBar;
                    //     } else if (state is AuthStateRegistrationSuccess) {
                    //       Navigator.pushNamed(context, Routes.emailSent,
                    //           arguments: state.message);
                    //     }
                    //   },
                    //   builder: (context, state) {
                    //     return state is AuthStateIsLoading
                    //         ? const LoaderWidget()
                    //         : MainButton(
                    //             onTap: () {
                    //               if (isValid == true) {
                    //                 authBloc.add(AuthEventRegister(
                    //                     email: widget.data["email"]!,
                    //                     password: widget.data["password"]!,
                    //                     confirmPassword:
                    //                         widget.data["confirmPassword"]!,
                    //                     firstName:
                    //                         _textEditingController_1.text,
                    //                     lastName: _textEditingController_2.text,
                    //                     location: location!,
                    //                     birthDate: date));
                    //               }
                    //             },
                    //             label: "Register",
                    //           );
                    //   },
                    // ),
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
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
