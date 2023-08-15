import 'dart:convert';
import 'dart:developer';
import 'package:batnf/dio/api_endpoint.dart';
import 'package:batnf/dio/dio_core/dio_client.dart';
import 'package:batnf/features/home/data/projects/model/home/home_file_model_response.dart';
import 'package:batnf/features/home/data/projects/model/projects/project_details_model.dart';
import 'package:batnf/features/home/data/projects/model/projects/projects_response_model.dart';
import 'package:batnf/features/home/data/projects/respository/projects/projects.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class GetProjectImpl extends ProjectRepository{
  final NetworkProvider _networkProvider = NetworkProvider();
  @override
  Future<Either<String, List<ProjectsResponseModel>>> getProjects() async{
    try {
      var response = await _networkProvider.call(path: RoutesAndPaths.allProjects, method: RequestMethod.get);
      if (response!.statusCode == 200){
        log(response.data);
        List<ProjectsResponseModel> projectList =
        List<ProjectsResponseModel>.from(json.decode(response.data).map((x) => ProjectsResponseModel.fromJson(x)));
        return Right(projectList);
      } else {
        return Left(response.data['message']);
      }
    } on DioException catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, GetProjectByIdResponseModel>> getProjectById({required String id}) async {
    try {
      var response = await _networkProvider.call(path: "/api/getSingleProject/$id", method: RequestMethod.get);
      final data = GetProjectByIdResponseModel.fromJson(json.decode(response?.data));
      return Right(data);
    } on DioException catch (e) {
      return Left(e.response?.data["message"]);
    } catch (err){
      return Left(err.toString());
    }
  }

}