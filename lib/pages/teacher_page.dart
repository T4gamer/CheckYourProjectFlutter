import 'package:flutter/material.dart';
import 'package:project_manager/pages/widgets/page_important_dates.dart';
import 'package:project_manager/pages/widgets/page_suggestion_list.dart';
import 'package:project_manager/pages/widgets/page_teacher_details.dart';
import 'package:project_manager/pages/widgets/widget_appbar.dart';
import 'package:project_manager/pages/widgets/page_archive.dart';
import 'package:project_manager/pages/widgets/widget_buttom_navigator.dart';
import 'package:project_manager/providers/teacher_provider.dart';
import 'package:provider/provider.dart';

class TeacherPage extends StatelessWidget {
  const TeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProvider>(builder: (context, provider, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          bottomNavigationBar: const TeacherBottomNavigator(),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              BaseAppBar(content: [
                FutureBuilder(
                    future: provider.user,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    AssetImage('assets/default_profile.jpg'),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${snapshot.data?.firstName} ${snapshot.data?.lastName}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    AssetImage('assets/default_profile.jpg'),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
              ]),
              FutureBuilder(
                future: provider.loadTeacher(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      return provider.selectedIndex == 0
                          ? const TeacherImportantDatesListWidget()
                          : provider.selectedIndex == 1
                              ? const TeacherSuggestionList()
                              : provider.selectedIndex == 2
                                  ? const TeacherDetails()
                                  : const TeacherArchive();
                    }
                  }
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
