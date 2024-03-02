import 'package:flutter/material.dart';
import 'package:project_manager/pages/widgets/page_archive.dart';
import 'package:project_manager/pages/widgets/widget_admin_base_page.dart';
import 'package:project_manager/pages/widgets/widget_confirm_delete.dart';
import 'package:project_manager/pages/widgets/widget_project.dart';
import 'package:project_manager/pages/widgets/widget_searchbar.dart';
import 'package:provider/provider.dart';

import '../providers/admin_project_provider.dart';
import 'admin_students_page.dart';

class AdminProjectListPage extends StatelessWidget {
  const AdminProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminBasePage(
      child: Expanded(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("قائمة المشاريع",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    "بحث",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
            ),
            AdminSearchbar(
                onChanged: (String val) {
                  Provider.of<AdminProjectProvider>(context, listen: false)
                      .filterProjectsList();
                },
                editingController:
                    Provider.of<AdminProjectProvider>(context, listen: false)
                        .searchbarController),
            const AdminArchive(),
          ],
        ),
      ),
    );
  }
}

class AdminProjectDeletePage extends StatelessWidget {
  const AdminProjectDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminBasePage(
      child:
          Consumer<AdminProjectProvider>(builder: (context, provider, child) {
        return Expanded(
          child: FutureBuilder(
              future: provider.loadProjects(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("قائمة المشاريع",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        AdminSearchbar(
                            onChanged: (String val) {
                              provider.filterProjectsList();
                            },
                            editingController: provider.searchbarController),
                        Expanded(
                            child: provider.filteredProjectList.isNotEmpty
                                ? ListView(
                                    children: List.generate(
                                        provider.filteredProjectList.length,
                                        (index) {
                                      final item =
                                          provider.filteredProjectList[index];
                                      return InkWell(
                                        onTap: () {
                                          // provider.setCurrentProject(item);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DeleteConfirmationDialog(
                                                onConfirm: () {
                                                  provider.deleteProject(
                                                      item.id, index, false);
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            ProjectWidget(
                                              title: item.title,
                                              image: item.image,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: IconButton(
                                                onPressed: () {
                                                  provider.deleteProject(
                                                      item.id, index, false);
                                                },
                                                icon: const Icon(Icons.delete),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  )
                                : provider.projectList.isNotEmpty
                                    ? ListView(
                                        children: List.generate(
                                            provider.projectList.length,
                                            (index) {
                                          final item =
                                              provider.projectList[index];
                                          return InkWell(
                                            onTap: () {
                                              // provider.setCurrentProject(item);
                                              provider.deleteProject(
                                                  item.id, index, true);
                                            },
                                            child: Stack(
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                ProjectWidget(
                                                  title: item.title,
                                                  image: item.image,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      provider.deleteProject(
                                                          item.id, index, true);
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      )
                                    : const Center(
                                        child: Text("لا توجد مشاريع لعرضها"))),
                      ],
                    );
                  } else {
                    return const Center(child: Text("لا توجد مشاريع لعرضها"));
                  }
                }
                return const Center(child: CircularProgressIndicator());
              }),
        );
      }),
    );
  }
}

class AdminProjectAddStudentPage extends StatelessWidget {
  const AdminProjectAddStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminBasePage(
      child: Expanded(
        child:
            Consumer<AdminProjectProvider>(builder: (context, provider, child) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("اختر مشروع لإدراج طالب اليه",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      "بحث",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
              ),
              provider.currentProject == null || provider.studentToAdd == null
                  ? AdminSearchbar(
                      onChanged: (String val) {
                        provider.filterProjectsList();
                        provider.filterStudentList();
                      },
                      editingController: provider.searchbarController)
                  : Container(),
              !provider.isProjectSelected
                  ? Expanded(
                      child: FutureBuilder(
                          future: provider.loadProjects(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data == true) {
                                if (provider.filteredProjectList.isNotEmpty) {
                                  return ListView(
                                    children: List.generate(
                                        provider.filteredProjectList.length,
                                        (index) {
                                      final item =
                                          provider.filteredProjectList[index];
                                      if (item.id ==
                                          provider.currentProject?.id) {
                                        return Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: [
                                            ProjectWidget(
                                              title: item.title,
                                              image: item.image,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: const Icon(
                                                  Icons.check_outlined,
                                                  color: Colors.greenAccent,
                                                  size: 38,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return InkWell(
                                        onTap: () {
                                          provider.setCurrentProject(item);
                                        },
                                        child: ProjectWidget(
                                          title: item.title,
                                          image: item.image,
                                        ),
                                      );
                                    }),
                                  );
                                }
                                return provider.projectList.isNotEmpty
                                    ? ListView(
                                        children: List.generate(
                                            provider.projectList.length,
                                            (index) {
                                          final item =
                                              provider.projectList[index];
                                          if (item.id ==
                                              provider.currentProject?.id) {
                                            return Stack(
                                              alignment: Alignment.bottomLeft,
                                              children: [
                                                ProjectWidget(
                                                  title: item.title,
                                                  image: item.image,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    child: const Icon(
                                                      Icons.check_outlined,
                                                      color: Colors.greenAccent,
                                                      size: 38,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return InkWell(
                                            onTap: () {
                                              provider.setCurrentProject(item);
                                            },
                                            child: ProjectWidget(
                                              title: item.title,
                                              image: item.image,
                                            ),
                                          );
                                        }),
                                      )
                                    : const Center(
                                        child: Text("لا توجد مشاريع لعرضها"));
                              } else {
                                return const Center(
                                    child: Text("لا توجد مشاريع لعرضها"));
                              }
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                    )
                  : Expanded(
                      child: FutureBuilder(
                          future: provider.loadStudents(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (provider.filterList.isNotEmpty) {
                                return ListView(
                                  children: List.generate(
                                      provider.filterList.length, (index) {
                                    final item = provider.filterList[index];
                                    if (provider.studentToAdd?.id == item.id) {
                                      return Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          StudentListItem(
                                              imageLink: "",
                                              firstName: item.user.firstName,
                                              lastName: item.user.lastName,
                                              userName: item.user.username),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: const Icon(
                                                Icons.check_outlined,
                                                color: Colors.greenAccent,
                                                size: 38,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return InkWell(
                                      onTap: () {
                                        provider.setStudentToAdd(item);
                                      },
                                      child: StudentListItem(
                                          imageLink: "",
                                          firstName: item.user.firstName,
                                          lastName: item.user.lastName,
                                          userName: item.user.username),
                                    );
                                  }),
                                );
                              }
                              return ListView(
                                children: List.generate(snapshot.data!.length,
                                    (index) {
                                  final item = snapshot.data![index];
                                  if (provider.studentToAdd?.id == item.id) {
                                    return Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        StudentListItem(
                                            imageLink: "",
                                            firstName: item.user.firstName,
                                            lastName: item.user.lastName,
                                            userName: item.user.username),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: const Icon(
                                              Icons.check_outlined,
                                              color: Colors.greenAccent,
                                              size: 38,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return InkWell(
                                    onTap: () {
                                      provider.setStudentToAdd(item);
                                    },
                                    child: StudentListItem(
                                        imageLink: "",
                                        firstName: item.user.firstName,
                                        lastName: item.user.lastName,
                                        userName: item.user.username),
                                  );
                                }),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text("$snapshot");
                              }
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.setIsProjectSelected(false);
                        provider.setStudentToAdd(null);
                        provider.setCurrentProject(null);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xff00577B))),
                      child: const Text(
                        "تراجع",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: provider.isProjectSelected &&
                                provider.studentToAdd != null
                            ? () async {
                                final response =
                                    await provider.addStudentToProject();
                                const snackBar = SnackBar(
                                  content: Text('تم اضافة الطالب للمشروع'),
                                );
                                const snackBarFailed = SnackBar(
                                  content: Text('لم تتم إضافة الطالب للمشروع'),
                                );
                                if (response) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBarFailed);
                                }
                                provider.setIsProjectSelected(false);
                                provider.setStudentToAdd(null);
                                provider.setCurrentProject(null);
                              }
                            : provider.currentProject != null &&
                                    provider.isProjectSelected == false
                                ? () {
                                    provider.setIsProjectSelected(true);
                                  }
                                : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors
                                  .grey; // Change disabled button background color
                            }
                            return const Color(
                                0xff00577B); // Change enabled button background color
                          }),
                        ),
                        // backgroundColor:
                        //     MaterialStatePropertyAll()),
                        child: !provider.isProjectSelected
                            ? const Text(
                                "أختر المشروع",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              )
                            : provider.studentToAdd == null
                                ? const Text(
                                    "أختر طالب",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  )
                                : const Text(
                                    "إضافة",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class AdminProjectSetTeacherPage extends StatelessWidget {
  const AdminProjectSetTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminBasePage(
      child: Expanded(
        child:
            Consumer<AdminProjectProvider>(builder: (context, provider, child) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("اختر مشروع لتعين مشرف له",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      "بحث",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
              ),
              provider.currentProject == null || provider.teacherToSet == null
                  ? AdminSearchbar(
                      onChanged: (String val) {
                        provider.filterProjectsList();
                        provider.filterTeacherList();
                      },
                      editingController: provider.searchbarController)
                  : Container(),
              !provider.isProjectSelected
                  ? Expanded(
                      child: FutureBuilder(
                          future: provider.loadProjects(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data == true) {
                                if (provider.filteredProjectList.isNotEmpty) {
                                  return ListView(
                                    children: List.generate(
                                        provider.filteredProjectList.length,
                                        (index) {
                                      final item =
                                          provider.filteredProjectList[index];
                                      if (item.id ==
                                          provider.currentProject?.id) {
                                        return Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: [
                                            ProjectWidget(
                                              title: item.title,
                                              image: item.image,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: const Icon(
                                                  Icons.check_outlined,
                                                  color: Colors.greenAccent,
                                                  size: 38,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return InkWell(
                                        onTap: () {
                                          provider.setCurrentProject(item);
                                        },
                                        child: ProjectWidget(
                                          title: item.title,
                                          image: item.image,
                                        ),
                                      );
                                    }),
                                  );
                                }
                                return provider.projectList.isNotEmpty
                                    ? ListView(
                                        children: List.generate(
                                            provider.projectList.length,
                                            (index) {
                                          final item =
                                              provider.projectList[index];
                                          if (item.id ==
                                              provider.currentProject?.id) {
                                            return Stack(
                                              alignment: Alignment.bottomLeft,
                                              children: [
                                                ProjectWidget(
                                                  title: item.title,
                                                  image: item.image,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    child: const Icon(
                                                      Icons.check_outlined,
                                                      color: Colors.greenAccent,
                                                      size: 38,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return InkWell(
                                            onTap: () {
                                              provider.setCurrentProject(item);
                                            },
                                            child: ProjectWidget(
                                              title: item.title,
                                              image: item.image,
                                            ),
                                          );
                                        }),
                                      )
                                    : const Center(
                                        child: Text("لا توجد مشاريع لعرضها"));
                              } else {
                                return const Center(
                                    child: Text("لا توجد مشاريع لعرضها"));
                              }
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                    )
                  : Expanded(
                      child: FutureBuilder(
                          future: provider.loadTeachers(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (provider.filteredTeacherList.isNotEmpty) {
                                return ListView(
                                  children: List.generate(
                                      provider.filteredTeacherList.length,
                                      (index) {
                                    final item =
                                        provider.filteredTeacherList[index];
                                    if (provider.teacherToSet?.id == item.id) {
                                      return Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          StudentListItem(
                                              imageLink: "",
                                              firstName: item.user.firstName,
                                              lastName: item.user.lastName,
                                              userName: item.user.username),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: const Icon(
                                                Icons.check_outlined,
                                                color: Colors.greenAccent,
                                                size: 38,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return InkWell(
                                      onTap: () {
                                        provider.setCurrentTeacher(item);
                                      },
                                      child: StudentListItem(
                                          imageLink: "",
                                          firstName: item.user.firstName,
                                          lastName: item.user.lastName,
                                          userName: item.user.username),
                                    );
                                  }),
                                );
                              }
                              return ListView(
                                children: List.generate(snapshot.data!.length,
                                    (index) {
                                  final item = snapshot.data![index];
                                  if (provider.teacherToSet?.id == item.id) {
                                    return Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        StudentListItem(
                                            imageLink: "",
                                            firstName: item.user.firstName,
                                            lastName: item.user.lastName,
                                            userName: item.user.username),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: const Icon(
                                              Icons.check_outlined,
                                              color: Colors.greenAccent,
                                              size: 38,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return InkWell(
                                    onTap: () {
                                      provider.setCurrentTeacher(item);
                                    },
                                    child: StudentListItem(
                                        imageLink: "",
                                        firstName: item.user.firstName,
                                        lastName: item.user.lastName,
                                        userName: item.user.username),
                                  );
                                }),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text("$snapshot");
                              }
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.setIsProjectSelected(false);
                        provider.setStudentToAdd(null);
                        provider.setCurrentProject(null);
                        provider.setCurrentTeacher(null);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xff00577B))),
                      child: const Text(
                        "تراجع",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: provider.isProjectSelected &&
                                provider.teacherToSet != null
                            ? () async {
                                final response =
                                    await provider.setTeacherToProject();
                                const snackBar = SnackBar(
                                  content: Text('تم تحديد  مشرف المشروع'),
                                );
                                const snackBarFailed = SnackBar(
                                  content: Text('لم يتم تحديد  مشرف المشروع'),
                                );
                                if (response) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBarFailed);
                                }
                                provider.setIsProjectSelected(false);
                                provider.setStudentToAdd(null);
                                provider.setCurrentProject(null);
                                provider.setCurrentTeacher(null);
                              }
                            : provider.currentProject != null &&
                                    provider.isProjectSelected == false
                                ? () {
                                    provider.setIsProjectSelected(true);
                                  }
                                : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors
                                  .grey; // Change disabled button background color
                            }
                            return const Color(
                                0xff00577B); // Change enabled button background color
                          }),
                        ),
                        // backgroundColor:
                        //     MaterialStatePropertyAll()),
                        child: !provider.isProjectSelected
                            ? const Text(
                                "أختر المشروع",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              )
                            : provider.teacherToSet == null
                                ? const Text(
                                    "أختر استاذ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  )
                                : const Text(
                                    "تغيير",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
