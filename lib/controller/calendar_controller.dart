

import 'package:flutter_riverpod/flutter_riverpod.dart';

final focusedDayProvider = StateNotifierProvider((ref){
  return CalendarController();
});


final selectedDayProvider = StateNotifierProvider((ref){
  return CalendarController();
});



class CalendarController extends StateNotifier<DateTime>{
  CalendarController():super(DateTime.now());

  void selectDay(DateTime dateTime){
    state = dateTime;
  }
}