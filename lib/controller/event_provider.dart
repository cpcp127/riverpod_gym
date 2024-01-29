
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../model/event_model.dart';
import '../services/user_service.dart';

final eventsProvider = StateNotifierProvider<EventController,LinkedHashMap<DateTime,List<Event>>>((ref){
  return EventController();
});

class EventController extends StateNotifier<LinkedHashMap<DateTime, List<Event>>>{
  EventController():super(LinkedHashMap<DateTime, List<Event>>());

  @override
  set state(LinkedHashMap<DateTime, List<Event>> value){
    super.state = value;
  }

  Future getFireStore(DateTime date, BuildContext context)async{
    var eventMap = super.state;
    await FirebaseFirestore.instance
        .collection('운동기록')
        .doc(('KKuA5ON6HDSVLEJglHx3SCKY7SO2'))
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
      state = super.state;
    });
  }
}