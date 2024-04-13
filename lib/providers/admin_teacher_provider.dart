import 'package:flutter/cupertino.dart';
import 'package:gradefy/services/models_services.dart';

import '../models/teacher_details_list.dart';

class AdminTeacherProvider extends ChangeNotifier {
  List<TeacherDetail> _teacherList = [];
  List<TeacherDetail> _filteredTeacherList = [];

  TextEditingController searchbarController = TextEditingController();

  List<TeacherDetail> get filterList => _filteredTeacherList;

  List<TeacherDetail> get teacherList => _teacherList;

  List<TeacherDetail> get examinerList =>
      _teacherList.where((element) => element.isExaminer == true).toList();
  List<TeacherDetail> get filterExaminerList =>
      _filteredTeacherList.where((element) => element.isExaminer == true).toList();

  Future<List<TeacherDetail>> loadTeachers() async {
    final data = await getTeacherDetailsList();
    _teacherList = data.teacher;
    notifyListeners();
    return _teacherList;
  }

  Future<List<TeacherDetail>> loadExaminer() async {
    final data = await getTeacherDetailsList();
    _teacherList = data.teacher;
    notifyListeners();
    return _teacherList.where((element) => element.isExaminer == true).toList();
  }

  void filterTeacherList() {
    if (searchbarController.text.isEmpty) {
      _filteredTeacherList = [];
      notifyListeners();
    } else {
      final String text = searchbarController.text;
      _filteredTeacherList = _teacherList
          .where((e) =>
              e.user.firstName == text ||
              e.user.lastName == text ||
              e.user.username == text)
          .toList();
    }
  }

// Future<void> deleteStudent(int id,int index,bool isList) async {
//   await delStudent(id);
//   if(isList){
//     _teacherList.removeAt(index);
//   }else{
//     _filteredTeacherList.removeAt(index);
//   }
//   notifyListeners();
// }
}
