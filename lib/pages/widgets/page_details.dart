import 'package:flutter/material.dart';
import 'package:project_manager/pages/widgets/widget_dialog.dart';
import 'package:project_manager/pages/widgets/widget_requirements.dart';
import 'package:project_manager/providers/student_provider.dart';
import 'package:provider/provider.dart';

import '../../models/requirement_list.dart';

class StudentDetails extends StatelessWidget {
  const StudentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(builder: (context, provider, child) {
      return Expanded(
        child: provider.selectedSuggestion != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                              constraints: const BoxConstraints(maxHeight: 165),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.network(
                                    provider.selectedSuggestion != null
                                        ? provider.selectedSuggestion!.image
                                        : ""),
                              )),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.grey.withOpacity(0.8)),
                                elevation: MaterialStateProperty.all(2)),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            provider.selectedSuggestion!.title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.grey.withOpacity(0.8)),
                                elevation: MaterialStateProperty.all(2)),
                            onPressed: () {
                              provider.deleteSuggestion();
                            },
                            icon: const Icon(
                              Icons.delete,
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Container(
                        constraints:
                            const BoxConstraints(maxHeight: 100, minHeight: 50),
                        child: SingleChildScrollView(
                          child: Text(
                            provider.selectedSuggestion!.content,
                            maxLines: null,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          "متطلبات المشروع",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ListView(
                            children: List.generate(
                                provider.requirementList.length, (index) {
                              final item = provider.requirementList[index];
                              return RequirementWidget(
                                title: item.name,
                                onDelete: () {
                                  provider.deleteRequirement(index);
                                },
                                onEdit: () {
                                  showEditRequirementDialog(context,
                                      (id, requirement) {
                                    provider.editRequirement(id, requirement);
                                  }, item.id);
                                },
                                status: item.status,
                              );
                            }),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.grey.withOpacity(0.8)),
                                    elevation: MaterialStateProperty.all(2)),
                                onPressed: () {
                                  showAddRequirementDialog(
                                      context, provider.createRequirement);
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  size: 40,
                                  color: Color(0xff196D8F),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("لم يتم اختيار مقترح"),
                ),
              ),
      );
    });
  }

  void showAddRequirementDialog(
      BuildContext context, void Function(String) add) async {
    String? enteredText = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return RequirementDialog(
          onDonePressed: (value) {
            Navigator.of(context).pop(value);
          },
        );
      },
    );

    if (enteredText != null) {
      if (enteredText.isNotEmpty) {
        add(enteredText);
      }
    }
  }

  void showEditRequirementDialog(BuildContext context,
      void Function(int, Requirement) edit, int id) async {
    Requirement? requirement = await showDialog<Requirement>(
      context: context,
      builder: (BuildContext context) {
        return RequirementEditDialog(
          onDonePressed: (value) {
            Navigator.of(context).pop(value);
          },
        );
      },
    );
    if (requirement != null) {
      edit(id, requirement);
    }
  }
}
