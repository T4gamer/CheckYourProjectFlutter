import 'package:flutter/cupertino.dart';
import 'package:gradefy/models/file_direct_link.dart';
import 'package:gradefy/models/project_details_list.dart';
import '../models/suggestion_list.dart';
import '../models/teacher_details_list.dart';
import '../services/file_services.dart';
import '../services/models_services.dart';

class AdminEditProjectProvider extends ChangeNotifier {
  ProjectDetail? _project;
  Suggestion? _suggestion;
  final PdfStorageService _fileService = PdfStorageService();

  ProjectDetail? get project => _project;

  List<ProjectDetail> _projectList = [];
  List<ProjectDetail> _filteredProjectList = [];

  TextEditingController searchbarController = TextEditingController();

  List<ProjectDetail> get filterList => _filteredProjectList;

  List<ProjectDetail> get projectList => _projectList;

  String _error = "";

  final _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController title = TextEditingController();
  TextEditingController mainSuggestion = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController deliveryDate = TextEditingController();
  TextEditingController progression = TextEditingController();

  bool _canEdit = true;
  bool _isLoading = false;

  bool get canEdit => _canEdit;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<void> updateProject() async {
    _isLoading = true;
    if (_project != null) {
      try {
        await patchProject(
            id: _project!.id,
            teacher: 0,
            title: title.text,
            image: image.text,
            progression: double.tryParse(progression.text),
            deliveryDate: deliveryDate.text,
            mainSuggestion: int.tryParse(mainSuggestion.text));
        title.text = '';
        mainSuggestion.text = "";
        image.text = "";
        deliveryDate.text = "";
        progression.text = "";
        _isLoading = false;
        _canEdit = false;
        _error = "";
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        if (_error.length > 150) {
          _error = _error.substring(0, 150);
        }
        _isLoading = false;
        _canEdit = false;
        notifyListeners();
      }
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

  void filterProjectList() {
    if (searchbarController.text.isEmpty) {
      _filteredProjectList = [];
      notifyListeners();
    } else {
      final String text = searchbarController.text;
      _filteredProjectList = _projectList
          .where((e) =>
              e.title == text ||
              e.teacher?.user.username == text ||
              e.teacher?.user.firstName == text ||
              e.teacher?.user.lastName == text)
          .toList();
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

  Future<String?> getPdfLink() async {
    if (_project != null) {
      await loadProjects();
      return "ok";
    }
    return null;
  }

  void setProject(item) {
    _project = item;
    if (_project != null) {
      _error = "";
      title.text = _project!.title;
      progression.text = _project!.progression.toString();
      image.text = _project!.image;
      deliveryDate.text = _project!.deliveryDate?.year != null
          ? "${_project!.deliveryDate?.year}-${_project!.deliveryDate?.month}-${_project!.deliveryDate?.day}"
          : "";
      mainSuggestion.text = _project!.mainSuggestion?.id.toString() ?? "";
    } else {
      _isLoading = false;
    }
    notifyListeners();
  }

  void setDeliveryDate(DateTime date) {
    deliveryDate.text = "${date.year}-${date.month}-${date.day}";
    notifyListeners();
  }

  void onFromStateChanged() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _canEdit = true;
      } else {
        _canEdit = false;
      }
    } else {
      _canEdit = false;
    }
    notifyListeners();
  }

  String? validateUserName(String? value) {
    if (value!.isEmpty) {
      return null;
    }
    if (!RegExp(r'^[\w.@+-]+$').hasMatch(value)) {
      return 'اسم المستخدم غير صالح';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'^[\w.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'هذا البريد غير صالح';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 8) {
      return 'كلمة المرور قصيرة يجب ان تكون 8 احرف علي الاقل';
    }
    return null;
  }

  // String? validateConfirmPassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return null;
  //   }
  //   if (value.length < 8) {
  //     return 'كلمة المرور قصيرة يجب ان تكون 8 احرف علي الاقل';
  //   }
  //   if (password.value.text != value) {
  //     return 'يرجي التاكيد من كلمة المرور غير مشابهه';
  //   }
  //   return null;
  // }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return null;
  }
}
