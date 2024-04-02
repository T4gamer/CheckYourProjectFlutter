import 'package:flutter/cupertino.dart';
import 'package:project_manager/services/user_services.dart';

import '../models/logging_state.dart';
import '../models/project_list.dart';
import '../models/student_list.dart';
import '../models/user_list.dart';
import '../services/login_services.dart';

class UserProvider extends ChangeNotifier {
  final userServices = UserService();
  bool _loggedIn = false;
  bool invalidPassword = false;
  bool invalidEmail = false;
  bool _loginError = false;
  bool _isLoginLoading = false;
  bool isVisible = false;
  int _group = 0;
  User? _user;
  Project? _studentProject;
  Student? _studentAccount;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController changePasswordController =
      TextEditingController();
  final TextEditingController changeOldPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get loggedIn => _loggedIn;

  bool get loginError => _loginError;

  bool get isLoginLoading => _isLoginLoading;

  int get group => _group;

  User? get user => _user;

  Student? get student => _studentAccount;

  Project? get project => _studentProject;

  GlobalKey<FormState> get formKey => _formKey;

  Future<Logging> get refreshLogin => _switchLogin();

  Future<void> loginUser() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        final bool loggedIn = await login(
            emailController.value.text, passwordController.value.text);
        _loggedIn = loggedIn;
        final Logging s = await _switchLogin();
        if (s == Logging.notUser) {
          _loginError = true;
        } else if (s == Logging.student) {
          await userServices.student;
        } else {
          _loginError = false;
        }
      }
    }
    notifyListeners();
  }

  void setUser(User? value) {
    _user = value;
  }

  Future<void> changePassword() async {
    try {
      await UserService().changePassword(
          changeOldPasswordController.text, changePasswordController.text);
      changeOldPasswordController.text = "";
      changePasswordController.text = "";
    } catch (e) {
      changeOldPasswordController.text = "";
      changePasswordController.text = "";
    }
    notifyListeners();
  }

  Future<Logging> _switchLogin() async {
    if (_user == null) {
      final res = await _refreshToken();
      return Logging.notUser;
    }
    if (_user != null) {
      switch (_group) {
        case 1:
          return Logging.admin;
        case 2:
          await _loadStudent();
          await _loadProject();
          return Logging.student;
        case 3:
          return Logging.teacher;
        case 0:
          return Logging.notUser;
      }
    }
    return Logging.notUser;
  }

  Future<bool> _refreshToken() async {
    bool approved = await refreshLoginService();
    if (approved) {
      await _loadUser();
      if (_user != null) {
        if (_user!.groups.isNotEmpty) {
          if (_user!.groups != []) {
            setGroup(_user!.groups.first);
            return true;
          }
        }
      }
    }
    return false;
  }

  String? passwordValidator(String? value) {
    if (value == null) {
      return 'password cannot be null';
    } else {
      if (value.isEmpty) {
        return 'الرجاء إدخال كلمة مرور';
      } else if (value.length < 8) {
        return 'كلمة المرور لا تقل عن 8 خانات';
      }
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null) {
      return 'user name cannot be null';
    } else {
      if (value.isEmpty) {
        return 'الرجاء إدخال إسم مستخدم';
      } else if (value.length < 4) {
        return 'إسم مستخدم لا يقل عن 4 خانات';
      } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
        return 'إسم المستخدم يحتوي علي رموز غير صحيحة';
      }
    }
    return null;
  }

  void setLoginLoading(bool value) {
    _isLoginLoading = value;
    notifyListeners();
  }

  Future<void> _loadUser() async {
    _user ??= await userServices.user;
    notifyListeners();
  }

  Future<void> _loadStudent() async {
    if (_studentAccount == null) {
      _studentAccount = await userServices.student;
      notifyListeners();
    }
  }

  Future<void> _loadProject() async {
    _studentProject ??= await userServices.project;
    notifyListeners();
  }

  void setGroup(int group) {
    _group = group;
    notifyListeners();
  }

  Future<void> updateUserFirstName() async {
    if (_user != null) {
      if (firstNameController.text.isNotEmpty) {
        _user = await userServices.updateUserFirstName(
            _user!.id, firstNameController.text);
        notifyListeners();
      }
    }
  }

  Future<void> updateUserLastName() async {
    if (_user != null) {
      if (lastNameController.text.isNotEmpty) {
        _user = await userServices.updateUserLastName(
            _user!.id, lastNameController.text);
      }
      notifyListeners();
    }
  }
}
