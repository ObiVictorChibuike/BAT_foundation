import 'dart:convert';
import 'dart:developer';
import 'package:batnf/dio/api_endpoint.dart';
import 'package:batnf/dio/dio_core/dio_client.dart';
import 'package:batnf/features/home/data/projects/model/home/home_file_model_response.dart';
import 'package:batnf/features/home/data/projects/model/news/news_details_model.dart';
import 'package:batnf/features/home/data/projects/model/news/news_response_model.dart';
import 'package:batnf/features/home/data/projects/respository/media_centre/news.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class GetNewsImpl extends NewsRepository{
  final NetworkProvider _networkProvider = NetworkProvider();
  @override
  Future<Either<String, List<NewsResponseModel>>> getNews() async{
    try {
      var response = await _networkProvider.call(path: RoutesAndPaths.allNews, method: RequestMethod.get);
      if (response!.statusCode == 200){
        log(response.data);
        List<NewsResponseModel> newsList =
        List<NewsResponseModel>.from(json.decode(response.data).map((x) => NewsResponseModel.fromJson(x)));
        return Right(newsList);
      } else {
        return Left(response.data['message']);
      }
    } on DioException catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, GetNewsByIdResponseModel>> getNewsById({required String id}) async {
    try {
      var response = await _networkProvider.call(path: "/api/getSingleNews/$id", method: RequestMethod.get);
      final data = GetNewsByIdResponseModel.fromJson(json.decode(response?.data));
      return Right(data);
    } on DioException catch (e) {
      return Left(e.response?.data["message"]);
    } catch (err){
      return Left(err.toString());
    }
  }

  @override
  Future<Either<String, List<GetAllHomeFileResponseModel>>> allHomeFile() async {
    try {
      var response = await _networkProvider.call(path: RoutesAndPaths.allHomeFiles, method: RequestMethod.get);
      if (response!.statusCode == 200){
        log(response.data);
        List<GetAllHomeFileResponseModel> homeFiles =
        List<GetAllHomeFileResponseModel>.from(json.decode(response.data).map((x) => GetAllHomeFileResponseModel.fromJson(x)));
        return Right(homeFiles);
      } else {
        return Left(response.data['message']);
      }
    } on DioException catch (e) {
      return Left(e.toString());
    }
  }

}