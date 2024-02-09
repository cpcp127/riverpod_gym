
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpodgym/services/user_service.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/event_model.dart';

final eventsProvider = StateNotifierProvider<EventController,LinkedHashMap<DateTime,List<Event>>>((ref){
  return EventController();
});

final initialDataProvider = FutureProvider.family.autoDispose((ref,BuildContext context) async {
  await ref.read(eventsProvider.notifier).initialize(context);
});

class EventController extends StateNotifier<LinkedHashMap<DateTime, List<Event>>>{
  EventController():super(LinkedHashMap<DateTime, List<Event>>(equals: isSameDay));

  Future<void> initialize(BuildContext context) async {
    await getFireStore(DateTime.now(), context);
  }
  Future getFireStore(DateTime date, BuildContext context)async{
    var eventMap = super.state;
    //eventMap.clear();
    await FirebaseFirestore.instance
        .collection('운동기록')
        .doc(UserService.instance.userModel.uid)
        .collection(DateFormat('yyyy년MM월').format(date))
        .get().then((value){
      for (int i = 0; i < value.docs.length; i++) {
        eventMap.addAll({
          DateTime.utc(
              value.docs[i].data()['date'].toDate().year,
              value.docs[i].data()['date'].toDate().month,
              value.docs[i].data()['date'].toDate().day): [
            Event(
              value.docs[i].data()['date'].toDate(),
              value.docs[i].data()['title'],
              value.docs[i].data()['subtitle'],
              value.docs[i].data()['photoList'],
            )
          ]
        });
      }
      state = eventMap;

    });
  }
}