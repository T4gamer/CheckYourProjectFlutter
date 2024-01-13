import 'package:flutter/cupertino.dart';
import 'package:project_manager/models/requirement_list.dart';
import 'package:project_manager/services/image_services.dart';
import 'package:project_manager/services/user_services.dart';

import '../models/important_date_list.dart';
import '../models/project_list.dart';
import '../models/suggestion_list.dart';
import '../models/teacher_list.dart';
import '../models/user_list.dart';
import '../services/models_services.dart';

class TeacherProvider extends ChangeNotifier {
  static final UserService _userService = UserService();
  static final ImageService _imageService = ImageService();
  int _selectedIndex = 0;
  bool _newSuggestion = false;
  List<Project> _projectList = [];
  List<Suggestion> _suggestionList = [];
  List<Requirement> _requirementList = [];
  String _imageBase64 = "";
  String _suggestionUrl = "";
  String _suggestionContent = "";
  String _suggestionTitle = "";

  Project? _currentProject;

  Suggestion? _selectedSuggestion;

  Teacher? _teacher;

  int get selectedIndex => _selectedIndex;

  bool get newSuggestion => _newSuggestion;

  String get suggestionUrl => _suggestionUrl;

  Suggestion? get selectedSuggestion => _selectedSuggestion;

  Project? get currentProject => _currentProject;

  Teacher? get teacher => _teacher;

  Future<User?> get user async => await _userService.user;

  List<Project> get teacherProjectList => setTeacherProjects();

  List<Project> get projectList => _projectList;

  Future<List<ImportantDate>> get importantDates => _loadImportantDates();

  Future<List<Suggestion>> get suggestionList => _loadSuggestions();

  List<Requirement> get requirementList => _requirementList;


  void onItemTapped(int index) {
    _selectedIndex = index;
    switch (_selectedIndex) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
    }
    notifyListeners();
  }

  Future<bool> loadTeacher() async {
    final user = await _userService.user;
    if (user != null) {
      _teacher = await getTeacher(user.id);
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> loadProjects() async {
    try {
      final data = await getProjectList();
      _projectList = data.project;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Project> setTeacherProjects() {
    if (_projectList.isNotEmpty && teacher != null) {
      return _projectList
          .where((element) => element.teacher == _teacher!.id)
          .toList();
    } else {
      return [];
    }
  }

  Future<List<ImportantDate>> _loadImportantDates() async {
    try {
      final ImportantDateList data = await getImportantDatesList();
      return data.importantDate;
    } catch (e) {}
    notifyListeners();
    return [];
  }

  void setCurrentProject(Project item) {
    _currentProject = item;
    notifyListeners();
  }

  Future<List<Suggestion>> _loadSuggestions() async {
    try {
      final data = await getSuggestionList();
      final requirements = await getRequirementList();
      _requirementList = requirements.requirement;
      if (_selectedSuggestion != null) {
        _requirementList = _requirementList
            .where((element) => element.suggestion == _selectedSuggestion!.id)
            .toList();
      }
      _suggestionList = data.suggestion;
      notifyListeners();
      return _suggestionList;
    } catch (e) {
    }
    notifyListeners();
    return [];
  }

  void setSelectedSuggestion(int index) {
    _selectedSuggestion = _suggestionList[index];
    _requirementList = [];
    _loadSuggestions();
    notifyListeners();
  }

  void createRequirement(String content) async {
    if (_selectedSuggestion != null) {
      final requirement =
          await postRequirement(_selectedSuggestion!.id, content);
      _requirementList.add(requirement);
      notifyListeners();
    }
  }

  void setNewSuggestion(bool val) {
    _newSuggestion = val;
    notifyListeners();
  }

  void setImageBase64(String image) {
    _imageBase64 = image;
    notifyListeners();
  }

  Future<void> uploadImage() async {
    final data = await _imageService.postImage(_imageBase64);
    _suggestionUrl = data.data.url;
  }

  void setNewSuggestionTitle(String value) {
    _suggestionTitle = value;
  }

  void setNewSuggestionContent(String value) {
    _suggestionContent = value;
  }

  Future<void> createSuggestion() async {
    if (currentProject != null) {
      final suggestion = Suggestion(
          project: currentProject!.id,
          id: 0,
          content: _suggestionContent,
          status: "w",
          title: _suggestionTitle,
          image: _suggestionUrl);
      await postSuggestion(suggestion);
    }
  }

  void deleteSuggestion() {
    delSuggestion(_selectedSuggestion!.id);
    onItemTapped(1);
    _selectedSuggestion = null;
  }

  void deleteRequirement(int index) {
    delRequirement(_requirementList[index].id);
    _requirementList.removeAt(index);
    notifyListeners();
  }

  Future<void> editRequirement(int id, Requirement requirement) async {
    await patchRequirement(id, requirement.name, requirement.status, null);
    _loadSuggestions();
  }
}
