import 'package:batnf/dio/api_endpoint.dart';
import 'package:batnf/utilities/local_session_manager/local_session_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dio_error.dart';
import 'dio_intercepter.dart';

class NetworkProvider{
  Dio _getDioInstance(){
    var dio = Dio(BaseOptions(
      baseUrl: RoutesAndPaths.baseUrl,
      connectTimeout:const Duration(milliseconds: 60000),
      receiveTimeout:const Duration(milliseconds: 60000),
    ));
    dio.interceptors.add(LoggerInterceptor());
    dio.interceptors.add(AuthorizationInterceptor());
    dio.interceptors.add(LogInterceptor(responseBody: true,error: true,request: true,requestBody: true));
    return dio;
  }

  Future<Response?> call(
        {required String path,
        BuildContext? context,
        required  RequestMethod method,
        dynamic body=const {},
        Map<String,dynamic> queryParams=const {}
      })async{
    Response? response;
    try{
      switch(method){
        case RequestMethod.get:
          response = await _getDioInstance().get(path, queryParameters: queryParams);
          break;
        case RequestMethod.post:
          if (context != null) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          response = await _getDioInstance()
              .post(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.patch:
          if (context != null) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          response = await _getDioInstance()
              .patch(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.put:
          if (context != null) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          response = await _getDioInstance()
              .put(path, data: body, queryParameters: queryParams);
          break;
        case RequestMethod.delete:
          if (context != null) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
          response = await _getDioInstance()
              .delete(path, data: body, queryParameters: queryParams);
          break;
      }
      return response;
    }on DioError catch (error) {
      return Future.error(ApiError.fromDio(error));
    }
  }
}


class AuthorizationInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    final token = LocalSessionManager().token;
    if (token != "" && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }
    options.headers['Content-Type'] = 'multipart/form-data';
    options.headers["Accept"] = "application/json";
    options.headers["Content-Type"] = "application/json";
    options.headers["Cookie"] =  "ci_session=3nii9fgc8mr07noklstgcm00il8asgv5; remember_code=3e6917aba9e75aa6ebb390626a005d0757fab1ac.5027ffb6d85d7e85977fe3ed709ea8e433d0b1c4b7577343133706ae760d7303e1a7346cc891ceb4e9b9e8e944f458e59a48238d10a6ec36746647c04906f144";
    super.onRequest(options, handler);
  }
}

enum RequestMethod { get, post, put, patch, delete }