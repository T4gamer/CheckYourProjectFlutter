/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

import 'package:project_manager/models/suggestion_list.dart';
import 'package:project_manager/models/teacher_details_list.dart';

ProjectDetailsList projectDetailsListFromJson(String str) =>
    ProjectDetailsList.fromJson(json.decode(str));

String projectDetailsListToJson(ProjectDetailsList data) =>
    json.encode(data.toJson());

class ProjectDetailsList {
  ProjectDetailsList({
    required this.datum,
  });

  List<ProjectDetail> datum;

  factory ProjectDetailsList.fromJson(Map<dynamic, dynamic> json) =>
      ProjectDetailsList(
        datum: List<ProjectDetail>.from(
            json["datum"].map((x) => ProjectDetail.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "datum": List<dynamic>.from(datum.map((x) => x.toJson())),
      };
}

class ProjectDetail {
  ProjectDetail({
    this.mainSuggestion,
    required this.image,
    this.deliveryDate,
    required this.teacher,
    required this.progression,
    required this.id,
    required this.title,
  });

  Suggestion? mainSuggestion;
  String image;
  DateTime? deliveryDate;
  TeacherDetail? teacher;
  double progression;
  int id;
  String title;

  factory ProjectDetail.fromJson(Map<dynamic, dynamic> json) => ProjectDetail(
        mainSuggestion: json["main_suggestion"] == null
            ? null
            : Suggestion.fromJson(json["main_suggestion"]),
        image: json["image"],
        deliveryDate: json["delivery_date"] == null
            ? null
            : DateTime.parse(json["delivery_date"]),
        teacher: json["teacher"] == null
            ? null
            : TeacherDetail.fromJson(json["teacher"]),
        progression: json["progression"]?.toDouble(),
        id: json["id"],
        title: json["title"],
      );

  Map<dynamic, dynamic> toJson() => {
        "main_suggestion": mainSuggestion?.toJson(),
        "image": image,
        "delivery_date":
            "${deliveryDate!.year.toString().padLeft(4, '0')}-${deliveryDate!.month.toString().padLeft(2, '0')}-${deliveryDate!.day.toString().padLeft(2, '0')}",
        "teacher": teacher?.toJson(),
        "progression": progression,
        "id": id,
        "title": title,
      };
}

// class MainSuggestion {
//     MainSuggestion({
//         required this.image,
//         required this.project,
//         required this.id,
//         required this.title,
//         required this.content,
//         required this.status,
//     });
//
//     String image;
//     int project;
//     int id;
//     String title;
//     String content;
//     String status;
//
//     factory MainSuggestion.fromJson(Map<dynamic, dynamic> json) => MainSuggestion(
//         image: json["image"],
//         project: json["project"],
//         id: json["id"],
//         title: json["title"],
//         content: json["content"],
//         status: json["status"],
//     );
//
//     Map<dynamic, dynamic> toJson() => {
//         "image": image,
//         "project": project,
//         "id": id,
//         "title": title,
//         "content": content,
//         "status": status,
//     };
// }
//
// class Teacher {
//     Teacher({
//         required this.phoneNumber,
//         required this.id,
//         required this.user,
//     });
//
//     int phoneNumber;
//     int id;
//     int user;
//
//     factory Teacher.fromJson(Map<dynamic, dynamic> json) => Teacher(
//         phoneNumber: json["phoneNumber"],
//         id: json["id"],
//         user: json["user"],
//     );
//
//     Map<dynamic, dynamic> toJson() => {
//         "phoneNumber": phoneNumber,
//         "id": id,
//         "user": user,
//     };
// }
