

import 'dart:convert';

List<GetAllHomeFileResponseModel> getAllHomeFileResponseModelFromJson(String str) => List<GetAllHomeFileResponseModel>.from(json.decode(str).map((x) => GetAllHomeFileResponseModel.fromJson(x)));

String getAllHomeFileResponseModelToJson(List<GetAllHomeFileResponseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllHomeFileResponseModel {
  String? id;
  List<FileElement>? files;

  GetAllHomeFileResponseModel({
    this.id,
    this.files,
  });

  factory GetAllHomeFileResponseModel.fromJson(Map<String, dynamic> json) => GetAllHomeFileResponseModel(
    id: json["id"],
    files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
