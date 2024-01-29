import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodgym/controller/auth_controller.dart';
import 'package:riverpodgym/ui/register_view.dart';

class LogInView extends ConsumerStatefulWidget {
  const LogInView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<LogInView> {
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  bool showPwd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(),
          const Text('로그인'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: emailCtl,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              obscureText: showPwd,
              controller: passwordCtl,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (showPwd == true) {
                          showPwd = false;
                        } else {
                          showPwd = true;
                        }
                      });
                    },
                    child: Icon(showPwd == true
                        ? Icons.visibility
                        : Icons.visibility_off)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    // context.push('/register');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterView()));
                  },
                  child: Container(
                    height: 44,
                    color: Colors.white,
                    child: const Center(child: Text('회원가입')),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              ref
                  .read(authControllerProvider.notifier)
                  .loginFirebase(email: emailCtl.text, pwd: passwordCtl.text,context: context);
              //provider.loginFirebase();
            },
            child: Container(
              width: 200,
              height: 60,
              color: Colors.red,
              child: const Center(child: Text('로그인')),
            ),
          ),
        ],
      ),
    );
  }
}
