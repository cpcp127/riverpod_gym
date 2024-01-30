import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadTodayView extends ConsumerStatefulWidget {
  const UploadTodayView({super.key});

  @override
  ConsumerState createState() => _UploadTodayViewState();
}

class _UploadTodayViewState extends ConsumerState<UploadTodayView> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(

          ),
        ),
      ),
    );
  }
}
