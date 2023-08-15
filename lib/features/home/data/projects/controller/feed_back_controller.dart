import 'dart:convert';
import 'dart:developer';
import 'package:batnf/dio/dio_core/dio_client.dart';
import 'package:batnf/features/home/data/projects/model/response/response_data_model.dart';
import 'package:batnf/features/home/presentation/widgets/flush_bar.dart';
import 'package:batnf/features/home/presentation/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class FeedBackController extends GetxController{

  Future<void> giveFeedBack({required int rating, required String comment, required String improvement, required BuildContext context})async{
    progressIndicator(context);
    try {
      final postBody = jsonEncode({
        "rating": rating,
        "wellness": comment,
        "improvement": improvement
      });
      var response = await NetworkProvider().call(path: "/api/feedback/", method: RequestMethod.post, body: postBody);
      final code = SuccessResponseModel.fromJson(jsonDecode(response?.data));
      if(code.status.toString() == "200"){
        Navigator.pop(Get.context!);
        Navigator.pop(Get.context!);
        FlushBar(Get.context!, code.message ?? "", "Success").showSuccessBar;

      }else{
          Navigator.pop(Get.context!);
          Navigator.of(Get.context!).pop();
          FlushBar(Get.context!,code.message ?? "", "Error").showErrorBar;

      }
    } on DioException catch (e) {
      Navigator.of(Get.context!).pop();
      FlushBar(Get.context!, e.response?.data["message"], "Error").showErrorBar;
      throw e.response?.data["message"];
    } catch (err){
      Navigator.of(Get.context!).pop();
      FlushBar(Get.context!, err.toString(), "Error").showErrorBar;
      throw err.toString();
    }
  }


}