import 'dart:convert';

import 'package:batnf/dio/dio_core/dio_client.dart';
import 'package:batnf/features/home/data/projects/model/response/response_data_model.dart';
import 'package:batnf/features/home/presentation/widgets/flush_bar.dart';
import 'package:batnf/features/home/presentation/widgets/progress_indicator.dart';
import 'package:batnf/router/routes.dart';
import 'package:batnf/utilities/local_session_manager/local_session_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  LocalSessionManager localSessionManager = LocalSessionManager();

  Future<void> login({required String email, required String password})async{
    progressIndicator(Get.context!);
    try {
      final postBody = jsonEncode({
        "identity": email,
        "password": password,
      });
      var response = await NetworkProvider().call(path: "/api/login", method: RequestMethod.post, body: postBody);
      final data = SuccessResponseModel.fromJson(response?.data);
      if(response!.data["status"].toString() == "200"){
      WidgetsBinding.instance.addPostFrameCallback((_){
        localSessionManager.authStatusVal = true;
        localSessionManager.authUserIdVal = response.data["userId"];
        localSessionManager.authUserEmail = email;
        Navigator.pushReplacementNamed(Get.context!, Routes.home);
        // FlushBar(Get.context!, "Login was successful", "Welcome").showSuccessBar;
      });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_){
          Navigator.of(Get.context!).pop();
          FlushBar(
              Get.context!, "${response.data["message"] ?? "Please check your credentials and resend"}", "Error").showErrorBar;
        });

      }
    } on DioException catch (e) {
      Navigator.of(Get.context!).pop();
      FlushBar(Get.context!, e.response?.data["message"] ?? "", "Error").showErrorBar;
      throw e.response?.data["message"];
    } catch (err){
      Navigator.of(Get.context!).pop();
      FlushBar(Get.context!, err.toString() ?? "", "Error").showErrorBar;
      throw err.toString();
    }
  }

  Future<void> registration({required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String passwordconfirm,
    required String location,
    required String date})async{
    progressIndicator(Get.context!);
    try {
      final postBody = jsonEncode({
        "first_name": firstname,
        "last_name": lastname,
        "email": email,
        "password": password,
        "password_confirm": passwordconfirm,
        "location": location,
        "dob": date,
      },);
      var response = await NetworkProvider().call(path: "/api/create", method: RequestMethod.post, body: postBody);
      final data = SuccessResponseModel.fromJson(response?.data);
      if(response!.data["status"].toString() == "200"){
        WidgetsBinding.instance.addPostFrameCallback((_){
          Navigator.pushReplacementNamed(Get.context!, Routes.emailSent, arguments: data.message);
          FlushBar(Get.context!, data.message ?? "", "Success").showSuccessBar;
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_){
          Navigator.of(Get.context!).pop();
          FlushBar(
              Get.context!, "${response.data["message"] ?? "Please check your credentials and resend"}", "Error").showErrorBar;
        });

      }
    } on DioException catch (e) {
      Navigator.of(Get.context!).pop();
      FlushBar(Get.context!, e.response?.data["message"] ?? "", "Error").showErrorBar;
      throw e.response?.data["message"];
    } catch (err){
      Navigator.of(Get.context!).pop();
      FlushBar(Get.context!, err.toString() ?? "", "Error").showErrorBar;
      throw err.toString();
    }
  }
}