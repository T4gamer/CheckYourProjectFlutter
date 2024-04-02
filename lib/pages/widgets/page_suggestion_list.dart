import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_manager/pages/widgets/widget_dialog.dart';
import 'package:project_manager/pages/widgets/widget_suggestion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_manager/providers/admin_project_provider.dart';
import 'package:project_manager/providers/student_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/teacher_provider.dart';

class StudentSuggestionList extends StatelessWidget {
  const StudentSuggestionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(builder: (context, provider, _) {
      return Expanded(
        child: !provider.newSuggestion
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xff00577B))),
                        onPressed: () async {
                          final project = await provider.currentProject;
                          if (project != null) {
                            provider.setNewSuggestion(true);
                          } else {
                            final scaffold = ScaffoldMessenger.of(context);
                            scaffold.showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "لم يتم تعين مشروع لك لا يمكنك اضافة مقترح"),
                                duration: Duration(seconds: 4),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "إضافة مقترح للمشروع",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        )),
                  ),
                  provider.suggestionList.isNotEmpty
                      ? Expanded(
                          child: ListView(
                          children: List.generate(
                              provider.suggestionList.length, (index) {
                            final suggestion = provider.suggestionList[index];
                            return Suggestion(
                              onPress: () {
                                // provider.setSelectedSuggestion(index);
                                provider.onItemTapped(2);
                              },
                              title: suggestion.title,
                              content: suggestion.content,
                              status: suggestion.status,
                              image: suggestion.image,
                            );
                          }),
                        ))
                      : const Center(
                          child: Text("لا توجد عناصر"),
                        )
                ],
              )
            : const AddSuggestionPage(),
      );
    });
  }
}

