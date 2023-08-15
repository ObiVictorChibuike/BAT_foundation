import 'dart:convert';
import 'dart:developer';
import 'package:batnf/core/state/view_state.dart';
import 'package:batnf/dio/dio_core/dio_client.dart';
import 'package:batnf/features/authentication/presentation/repository/change_password.dart';
import 'package:batnf/features/home/data/projects/model/response/response_data_model.dart';
import 'package:batnf/features/home/presentation/widgets/flush_bar.dart';
import 'package:batnf/features/home/presentation/widgets/progress_indicator.dart';
import 'package:batnf/router/routes.dart';
import 'package:batnf/utilities/injector.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController{
  final ChangePasswordRepository _changePassword = sl<ChangePasswordRepository>();
  ViewState<SuccessResponseModel> changePasswordStateView = ViewState(state: ResponseState.empty);
  void _setChangePasswordState(ViewState<SuccessResponseModel> changePasswordStateView) {
    this.changePasswordStateView = changePasswordStateView;
  }
  String? errorMessage;
  // Future<void> changePassword({required String identity, required String oldPassword, required String newPassword}) async {
  //   try{
  //     _setChangePasswordState(ViewState.loading());
  //     update();
  //     Either<String, SuccessResponseModel> either = await _changePassword.changePassword(identity: identity, oldPassword: oldPassword, newPassword: newPassword);
  //     either.fold((l){
  //       _setChangePasswordState(ViewState.error(l));
  //       update();
  //       return _setChangePasswordState(ViewState.error(l));
  //     }, (r){
  //       _setChangePasswordState(ViewState.complete(r));
  //       update();
  //       return _setChangePasswordState(ViewState.complete(r));
  //     });
  //     update();
  //   }catch(e){
  //     _setChangePasswordState(ViewState.error(e.toString()));
  //     errorMessage = e.toString();
  //     log(e.toString());
  //     update();
  //     _setChangePasswordState(ViewState.error(e.toString()));
  //   }
  // }

  Future<void> changePassword({required String identity, required String oldPassword, required String newPassword, required BuildContext context})async{
    progressIndicator(Get.context!);
    try {
      final postBody = jsonEncode({
        "identity": identity,
        "old": oldPassword,
        "new": newPassword
      });
      var response = await NetworkProvider().call(path: "/api/change_password", method: RequestMethod.post, body: postBody);
      final data = SuccessResponseModel.fromJson(json.decode(response?.data));
      if(data.status.toString() == "200"){
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.pop(Get.context!);
        FlushBar(Get.context!, data.message ?? "", "Success").showSuccessBar;
      });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_){
          Navigator.of(Get.context!).pop();
          FlushBar(Get.context!, data.message ?? "", "Error").showErrorBar;
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

  Future<void> resetPassword({required String identity, required BuildContext context})async{
    progressIndicator(Get.context!);
    try {
      final postBody = jsonEncode({
        "identity": identity,
      });
      var response = await NetworkProvider().call(path: "/api/forgot_password", method: RequestMethod.post, body: postBody);
      final data = SuccessResponseModel.fromJson(json.decode(response?.data));
      if(data.status.toString() == "200"){
      WidgetsBinding.instance.addPostFrameCallback((_){
        Navigator.pop(Get.context!);
        Navigator.pushNamed(context, Routes.emailSent, arguments: data.message);
        FlushBar(Get.context!, data.message ?? "", "Success").showSuccessBar;
      });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_){
          Navigator.of(Get.context!).pop();
          FlushBar(Get.context!, data.message ?? "", "Error").showSuccessBar;
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