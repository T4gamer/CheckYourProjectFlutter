import 'package:flutter/material.dart';
import 'package:gradefy/models/requirement_list.dart';

class RequirementEditDialog extends StatefulWidget {
  final Function(Requirement) onDonePressed;

  const RequirementEditDialog({super.key, required this.onDonePressed});

  @override
  _RequirementEditDialogState createState() => _RequirementEditDialogState();
}

class _RequirementEditDialogState extends State<RequirementEditDialog> {
  late TextEditingController _textEditingController;
  late bool _status;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _status = false;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text("أضف متطلب جديد"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(hintText: 'محتوي المتطلب'),
              onSubmitted: (value) {
                String value = _textEditingController.text;
                String status = "i";
                if (_status) {
                  status = "c";
                }
                final Requirement requirement = Requirement(
                    name: value, suggestion: 0, id: 0, status: status);
                widget.onDonePressed(
                    requirement); // Call the function when Done is pressed
              },
            ),
            Row(
              children: [
                const Text("أنجز"),
                Checkbox(
                    value: _status,
                    onChanged: (val) {
                      if (val != null) {
                        _status = val;
                      } else {
                        _status = false;
                      }
                      setState(() {});
                    }),
                const Text("لم يتم"),
                Checkbox(
                    value: !_status,
                    onChanged: (val) {
                      if (val != null) {
                        _status = !val;
                      }
                      setState(() {});
                    }),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('حفظ'),
            onPressed: () {
              String value = _textEditingController.text;
              String status = "i";
              if (_status) {
                status = "c";
              }
              final Requirement requirement = Requirement(
                  name: value, suggestion: 0, id: 0, status: status);
              widget.onDonePressed(
                  requirement); // Call the function when Done is pressed
            },
          ),
        ],
      ),
    );
  }
}

class RequirementDialog extends StatefulWidget {
  final Function(String) onDonePressed;

  const RequirementDialog({super.key, required this.onDonePressed});

  @override
  _RequirementDialogState createState() => _RequirementDialogState();
}

class _RequirementDialogState extends State<RequirementDialog> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("أضف متطلب جديد"),
      content: TextField(
        controller: _textEditingController,
        decoration: const InputDecoration(hintText: 'محتوي المتطلب'),
        onSubmitted: (value) {
          widget.onDonePressed(value); // Call the function when Done is pressed
        },
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('إلغاء'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('حفظ'),
          onPressed: () {
            String value = _textEditingController.text;
            widget
                .onDonePressed(value); // Call the function when Done is pressed
          },
        ),
      ],
    );
  }
}

class LoginErrorDialog extends StatelessWidget {
  final String errorMessage;

  const LoginErrorDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('خطأ في تسجيل الدخول'),
      content: Text(errorMessage),
      actions: [
        TextButton(
          child: const Text('حسناً'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class SaveConfirmationDialog extends StatelessWidget {
  final VoidCallback onPress;

  const SaveConfirmationDialog({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('حفظ الاقتراح'),
      content: const Text('هل أنت متأكد أنك تريد الحفظ؟'),
      actions: [
        TextButton(
          child: const Text('نعم'),
          onPressed: () {
            onPress();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('لا'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
