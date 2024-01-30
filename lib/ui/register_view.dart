import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodgym/controller/auth_controller.dart';
import 'package:riverpodgym/controller/image_provider.dart';
import 'package:riverpodgym/services/validator.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final emailCtl = TextEditingController();
  final passwordCtl = TextEditingController();
  final checkCtl = TextEditingController();
  final nickCtl = TextEditingController();

  int pageIndex = 0;
  bool emailDuplicate = false;
  FocusNode emailNode = FocusNode();
  FocusNode pwdNode = FocusNode();
  FocusNode pwdCheckNode = FocusNode();
  FocusNode nickNode = FocusNode();

  GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> pwdFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> pwdCheckFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> nickFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(imageProvider);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          bottomSheet: pageIndex == 0
              ? emailTabBtn()
              : pageIndex == 1
                  ? pwdTabBtn()
                  : Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                pageIndex = 1;
                              });
                            },
                            child: Container(
                              height: 50,
                              // width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async {
                              if (images.isNotEmpty ||
                                  nickFormKey.currentState!.validate()) {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .registerEmail(
                                        context: context,
                                        email: emailCtl.text,
                                        pwd: passwordCtl.text,
                                        nick: nickCtl.text,
                                        imageList: images);
                              }
                            },
                            child: Container(
                              height: 50,
                              // width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          body: pageIndex == 0
              ? emailTab()
              : pageIndex == 1
                  ? pwdTab()
                  : infoTab(images)),
    );
  }

  Column infoTab( images) {
    return Column(
      children: [
        Text('닉네임'),
        SizedBox(height: 16),
        Form(
          key: nickFormKey,
          child: TextFormField(
            controller: nickCtl,
            focusNode: nickNode,
            autovalidateMode: AutovalidateMode.disabled,
            validator: (nick) => Validator().validateNick(nick!),
            maxLines: 1,
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 16),
          child: Row(
            children: [
              Text('프로필 사진'),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            ref.read(imageProvider.notifier).getSingleImage();
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: images.isEmpty
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: Colors.black),
                  )
                : BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: FileImage(
                          File(images.first.path),
                        ),
                        fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
    );
  }

  Row pwdTabBtn() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 0;
              });
            },
            child: Container(
              height: 50,
              // width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () async {
              if (pwdFormKey.currentState!.validate() == true ||
                  pwdCheckFormKey.currentState!.validate() == true) {
                setState(() {
                  pageIndex = 2;
                });
              }
            },
            child: Container(
              height: 50,
              // width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column pwdTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('비밀번호'),
        SizedBox(height: 16),
        Form(
          key: pwdFormKey,
          child: TextFormField(
            controller: passwordCtl,
            focusNode: pwdNode,
            autovalidateMode: AutovalidateMode.disabled,
            validator: (pwd) => Validator().validatePwd(pwd!),
            obscureText: true,
            maxLines: 1,
          ),
        ),
        Text('비밀번호 확인'),
        SizedBox(height: 16),
        Form(
          key: pwdCheckFormKey,
          child: TextFormField(
            controller: checkCtl,
            focusNode: pwdCheckNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (str) {
              if (str!.isEmpty) {
                return '비밀번호가 일치하지 않습니다';
              } else if (str != passwordCtl.text) {
                return '비밀번호가 일치하지 않습니다';
              } else {
                return null;
              }
            },
            obscureText: true,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Row emailTabBtn() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 50,
              // width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () async {
              await ref
                  .watch(authControllerProvider.notifier)
                  .checkEmail(email: emailCtl.text)
                  .then((value) {
                if (value == false) {
                  print('중복아님');
                  setState(() {
                    emailDuplicate = true;
                    emailFormKey.currentState!.validate();
                    //pageIndex=1;
                  });
                } else {
                  print('중복');
                  setState(() {
                    emailDuplicate = false;
                    emailFormKey.currentState!.validate();
                  });
                }
              });
              if (emailFormKey.currentState!.validate() == true) {
                setState(() {
                  pageIndex = 1;
                });
              }
            },
            child: Container(
              height: 50,
              // width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column emailTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('이메일'),
        SizedBox(height: 16),
        Form(
          key: emailFormKey,
          child: TextFormField(
            controller: emailCtl,
            focusNode: emailNode,
            autovalidateMode: AutovalidateMode.disabled,
            validator: (str) => Validator().validateEmail(str!, emailDuplicate),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    emailNode.addListener(() async {
      if (!emailNode.hasFocus) {
        await ref
            .watch(authControllerProvider.notifier)
            .checkEmail(email: emailCtl.text)
            .then((value) {
          if (value == false) {
            print('중복아님');
            setState(() {
              emailDuplicate = true;
              emailFormKey.currentState!.validate();
              //pageIndex=1;
            });
          } else {
            print('중복');
            setState(() {
              emailDuplicate = false;
              emailFormKey.currentState!.validate();
            });
          }
        });
        //emailFormKey.currentState!.validate();
      }
    });
    pwdNode.addListener(() {
      if (!pwdNode.hasFocus) {
        pwdFormKey.currentState!.validate();
      }
    });
    pwdCheckNode.addListener(() {
      if (!pwdCheckNode.hasFocus) {
        pwdCheckFormKey.currentState!.validate();
      }
    });
    nickNode.addListener(() async {
      if (!nickNode.hasFocus) {
        nickFormKey.currentState!.validate();
      }
    });
    super.initState();
  }
}
