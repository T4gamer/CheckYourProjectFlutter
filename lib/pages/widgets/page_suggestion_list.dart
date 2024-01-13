import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_manager/pages/widgets/widget_suggestion.dart';
import 'package:image_picker/image_picker.dart';
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
                        onPressed: () {
                          provider.setNewSuggestion(true);
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
                                provider.setSelectedSuggestion(index);
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
            : AddSuggestionPage(provider: provider),
      );
    });
  }
}

class AddSuggestionPage extends StatelessWidget {
  final provider;

  const AddSuggestionPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                      hintText: "تفاصيل المقترح يكمنك الكتابة هنا كما تشاء ...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
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
                          provider.createSuggestion();
                          provider.setNewSuggestion(false);
                        },
                        child: const Row(
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
                        onPressed: () {
                          provider.createSuggestion();
                          provider.setNewSuggestion(false);
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
      ),
    );
  }
}

class TeacherSuggestionList extends StatelessWidget {
  const TeacherSuggestionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProvider>(builder: (context, provider, _) {
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
                        onPressed: () {
                          provider.setNewSuggestion(true);
                        },
                        child: const Text(
                          "إضافة مقترح للمشروع",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        )),
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future: provider.suggestionList,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!.isNotEmpty
                                ? ListView(
                                    children: List.generate(
                                        snapshot.data!.length, (index) {
                                      final suggestion = snapshot.data![index];
                                      return Suggestion(
                                        onPress: () {
                                          provider.setSelectedSuggestion(index);
                                          provider.onItemTapped(2);
                                        },
                                        title: suggestion.title,
                                        content: suggestion.content,
                                        status: suggestion.status,
                                        image: suggestion.image,
                                      );
                                    }),
                                  )
                                : const Center(
                                    child: Text("لا توجد عناصر"),
                                  );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                  )
                ],
              )
            : AddSuggestionPage(provider: provider),
      );
    });
  }
}
