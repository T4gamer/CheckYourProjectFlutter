/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

import 'package:gradefy/models/user_list.dart';

StudentDetailsList studentDetailsListFromJson(String str) => StudentDetailsList.fromJson(json.decode(str));

String studentDetailsListToJson(StudentDetailsList data) => json.encode(data.toJson());

class StudentDetailsList {
    StudentDetailsList({
        required this.studentDetails,
    });

    List<StudentDetail> studentDetails;

    factory StudentDetailsList.fromJson(Map<dynamic, dynamic> json) => StudentDetailsList(
        studentDetails: List<StudentDetail>.from(json["datum"].map((x) => StudentDetail.fromJson(x))),
    );

    Map<dynamic, dynamic> toJson() => {
        "datum": List<dynamic>.from(studentDetails.map((x) => x.toJson())),
    };
}

class StudentDetail {
    StudentDetail({
        required this.phoneNumber,
        required this.project,
        required this.id,
        required this.user,
    });

    int phoneNumber;
    int? project;
    int id;
    User user;

    factory StudentDetail.fromJson(Map<dynamic, dynamic> json) => StudentDetail(
        phoneNumber: json["phoneNumber"],
        project: json["project"],
        id: json["id"],
        user: User.fromJson(json["user"]),
    );

    Map<dynamic, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "project": project,
        "id": id,
        "user": user.toJson(),
    };
}
//
// class User {
//     User({
//         required this.lastName,
//         required this.groups,
//         required this.id,
//         required this.firstName,
//         required this.username,
//     });
//
//     String lastName;
//     List<int> groups;
//     int id;
//     String firstName;
//     String username;
//
//     factory User.fromJson(Map<dynamic, dynamic> json) => User(
//         lastName: json["last_name"],
//         groups: List<int>.from(json["groups"].map((x) => x)),
//         id: json["id"],
//         firstName: json["first_name"],
//         username: json["username"],
//     );
//
//     Map<dynamic, dynamic> toJson() => {
//         "last_name": lastName,
//         "groups": List<dynamic>.from(groups.map((x) => x)),
//         "id": id,
//         "first_name": firstName,
//         "username": username,
//     };
// }
