import 'package:flutter/material.dart';
import 'package:project_manager/pages/widgets/widget_admin_base_page.dart';
import 'package:project_manager/pages/widgets/widget_new_project_dialog.dart';
import 'package:project_manager/providers/admin_project_provider.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminBasePage(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AdminPageHeadTitle(
                  title: "الطلبة", image: "assets/students-image-admin.png"),
              AdminElevatedButton(
                title: "قائمة الطلبة",
                onPress: () {
                  Navigator.pushNamed(context, "/adminStudentList");
                },
              ),
              AdminElevatedButton(
                  title: "إضافة طالب",
                  onPress: () {
                    Navigator.pushNamed(context, "/adminStudentAdd");
                  }),
              AdminElevatedButton(
                  title: "حذف طالب",
                  onPress: () {
                    Navigator.pushNamed(context, "/adminStudentDelete");
                  }),
              AdminElevatedButton(
                  title: "تعديل بيانات",
                  onPress: () {
                    Navigator.pushNamed(context, "/adminStudentEdit");
                  }),
              const AdminPageHeadTitle(
                  title: "الاساتذة", image: "assets/teachers-image-admin.png"),
              AdminElevatedButton(
                  title: "قائمة الاساتذة",
                  onPress: () {
                    Navigator.pushNamed(context, "/adminTeacherList");
                  }),
              AdminElevatedButton(
                  title: "إضافة استاذ",
                  onPress: () {
                    Navigator.pushNamed(context, "/adminTeacherAdd");
                  }),
              AdminElevatedButton(
                  title: "تعديل بيانات استاذ",
                  onPress: () {
                    Navigator.pushNamed(context, "/adminTeacherEdit");
                  }),
              AdminElevatedButton(title: "حذف استاذ", onPress: () {
                Navigator.pushNamed(context, "/adminTeacherDelete");
              }),
              const AdminPageHeadTitle(
                  title: "المشاريع", image: "assets/project-image-admin.png"),
              AdminElevatedButton(
                  title: "إضافة مشروع",
                  onPress: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddProjectDialog(onSave: (title) {
                            Provider.of<AdminProjectProvider>(context,
                                    listen: false)
                                .createProject(title);
                          });
                        });
                    const snackBar = SnackBar(
                      content: Text('تم اضافة المشروع'),
                    );
                    const snackBarFailed = SnackBar(
                      content: Text('لم تتم إضافة المشروع'),
                    );
                    Provider.of<AdminProjectProvider>(context, listen: false)
                            .done
                        ? ScaffoldMessenger.of(context).showSnackBar(snackBar)
                        : ScaffoldMessenger.of(context).showSnackBar(snackBarFailed);
                  }),
              AdminElevatedButton(
                  title: "إضافة طالب الي مشروع", onPress: () {
                Navigator.pushNamed(context, "/adminProjectAddStudent");
              }),
              AdminElevatedButton(title: "تحديد مشرف لمشروع", onPress: () {
                Navigator.pushNamed(context, "/adminProjectSetTeacher");
              }),
              AdminElevatedButton(
                  title: "أرشيف المشاريع",
                  onPress: () {
                    Navigator.pushNamed(context, "/adminProjectList");
                  }),
              AdminElevatedButton(title: "حذف مشروع", onPress: () {
                Navigator.pushNamed(context, "/adminProjectDelete");
              }),
              AdminElevatedButton(title: "تعديل بيانات مشروع", onPress: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminElevatedButton extends StatelessWidget {
  final void Function()? onPress;
  final String title;

  const AdminElevatedButton({super.key, this.onPress, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: 300,
        child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                elevation: MaterialStatePropertyAll(4),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))))),
            onPressed: onPress,
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            )),
      ),
    );
  }
}

class AdminPageHeadTitle extends StatelessWidget {
  final String title;
  final String image;

  const AdminPageHeadTitle(
      {super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9F9),
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                  // 'assets/students-image-admin.png',
                  image),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
