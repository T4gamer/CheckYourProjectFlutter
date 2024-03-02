import 'package:flutter/material.dart';
import 'package:project_manager/models/requirement_list.dart';
import 'package:project_manager/models/suggestion_list.dart';
import 'package:project_manager/services/image_services.dart';
import 'package:project_manager/services/user_services.dart';

import '../models/important_date_list.dart';
import '../models/project_list.dart';
import '../services/models_services.dart';

class StudentProvider extends ChangeNotifier {
  final ImageService _imageService = ImageService();
  final UserService _userService = UserService();
  int _selectedIndex = 0;
  String _errorMessage = "";
  bool _isError = false;
  bool _newSuggestion = false;
  Suggestion? _selectedSuggestion;
  String _imageBase64 = "";
  String _suggestionUrl = "https://placehold.co/600x400.png";
  String _suggestionTitle = "";
  String _suggestionContent = "";

  List<ImportantDate> _importantDates = [];
  List<Suggestion> _suggestionList = [];
  List<Project> _projectList = [];
  List<Requirement> _requirementList = [];

  int get selectedIndex => _selectedIndex;

  String get suggestionUrl => _suggestionUrl;

  String get errorMessage => _errorMessage;

  String get imageBase64 => _imageBase64;

  bool get isError => _isError;

  bool get newSuggestion => _newSuggestion;

  Suggestion? get selectedSuggestion => _selectedSuggestion;

  Future<List<ImportantDate>> get importantDates async => _loadImportantDates();

  List<Suggestion> get suggestionList => _suggestionList;

  List<Project> get projectList => _projectList;

  Future<Project?> get currentProject async => await _getCurrentProject();

  List<Requirement> get requirementList => _requirementList;

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void onItemTapped(int index) {
    _selectedIndex = index;
    switch (_selectedIndex) {
      case 0:
        _loadImportantDates();
      case 1:
        _loadSuggestions();
      case 3:
        _loadProjects();
    }
    notifyListeners();
  }

  Future<void> retry() async {
    _loadImportantDates();
    _loadSuggestions();
    _loadProjects();
    notifyListeners();
  }

  Future<Project?> _getCurrentProject() async {
    return await _userService.project;
  }

  Future<List<ImportantDate>> _loadImportantDates() async {
    try {
      final ImportantDateList data = await getImportantDatesList();
      _importantDates = data.importantDate;
      return data.importantDate;
    } catch (e) {
      setErrorMessage(e.toString());
      _isError = true;
    }
    notifyListeners();
    return [];
  }

  Future<void> _loadSuggestions() async {
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
    } catch (e) {
      setErrorMessage(e.toString());
      _isError = true;
    }
    notifyListeners();
  }

  Future<void> _loadProjects() async {
    try {
      final data = await getProjectList();
      _projectList = data.project;
    } catch (e) {
      setErrorMessage(e.toString());
      _isError = true;
    }
    notifyListeners();
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
    notifyListeners();
  }

  void setNewSuggestionTitle(String value) {
    _suggestionTitle = value;
  }

  void setNewSuggestionContent(String value) {
    _suggestionContent = value;
  }

  Future<void> createSuggestion() async {
    final project = await _userService.project;
    if (project != null) {
      final suggestion = Suggestion(
          project: project.id,
          id: 0,
          content: _suggestionContent,
          status: "w",
          title: _suggestionTitle,
          image: _suggestionUrl);
      print(suggestion);
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
