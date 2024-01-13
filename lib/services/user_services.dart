import '../models/project_list.dart';
import '../models/student_list.dart';
import '../models/user_list.dart';
import 'models_services.dart';

class UserService {
  static final UserService _userService = UserService._internal();

  factory UserService() {
    return _userService;
  }

  UserService._internal();

  User? _user;
  Project? _studentProject;
  Student? _studentAccount;

  Future<User?> get user async => await _getUser();

  Future<Student?> get student => _getStudent();

  Future<Project?> get project => _getProject();

  Future<User?> _getUser() async {
    _user = await getMyAccount();
    return _user;
  }

  Future<Project?> _getProject() async {
    if (_studentAccount != null) {
      _studentProject = await getProject(_studentAccount!.project);
      return _studentProject;
    }
    return null;
  }

  Future<Student?> _getStudent() async {
    if (_user != null) {
      if (_user!.groups.first == 2) {
        _studentAccount = await getStudent(_user!.id);
        return _studentAccount;
      }
    }
    return null;
  }

  Future<User> updateUserFirstName(int id, String firstName) async {
    return await patchUser(id, firstName, null, null, null);
  }

  Future<User> updateUserLastName(int id, String lastName) async {
    return await patchUser(id, null, lastName, null, null);
  }
}
