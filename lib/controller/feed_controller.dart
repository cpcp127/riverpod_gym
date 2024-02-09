

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../services/user_service.dart';
import 'image_provider.dart';

class FeedController extends ChangeNotifier{


  Future<void> uploadTodayWork({imageList, title, subtitle, ratio,uploadArticle}) async{
    List<String> imageUrlList = [];
    for (int i = 0; i < imageList.length; i++) {
      await FirebaseStorage.instance
          .ref(
          '${UserService.instance.userModel.uid} ${DateFormat('yyyy년MM월dd일').format(DateTime.now())}/${UserService.instance.userModel.uid} ${DateFormat('yyyy년MM월dd일').format(DateTime.now())} $i')
          .putFile(File(imageList[i]))
          .then((val) async {
        imageUrlList.add(await val.ref.getDownloadURL());
      });
    }
    //storage에 사진 저장후 사진주소를 받아서 Firestore에 저장
    await FirebaseFirestore.instance
        .collection('운동기록')
        .doc(UserService.instance.userModel.uid)
        .collection(DateFormat('yyyy년MM월').format(DateTime.now()))
        .doc(DateFormat('yyyy년MM월dd일').format(DateTime.now()))
        .set({
      'date': DateTime.now().toLocal(),
      'datetime': (DateFormat('yyyy년MM월dd일').format(DateTime.now())),
      'title': title,
      'subtitle': subtitle,
      'photoList': imageUrlList,
      'ratio': ratio,
    }).then((value) async {
      if (uploadArticle == true) {
        await FirebaseFirestore.instance.collection('article').add({
          'upload_user': {
            'id': UserService.instance.userModel.uid.trim(),
            'nickname': UserService.instance.userModel.nickname
          },
          'upload_date': DateTime.now().toLocal(),
          'title': title,
          'subtitle': subtitle,
          'photoList': imageUrlList,
          'ratio': ratio,
          'like': {
            'count': 0,
            'people': [],
          },
          'comment':0,
        });
      } else {}
    });


  }
}