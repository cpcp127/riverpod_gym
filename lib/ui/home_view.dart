import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodgym/controller/calendar_controller.dart';
import 'package:riverpodgym/controller/event_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int homePageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final focusedDate = ref.watch(focusedDateProvider);
    final events = ref.watch(eventsProvider);
    final initialDataLoaded = ref.watch(initialDataProvider(context));
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: '일지'),
          BottomNavigationBarItem(icon: Icon(Icons.area_chart), label: '차트'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dangerous_outlined), label: '준비중'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '계정'),
        ],
        onTap: (index) {
          setState(() {
            homePageIndex = index;
          });
        },
        currentIndex: homePageIndex,
      ),
      body: Column(
        children: [
          initialDataLoaded.when(data: (data) {
            return TableCalendar(
              locale: 'ko_KR',
              focusedDay: focusedDate,
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
                return isSameDay(selectedDate, day);
              },
              onPageChanged: (DateTime date) async {
                ref.read(eventsProvider.notifier).getFireStore(date, context);
                ref.read(focusedDateProvider.notifier).setSelectedDate(date);
                //provider.changePage(date, context);
              },
              onDaySelected: (selectDay, focusDay) {
                ref.read(selectedDateProvider.notifier).setSelectedDate(selectDay);
              },
              eventLoader: (day) {
                ref.read(eventsProvider.notifier).getFireStore(day, context);
                return events[day] ?? [];
              },
            );
          }, error: (e, s) {
            return const Center(child: Text('에러!'));
          }, loading: () {
            return const Center(child: Text('로딩중'));
          })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
