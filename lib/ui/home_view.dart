import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodgym/controller/calendar_controller.dart';
import 'package:riverpodgym/controller/event_provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/event_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int homePageIndex = 0;


  @override
  Widget build(BuildContext context) {
    DateTime focusedDay = ref.watch(focusedDayProvider.notifier).state;
    DateTime selectedDay = ref.watch(selectedDayProvider.notifier).state;
    LinkedHashMap<DateTime, List<Event>> events = ref.watch(eventsProvider.notifier).state;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: '일지'),
          BottomNavigationBarItem(
              icon: Icon(Icons.area_chart), label: '차트'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dangerous_outlined), label: '준비중'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: '계정'),
        ],
        onTap: (index) {
         setState(() {
           homePageIndex=index;
         });
        },
        currentIndex: homePageIndex,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko_KR',
            focusedDay: focusedDay,
            firstDay: DateTime.utc(2021, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                )),
            headerStyle: const HeaderStyle(
                titleCentered: true, formatButtonVisible: false),
            selectedDayPredicate: (day) {
              return isSameDay(ref.watch(selectedDayProvider.notifier).state, day);
            },
            onPageChanged: (DateTime date) async {
              //provider.changePage(date, context);
            },
            onDaySelected: (selectDay, focusDay) {
              ref.watch(selectedDayProvider.notifier).selectDay(selectDay);
              ref.watch(focusedDayProvider.notifier).selectDay(focusDay);
              setState(() {

              });
              // setState(() {
              //
              // });
            },
            eventLoader: (day) {
              return events[day]??[];
            },
          ),
          Text(
            ref.watch(selectedDayProvider.notifier).state.toString(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      ref.watch(eventsProvider.notifier).getFireStore(DateTime.now(), context);
    });

  }
}
