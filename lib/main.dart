import 'package:flutter/material.dart';
import 'package:project_manager/pages/admin_page.dart';
import 'package:project_manager/pages/admin_project_page.dart';
import 'package:project_manager/pages/admin_students_page.dart';
import 'package:project_manager/pages/admin_teacher_page.dart';
import 'package:project_manager/pages/chat_page.dart';
import 'package:project_manager/pages/login_page.dart';
import 'package:project_manager/pages/settings_page.dart';
import 'package:project_manager/pages/student_page.dart';
import 'package:project_manager/pages/teacher_page.dart';
import 'package:project_manager/providers/admin_project_provider.dart';
import 'package:project_manager/providers/admin_student_provider.dart';
import 'package:project_manager/providers/admin_teacher_provider.dart';
import 'package:project_manager/providers/chat_provider.dart';
import 'package:project_manager/providers/edit_project_provider.dart';
import 'package:project_manager/providers/edit_student_provider.dart';
import 'package:project_manager/providers/edit_teacher_provider.dart';
import 'package:project_manager/providers/register_provider.dart';
import 'package:project_manager/providers/teacher_provider.dart';
import 'package:project_manager/providers/user_provider.dart';
import 'package:project_manager/providers/student_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => StudentProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => TeacherProvider()),
    ChangeNotifierProvider(create: (context) => AdminStudentProvider()),
    ChangeNotifierProvider(create: (context) => RegisterProvider()),
    ChangeNotifierProvider(create: (context) => AdminEditStudentProvider()),
    ChangeNotifierProvider(create: (context) => AdminTeacherProvider()),
    ChangeNotifierProvider(create: (context) => AdminEditTeacherProvider()),
    ChangeNotifierProvider(create: (context) => AdminProjectProvider()),
    ChangeNotifierProvider(create: (context) => AdminEditProjectProvider()),
    ChangeNotifierProvider(create: (context) => ChatProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManagerApp',
      routes: {
        '/home': (context) => const HomePage(),
        '/': (context) => const LoginPage(),
        '/student': (context) => const StudentPage(),
        '/settings': (context) => const SettingsPage(),
        '/chat': (context) => const ChatPage(),
        '/teacher': (context) => const TeacherPage(),
        '/admin': (context) => const AdminPage(),
        '/adminStudentList': (context) => const AdminStudentListPage(),
        '/adminStudentDelete': (context) => const AdminStudentDeletePage(),
        '/adminStudentAdd': (context) => const AdminStudentAddPage(),
        '/adminStudentEdit': (context) => const AdminStudentEditPage(),
        '/adminTeacherList': (context) => const AdminTeacherListPage(),
        '/adminTeacherAdd': (context) => const AdminTeacherAddPage(),
        '/adminTeacherEdit': (context) => const AdminTeacherEditPage(),
        '/adminTeacherDelete': (context) => const AdminTeacherDeletePage(),
        '/adminProjectList': (context) => const AdminProjectListPage(),
        '/adminProjectDelete': (context) => const AdminProjectDeletePage(),
        '/adminProjectAccept': (context) => const AdminProjectAcceptPage(),
        '/adminProjectAddStudent': (context) =>
            const AdminProjectAddStudentPage(),
        '/adminProjectSetTeacher': (context) =>
            const AdminProjectSetTeacherPage(),
        '/adminProjectEdit': (context) => const AdminProjectEditPage(),
      },
      theme: ThemeData(
        fontFamily: "Tajawal",
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff00577B)),
        useMaterial3: true,
      ),
      // home:const LoginPage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, login, child) {
        return FutureBuilder(
          future: login.refreshLogin,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData || login.user != null) {
              switch (login.group) {
                case 2:
                  return const StudentPage();
                case 1:
                  return const AdminPage();
                case 3:
                  return const TeacherPage();
              }
            } else if (snapshot.hasError) {
              return const Text("error");
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }
}
