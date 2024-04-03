import 'package:flutter/cupertino.dart';
import '../models/student_details_list.dart';
import '../services/models_services.dart';

class AdminEditStudentProvider extends ChangeNotifier {
  StudentDetail? _student;

  StudentDetail? get student => _student;

  List<StudentDetail> _studentList = [];
  List<StudentDetail> _filteredStudentList = [];

  TextEditingController searchbarController = TextEditingController();

  List<StudentDetail> get filterList => _filteredStudentList;

  List<StudentDetail> get studentList => _studentList;

  String _error = "";

  final _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController serialNumber = TextEditingController();

  bool _canEdit = false;
  bool _isLoading = false;

  bool get canEdit => _canEdit;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<void> updateStudent() async {
    _isLoading = true;
    if (_student != null) {
      final user = _student!.user;
      try {
        await patchStudent(
            _student!.id, null, null, int.parse(serialNumber.text.trim()));
        await patchUser(
            user.id, firstName.text, lastName.text, userName.text, email.text);
        email.text = '';
        password.text = "";
        confirmPassword.text = "";
        userName.text = "";
        lastName.text = "";
        firstName.text = "";
        serialNumber.text = "";
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
        notifyListeners();
      }
    }
    notifyListeners();
  }

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

  // Future<void> deleteStudent(int id, int index, bool isList) async {
  //   await delStudent(id);
  //   if (isList) {
  //     _studentList.removeAt(index);
  //   } else {
  //     _filteredStudentList.removeAt(index);
  //   }
  //   notifyListeners();
  // }

  void setStudent(item) {
    _student = item;
    if (_student != null) {
      userName.text = _student!.user.username;
      firstName.text = _student!.user.firstName;
      lastName.text = _student!.user.lastName;
    }
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

  String? validateSerial(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "رقم القيد يتكون من ارقام فقط";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 8) {
      return 'كلمة المرور قصيرة يجب ان تكون 8 احرف علي الاقل';
    }
    if (password.value.text != value) {
      return 'يرجي التاكيد من كلمة المرور غير مشابهه';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return null;
  }
}
