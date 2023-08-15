import 'dart:developer';

import 'package:batnf/dio/api_endpoint.dart';
import 'package:batnf/dio/dio_client.dart';
import 'package:batnf/dio/dio_exception.dart';
import 'package:batnf/features/authentication/data/interfaces/auth_interface.dart';
import 'package:batnf/features/authentication/data/models/response.dart';
import 'package:batnf/utilities/typedefs.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthProvider extends AuthInterface {
  @override
  EitherMap register(
      {required String firstname,
      required String lastname,
      required String email,
      required String password,
      required String passwordconfirm,
      required String location,
      required String date}) async {
    try {
      var res = await DioClient.instance.post(
        RoutesAndPaths.authSignUp,
        data: {
          "first_name": firstname,
          "last_name": lastname,
          "email": email,
          "password": password,
          "password_confirm": passwordconfirm,
          "location": location,
          "dob": date,
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      final result = ResponseClass.fromMap(res);

      if (result.status != 200) {
        return left(result.message);
      }

      return right(res);
    } on DioException catch (e) {
      final errorMessage = DioExceptionClass.fromDioError(e).toString();
      return left(errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  EitherMap login({
    required String email,
    required String password,
  }) async {
    try {
      var res = await DioClient.instance.post(
        RoutesAndPaths.authLogin,
        data: {
          "identity": email,
          "password": password,
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );
      final result = ResponseClass.fromMap(res);
      if (result.status != 200) {
        return left(result.message);
      }
      return right(res);
    } on DioException catch (e) {
      final errorMessage = DioExceptionClass.fromDioError(e).toString();
      return left(errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  EitherMap resetPassword({required String email}) async {
    try {
      var res = await DioClient.instance.post(
        RoutesAndPaths.resetPassword,
        data: {
          "identity": email
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      final result = ResponseClass.fromMap(res);

      if (result.status != 200) {
        log("This is the error message ${result.message}");
        return left(result.message);
      }
      return right(res);
    } on DioException catch (e) {
      final errorMessage = DioExceptionClass.fromDioError(e).toString();
      return left(errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }
}
