import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpodgym/services/shared_prefrence_singleton.dart';
import 'package:riverpodgym/toast/show_toast.dart';
import 'package:riverpodgym/ui/home_view.dart';

import '../services/user_service.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController();
});

// final checkEmailProvider = FutureProvider.family((ref, String email) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.checkEmail(email: email);
// });

final checkAutoLogin = FutureProvider<bool>((ref) {
  return UserService.instance.initUser();
});

class AuthController extends StateNotifier<bool> {
  AuthController() : super(false);

  Future<void> loginFirebase(
      {required String email,
      required String pwd,
      required BuildContext context}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.trim(), password: pwd.trim())
        .then((value) async {
      SharedPreferencesSingleton().setAutoInfo(value.user!.uid, email, pwd);
      await UserService.instance.initUser();
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeView()));
      showToast('${UserService.instance.userModel.nickname}님 오늘도 오운완하세요!');
    }).catchError((e) {
      showToast('로그인 실패');
    });
  }

  Future<void> registerEmail(
      {required BuildContext context,
      required String email,
      required String pwd,
      required String nick,
      required List<XFile> imageList}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.trim(), password: pwd.trim())
        .then((value) {
      //uid 값을 키값으로 쓰기! value.user!.uid
      FirebaseStorage.instance
          .ref('user_profile_image/${email.trim()}')
          .putFile(File(imageList.first.path))
          .then((val) async {
        FirebaseFirestore.instance.collection('user').doc(value.user!.uid).set({
          'email': email.trim(),
          'nickname': nick.trim(),
          'image': await val.ref.getDownloadURL(),
          'uid': value.user!.uid,
        });
      });
      Navigator.pop(context);
      showToast('회원가입에 성공했습니다');
    }).catchError((e) {
      if (e.code == 'email-already-in-use') {
        showToast('이미 등록된 이메일 입니다');
      } else {
        showToast('회원가입에 실패했습니다');
      }
    });
  }

  Future<bool> checkEmail({required String email}) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();
      return query.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
