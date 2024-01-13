import 'package:flutter/material.dart';
import 'package:project_manager/pages/widgets/widget_appbar.dart';
import 'package:project_manager/providers/user_provider.dart';
import 'package:project_manager/services/login_services.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<UserProvider>(builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BaseAppBar(
                content: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "الإعدادات",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customText('تغيير الإسم الأول'),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(64, 8, 8, 8),
                            child: TextFormField(
                              onChanged: (value) {
                                provider.firstNameController.text = value;
                              },
                              decoration: InputDecoration(
                                  hintText: provider.user?.firstName,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32))),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: saveIconButton(() {
                              provider.updateUserFirstName();
                              provider.firstNameController.text = "";
                            }),
                          ),
                        ],
                      ),
                      customDivider(),
                      customText("تغيير الاسم الأخير"),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(64, 8, 8, 8),
                            child: TextFormField(
                              onChanged: (value) {
                                provider.lastNameController.text = value;
                              },
                              decoration: InputDecoration(
                                  hintText: provider.user?.lastName,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32))),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: saveIconButton(() {
                              provider.updateUserLastName();
                              provider.lastNameController.text = "";
                            }),
                          ),
                        ],
                      ),
                      customDivider(),
                      customText("تغيير كلمة  المرور"),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(64, 8, 8, 8),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  hintText: "********",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32))),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: saveIconButton(() {}),
                          ),
                        ],
                      ),
                      customDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                provider.setGroup(0);
                                provider.setUser(null);
                                logout();
                                // Navigator.pushReplacementNamed(
                                //     context, "/");
                                Navigator.popUntil(context, (route) => route.isFirst);
                              },
                              child: const Text("تسجيل الخروج")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

Widget customDivider() => const Divider(
      color: Color(0xff196D8F), // color of the separator
      thickness: 1, // thickness of the separator
      indent: 16, // adjust the indent as needed
      endIndent: 16, // adjust the end indent as needed
    );

Widget customText(title) => Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );

Widget saveIconButton(void Function()? onPress) {
  return IconButton(
    onPressed: onPress,
    icon: const Icon(Icons.save),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shadowColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.8)),
        elevation: MaterialStateProperty.all(2)),
  );
}