class AddSuggestionPage extends StatelessWidget {
  const AddSuggestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<StudentProvider>(builder: (context, provider, _) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "إضافة مقترح جديد",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      onChanged: provider.setNewSuggestionTitle,
                      decoration: InputDecoration(
                          hintText: "عنوان المقترح",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                  ),
                  TextField(
                      onChanged: provider.setNewSuggestionContent,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText:
                            "تفاصيل المقترح يكمنك الكتابة هنا كما تشاء ...",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                      )),
                  provider.suggestionUrl != ""
                      ? Center(
                          child: SizedBox(
                              width: 250,
                              height: 250,
                              child: Image.network(provider.suggestionUrl)),
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "إختيار صورة",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                      IconButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (pickedFile != null) {
                              final file = File(pickedFile.path);
                              final bytes = await file.readAsBytes();
                              final base64Image = base64Encode(bytes);
                              provider.setImageBase64(base64Image);
                              await provider.uploadImage();
                            }
                          },
                          icon: const Icon(
                            Icons.upload_file,
                            size: 40,
                            color: Color(0xff196D8F),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            provider.setNewSuggestion(false);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.arrow_back_ios),
                              ),
                              Text(
                                "رجوع",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )),
                      ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SaveConfirmationDialog(onPress: () {
                                    provider.loadingSaveSuggestion = true;
                                    provider.createProject();
                                    provider.setNewSuggestion(false);
                                  });
                                });
                          },
                          child: const Row(
                            children: [
                              Text(
                                "حفظ المقترح",
                                style: TextStyle(fontSize: 24),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.save),
                              )
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

class TeacherGradingView extends StatelessWidget {
  const TeacherGradingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProvider>(builder: (context, provider, _) {
      return Expanded(
        child: provider.currentProject != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'التقييم',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'المعيار',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<int>(
                          value: provider.criterion1,
                          onChanged: (value) {
                            provider.updateCriterion1(value ?? 0);
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 0,
                              child: Text('0'),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text('1'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text('2'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text('3'),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text('4'),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text('5'),
                            ),
                            DropdownMenuItem(
                              value: 6,
                              child: Text('6'),
                            ),
                            DropdownMenuItem(
                              value: 7,
                              child: Text('7'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'مراحل المشروع',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<int>(
                          value: provider.criterion2,
                          onChanged: (value) {
                            provider.updateCriterion2(value ?? 0);
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 0,
                              child: Text('0'),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text('1'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text('2'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text('3'),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text('4'),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text('5'),
                            ),
                            DropdownMenuItem(
                              value: 6,
                              child: Text('6'),
                            ),
                            DropdownMenuItem(
                              value: 7,
                              child: Text('7'),
                            ),
                            DropdownMenuItem(
                              value: 8,
                              child: Text('8'),
                            ),
                            DropdownMenuItem(
                              value: 9,
                              child: Text('9'),
                            ),
                            DropdownMenuItem(
                              value: 10,
                              child: Text('10'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'العرض التقديمي',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<int>(
                          value: provider.criterion3,
                          onChanged: (value) {
                            provider.updateCriterion3(value ?? 0);
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 0,
                              child: Text('0'),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text('1'),
                            ),
                            DropdownMenuItem(
                              value: 2,
                              child: Text('2'),
                            ),
                            DropdownMenuItem(
                              value: 3,
                              child: Text('3'),
                            ),
                            DropdownMenuItem(
                              value: 4,
                              child: Text('4'),
                            ),
                            DropdownMenuItem(
                              value: 5,
                              child: Text('5'),
                            ),
                            DropdownMenuItem(
                              value: 6,
                              child: Text('6'),
                            ),
                            DropdownMenuItem(
                              value: 7,
                              child: Text('7'),
                            ),
                            DropdownMenuItem(
                              value: 8,
                              child: Text('8'),
                            ),
                            DropdownMenuItem(
                              value: 9,
                              child: Text('9'),
                            ),
                            DropdownMenuItem(
                              value: 10,
                              child: Text('10'),
                            ),
                            DropdownMenuItem(
                              value: 11,
                              child: Text('11'),
                            ),
                            DropdownMenuItem(
                              value: 12,
                              child: Text('12'),
                            ),
                            DropdownMenuItem(
                              value: 13,
                              child: Text('13'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('حفظ'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
      );
    });
  }
}

class AdminSuggestionList extends StatelessWidget {
  const AdminSuggestionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProjectProvider>(builder: (context, provider, _) {
      return FutureBuilder(
        future: provider.loadProjects(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return Expanded(
                  child: ListView(
                children: List.generate(provider.projectList.length, (index) {
                  final project = provider.projectList[index];
                  return Suggestion(
                    onPress: () {
                      // provider.setSelectedSuggestion(index);
                      // provider.onItemTapped(2);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AcceptSuggestionDialog();
                        },
                      ).then((value) async {
                        // Handle the result returned from the dialog
                        if (value == 'Done') {
                          // Handle the "Done" button press
                          await provider.changeSuggestionStatus(
                              project.mainSuggestion!, "a");
                        } else if (value == 'Cancel') {
                          // Handle the "Cancel" button press
                          await provider.changeSuggestionStatus(
                              project.mainSuggestion!, "r");
                        } else if (value == 'Waiting') {
                          // Handle the "Waiting" button press
                          await provider.changeSuggestionStatus(
                              project.mainSuggestion!, "w");
                        }
                      });
                    },
                    title: "${project.mainSuggestion?.title}",
                    content: "${project.mainSuggestion?.content}",
                    status: project.mainSuggestion?.status == null
                        ? "w"
                        : project.mainSuggestion!.status,
                    image: "${project.mainSuggestion?.image}",
                  );
                }),
              ));
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text("لا توجد عناصر"));
        },
      );
    });
  }
}

class AcceptSuggestionDialog extends StatelessWidget {
  const AcceptSuggestionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('الموافقة علي مقترح'),
      content: const Text(''),
      actions: [
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle green button press
              Navigator.pop(context, 'Done');
            },
            icon: const Icon(Icons.done, color: Colors.green),
            label: const Text('Done', style: TextStyle(color: Colors.green)),
          ),
        ),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle red button press
              Navigator.pop(context, 'Reject');
            },
            icon: const Icon(Icons.close, color: Colors.red),
            label: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle yellow button press
              Navigator.pop(context, 'Wait');
            },
            icon: const Icon(Icons.access_time, color: Colors.orange),
            label: const Text('Wait', style: TextStyle(color: Colors.orange)),
          ),
        ),
      ],
    );
  }
}
