import 'package:flutter/material.dart';
import 'package:project_manager/pages/widgets/widget_dialog.dart';
import 'package:project_manager/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../services/login_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Call the refresh login service when the widget is launched
    refreshLogin();
  }

  Future<void> refreshLogin() async {
    // Simulate an asynchronous operation to check if the user is logged in
    await Future.delayed(const Duration(seconds: 2));

    // Assuming the RefreshLoginService returns a boolean indicating the login status
    // final loginStatus = await Provider.of<UserProvider>(context,listen: false).;
    final loginStatus = await refreshLoginService();

    setState(() {
      isLoggedIn = loginStatus;
    });

    // Navigate to the home route if the user is logged in
    if (isLoggedIn) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/app-login-upper-background.png",
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child:
                    Consumer<UserProvider>(builder: (context, provider, child) {
                  return Form(
                    key: provider.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Row(
                            children: [
                              Text(
                                "تسجيل الدخول",
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // provider.loginError
                        //     ? const Padding(
                        //         padding: EdgeInsets.symmetric(
                        //             horizontal: 32, vertical: 4),
                        //         child: Row(
                        //           children: [
                        //             Text(
                        //               "إسم المستخدم أو كلمة المرور غير صحيحة",
                        //               style: TextStyle(
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.bold,
                        //                   color: Colors.redAccent),
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     : Container(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 32),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                prefixIcon:
                                    Icon(Icons.alternate_email_outlined),
                                hintText: "البريد الإلكتروني",
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 3))),
                            validator: provider.emailValidator,
                            onChanged: (value) {
                              provider.emailController.text = value.trim();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 32),
                          child:
                              Stack(alignment: Alignment.centerLeft, children: [
                            TextFormField(
                              obscureText: !provider.isVisible,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.password),
                                  hintText: "كلمة المرور",
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  // errorText: "يرجي ادخال كلمة مرور صحيحة",
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 3))),
                              validator: provider.passwordValidator,
                              onChanged: (value) {
                                provider.passwordController.text = value.trim();
                              },
                            ),
                            IconButton(
                                onPressed: () {
                                  provider.isVisible = !provider.isVisible;
                                  setState(() {});
                                },
                                icon: Icon(provider.isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              provider.isLoginLoading == false
                                  ? SizedBox(
                                      height: 43,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          provider.setLoginLoading(true);
                                          setState(() {});

                                          try {
                                            await provider.loginUser();
                                            // Future.delayed(
                                            //     const Duration(seconds: 3));
                                            if (provider.loggedIn) {
                                              Navigator.pushNamed(
                                                  context, "/home");
                                              setState(() {});
                                            }
                                          } catch (error) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return LoginErrorDialog(
                                                    errorMessage:
                                                        error.toString(),
                                                  );
                                                });
                                            setState(() {});
                                          }
                                          provider.setLoginLoading(false);
                                          if(!provider.loggedIn){
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const LoginErrorDialog(
                                                    errorMessage:
                                                    "أسم المستخدم او كلمة المرور خاطئة",
                                                  );
                                                });
                                          }
                                          setState(() {});
                                        },
                                        style: const ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Color(0xff00577B))),
                                        child: const Text(
                                          "تسجيل الدخول",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 64),
                                      child: CircularProgressIndicator(),
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset("assets/app-login-lower-background.png"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
