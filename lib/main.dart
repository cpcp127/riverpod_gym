import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:riverpodgym/controller/auth_controller.dart';
import 'package:riverpodgym/ui/home_view.dart';
import 'package:riverpodgym/ui/login_view.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  timeago.setLocaleMessages('kr', KrCustomMessages());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          splashColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.white,
          //fontFamily: 'Agro',
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              elevation: 1,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.blue.withOpacity(0.3),
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true)),
      home: ref.watch(checkAutoLogin).when(
          data: (autoLogin) {
            return autoLogin == null ? const LogInView() : const HomeView();
          },
          error: (error, stackTrace) {
            return Container();
          },
          loading: () => Container()),
    );
  }
}

class KrCustomMessages implements LookupMessages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => '';

  @override
  String suffixFromNow() => '';

  @override
  String lessThanOneMinute(int seconds) => '방금 전';

  @override
  String aboutAMinute(int minutes) => '${minutes}분 전';

  @override
  String minutes(int minutes) => '${minutes}분 전';

  @override
  String aboutAnHour(int minutes) => '1시간 전';

  @override
  String hours(int hours) => '${hours}시간 전';

  @override
  String aDay(int hours) => '${hours}시간 전';

  @override
  String days(int days) => '${days}일 전';

  @override
  String aboutAMonth(int days) => '${days}일 전';

  @override
  String months(int months) => '${months}개월 전';

  @override
  String aboutAYear(int year) => '${year}년 전';

  @override
  String years(int years) => '${years}년 전';

  @override
  String wordSeparator() => ' ';
}
