import 'package:flutter/material.dart';
import 'package:project_manager/pages/widgets/widget_appbar.dart';

class AdminBasePage extends StatelessWidget {
  final Widget child;
  final List<Widget> appBarWidgets;

  const AdminBasePage(
      {super.key, required this.child, this.appBarWidgets = const []});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Column(
            children: [
              BaseAppBar(content: appBarWidgets),
              child,
            ],
          ),
        ));
  }
}
