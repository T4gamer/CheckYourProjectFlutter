import 'package:flutter/cupertino.dart';
import 'package:gradefy/services/models_services.dart';

import '../models/student_details_list.dart';

class AdminStudentProvider extends ChangeNotifier {
  List<StudentDetail> _studentList = [];
  List<StudentDetail> _filteredStudentList = [];

  TextEditingController searchbarController = TextEditingController();

  List<StudentDetail> get filterList => _filteredStudentList;

  List<StudentDetail> get studentList => _studentList;

  Future<List<StudentDetail>> loadStudents() async {
    final data = await getStudentDetailsList();
    _studentList = data.studentDetails;
    notifyListeners();
    return _studentList;
  }

  void filterStudentList() {
    if (searchbarController.text.isEmpty) {
      _filteredStudentList = [];
      notifyListeners();
    } else {
      final String text = searchbarController.text;
      _filteredStudentList = _studentList
          .where((e) =>
              e.user.firstName == text ||
              e.user.lastName == text ||
              e.user.username == text)
          .toList();
    }
  }

  Future<void> deleteStudent(int id,int index,bool isList) async {
    await delStudent(id);
    if(isList){
      _studentList.removeAt(index);
    }else{
      _filteredStudentList.removeAt(index);
    }
    notifyListeners();
  }
}
