import 'package:flutter/cupertino.dart';
import 'package:project_manager/models/project_list.dart';
import 'package:project_manager/models/teacher_details_list.dart';
import 'package:project_manager/services/models_services.dart';

import '../models/project_details_list.dart';
import '../models/student_details_list.dart';

class AdminProjectProvider extends ChangeNotifier {
  bool _done = false;

  List<ProjectDetail> _filteredProjectList = [];

  StudentDetail? _studentToAdd;
  ProjectDetail? _currentProject;

  ProjectDetail? get currentProject => _currentProject;

  StudentDetail? get studentToAdd => _studentToAdd;

  TeacherDetail? _teacherDetail;

  TeacherDetail? get teacherToSet => _teacherDetail;

  bool get done => _done;
  List<ProjectDetail> _projectList = [];

  List<ProjectDetail> get projectList => _projectList;

  List<ProjectDetail> get filteredProjectList => _filteredProjectList;

  TextEditingController searchbarController = TextEditingController();
  bool _isProjectSelected = false;

  bool get isProjectSelected => _isProjectSelected;

  Future<void> createProject(String title) async {
    Project project = Project(
        image: "https://placehold.co/600x400.png",
        progression: 0.0,
        id: 0,
        title: title,
        mainSuggestion: null,
        deliveryDate: null,
        teacher: null);
    try {
      await postProject(project);
      _done = true;
      notifyListeners();
    } catch (e) {
      _done = false;
      notifyListeners();
    }
  }

  Future<bool> loadProjects() async {
    try {
      final data = await getProjectDetailsList();
      _projectList = data.datum;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void filterProjectsList() {
    if (searchbarController.text.isEmpty) {
      _filteredProjectList = [];
      notifyListeners();
    } else {
      final String text = searchbarController.text;
      _filteredProjectList =
          _projectList.where((e) => e.title.contains(text)).toList();
      notifyListeners();
    }
  }

  Future<void> deleteProject(int id, int index, bool isList) async {
    await delProject(id);
    if (isList) {
      _projectList.removeAt(index);
    } else {
      _filteredProjectList.removeAt(index);
    }
    notifyListeners();
  }

  void setIsProjectSelected(bool value) {
    _isProjectSelected = value;
    notifyListeners();
  }

  List<StudentDetail> _studentList = [];
  List<StudentDetail> _filteredStudentList = [];

  // TextEditingController studentSearchbarController = TextEditingController();

  List<StudentDetail> get filterList => _filteredStudentList;

  List<StudentDetail> get studentList => _studentList;

  Future<List<StudentDetail>> loadStudents({bool checkChanges = true}) async {
    if (checkChanges) {
      final data = await getStudentDetailsList();
      _studentList = data.studentDetails;
    } else {
      if (_studentList.isEmpty) {
        final data = await getStudentDetailsList();
        _studentList = data.studentDetails;
      }
    }
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
      notifyListeners();
    }
  }

  Future<List<StudentDetail>> loadFilteredStudentForProject(
      int projectId) async {
    if (_studentList.isEmpty) {
      final data = await getStudentDetailsList();
      _studentList = data.studentDetails;
    }
    return _studentList.where((e) => e.project == projectId).toList();
  }

  void setStudentToAdd(StudentDetail? student) {
    _studentToAdd = student;
    notifyListeners();
  }

  void setCurrentProject(ProjectDetail? item) {
    _currentProject = item;
    notifyListeners();
  }

  Future<bool> addStudentToProject() async {
    if (studentToAdd != null && currentProject != null) {
      if (studentToAdd?.project == null) {
        try {
          final data =
              await patchStudent(studentToAdd!.id, null, currentProject!.id);
          if (data.project == currentProject!.id) {
            return true;
          }
        } catch (e) {
          return false;
        }
      }
    }
    return false;
  }

  List<TeacherDetail> _teacherList = [];
  List<TeacherDetail> _filteredTeacherList = [];

  List<TeacherDetail> get filteredTeacherList => _filteredTeacherList;

  List<TeacherDetail> get teacherList => _teacherList;

  Future<List<TeacherDetail>> loadTeachers() async {
    final data = await getTeacherDetailsList();
    _teacherList = data.teacher;
    notifyListeners();
    return _teacherList;
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

  void setCurrentTeacher(TeacherDetail? item) {
    _teacherDetail = item;
    notifyListeners();
  }

  Future<bool> setTeacherToProject() async {
    if (teacherToSet != null && currentProject != null) {
      try {
        final data = await patchProject(
            id: currentProject!.id,
            teacher: teacherToSet!.id,
            mainSuggestion: 0,
            deliveryDate: "",
            title: null,
            image: null,
            progression: null);
        if (data.teacher == teacherToSet!.id) {
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
