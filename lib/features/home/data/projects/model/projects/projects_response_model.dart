

import 'dart:convert';

List<ProjectsResponseModel> projectsResponseModelFromJson(String str) => List<ProjectsResponseModel>.from(json.decode(str).map((x) => ProjectsResponseModel.fromJson(x)));

String projectsResponseModelToJson(List<ProjectsResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectsResponseModel {
  String? projectId;
  String? projectTitle;
  String? projectDescription;
  String? projectVenue;
  String? projectLocation;
  String? projectImage;
  String? projectStartDate;
  String? projectEndDate;
  String? projectStatus;
  List<FileElement>? files;

  ProjectsResponseModel({
    this.projectId,
    this.projectTitle,
    this.projectDescription,
    this.projectVenue,
    this.projectLocation,
    this.projectImage,
    this.projectStartDate,
    this.projectEndDate,
    this.projectStatus,
    this.files,
  });

  factory ProjectsResponseModel.fromJson(Map<String, dynamic> json) => ProjectsResponseModel(
    projectId: json["projectId"],
    projectTitle: json["projectTitle"],
    projectDescription: json["projectDescription"],
    projectVenue: json["projectVenue"],
    projectLocation: json["projectLocation"],
    projectImage: json["projectImage"],
    projectStartDate: json["projectStartDate"],
    projectEndDate: json["projectEndDate"],
    projectStatus: json["projectStatus"],
    files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "projectId": projectId,
    "projectTitle": projectTitle,
    "projectDescription": projectDescription,
    "projectVenue": projectVenue,
    "projectLocation": projectLocation,
    "projectImage": projectImage,
    "projectStartDate": projectStartDate,
    "projectEndDate": projectEndDate,
    "projectStatus": projectStatus,
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
  };
}

class FileElement {
  String? thumbnail;
  String? fileUrl;
  String? fileExt;

  FileElement({
    this.thumbnail,
    this.fileUrl,
    this.fileExt,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    thumbnail: json["thumbnail"],
    fileUrl: json["fileUrl"],
    fileExt: json["fileExt"],
  );

  Map<String, dynamic> toJson() => {
    "thumbnail": thumbnail,
    "fileUrl": fileUrl,
    "fileExt": fileExt,
  };
}
