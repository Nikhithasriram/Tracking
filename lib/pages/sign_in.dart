import 'package:flutter/material.dart';
import 'package:tracking_app/services/auth.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tracking_app/utils/loading.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            backgroundColor: Colors.blueGrey.shade50,
            body: const Center(child: Loading()))
        : Scaffold(
            backgroundColor: const Color.fromRGBO(145, 158, 202, 1),
            body: Center(
              child: Column(
                children: [
                  Image.asset('assets/pd.png'),
                  const Spacer(
                    flex: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          " PD Tracker",
                          style: TextStyle(fontSize: 36),
                        ),
                        const Text(
                          "Welcome !",
                          style: TextStyle(fontSize: 28),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "Login Or Sign Up",
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onTap: () async {
                                setState(() {
                                  loading = true;
                                });
                                await AuthService()
                                    .signInwithGoogle(context: context);
                                setState(() {
                                  loading = false;
                                });
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width - 70,
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black38, width: 1.5),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/google_small.png'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text("Login with google"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        )
                        // const Spacer(
                        //   flex: 3,
                        // ),
                      ],
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          );
  }
}
