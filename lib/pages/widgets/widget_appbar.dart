import 'package:flutter/material.dart';
import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:project_manager/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BaseAppBar extends StatelessWidget {
  final List<Widget> content;

  const BaseAppBar({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xff00577B),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(32),
              bottomLeft: Radius.circular(32))),
      child: Stack(
        children: [
          Image.asset("assets/appbar-back-shape.png"),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ModalRoute.of(context)?.settings.name != "/home"
                        ? IconButton(
                            onPressed: () {
                              Navigator.maybePop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                          )
                        : Container(),
                    const Spacer(),
                    ModalRoute.of(context)?.settings.name != "/settings"
                        ? IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/settings");
                            },
                            icon:
                                const Icon(Icons.settings, color: Colors.white),
                          )
                        : Container(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: content,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StudentAppBar extends StatelessWidget {
  const StudentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseAppBar(
      content: [
        Row(
          children: [
            Text("تاريخ التسليم: ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )),
            Text(
              "2024-1-1",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900),
            ),
          ],
        )
      ],
    );
  }
}

class StudentProgressionAppBar extends StatelessWidget {
  const StudentProgressionAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return BaseAppBar(content: [
        Row(
          children: [
            const Text("تاريخ التسليم: ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )),
            Text(
              "${provider.project?.deliveryDate}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                provider.project != null
                    ? "${(provider.project!.progression).toInt()}%"
                    : "0%",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  height: 170,
                  width: 170,
                  child: CircularCappedProgressIndicator(
                    value: provider.project != null
                        ? provider.project!.progression / 100
                        : 0.0,
                    backgroundColor: const Color(0xff196D8F),
                    color: Colors.white,
                    strokeWidth: 16,
                  )),
              // Positioned(
              //   left: 0,
              //   bottom: 0,
              //   child: IconButton(
              //     icon: const Icon(Icons.edit, size: 32, color: Colors.white),
              //     onPressed: () {},
              //   ),
              // ),
            ],
          ),
        ),
        const Text(
          "نسبة الانجاز",
          style: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
        )
      ]);
    });
  }
}
