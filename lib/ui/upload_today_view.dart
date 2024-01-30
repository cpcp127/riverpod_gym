import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodgym/toast/show_toast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controller/image_provider.dart';

class UploadTodayView extends ConsumerStatefulWidget {
  const UploadTodayView({super.key});

  @override
  ConsumerState createState() => _UploadTodayViewState();
}

class _UploadTodayViewState extends ConsumerState<UploadTodayView> {
  PageController pageController = PageController();
  int pageIndex = 0;
  List<String> selectWorkList = [];
  List<String> imageList = [];
  String imageRatio = '1:1';

  @override
  void dispose() {
    pageController.dispose();
    pageIndex = 0;
    selectWorkList.clear();
    imageList.clear();
    imageRatio = '1:1';

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(imageProvider);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            bottomSheet: pageIndex == 0 ? selectWorkBtn() : Row(
              children: [
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        pageIndex=0;
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
                ? selectWorkStep()
                : descriptionStep(images, context),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView descriptionStep(images, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          imageRatioBtn(),
          GestureDetector(
            onTap: () async {
              ref.read(imageProvider.notifier).getMultiImage();
            },
            child: images.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 2)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.photo_camera,
                            size: 25,
                          ),
                          SizedBox(height: 5),
                          Text('5장 이하로 올려주세요')
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AspectRatio(
                      aspectRatio: imageRatio == '1:1' ? 1 / 1 : 4 / 5,
                      child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: pageController,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.withOpacity(0.2),
                                    image: DecorationImage(
                                        image: FileImage(
                                          File(images[index].path),
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                              width: 44,
                                              height: 44,
                                              color: Colors.transparent,
                                              child: const Icon(
                                                Icons.auto_fix_normal_outlined,
                                                size: 30,
                                              )),
                                          onTap: () async {
                                            //await provider.cropImage(index);
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          child: Container(
                                              width: 44,
                                              height: 44,
                                              color: Colors.transparent,
                                              child: const Icon(
                                                Icons.highlight_remove_outlined,
                                                size: 30,
                                              )),
                                          onTap: () async {
                                            print(index);
                                            print(images.length - 1);
                                            await ref
                                                .read(imageProvider.notifier)
                                                .delImage(images[index]);
                                            setState(() {
                                              if (images.length == 1) {
                                              } else if (index ==
                                                  images.length - 1) {
                                                pageController
                                                    .jumpToPage(index - 1);
                                              } else {
                                                pageController
                                                    .jumpToPage(index);
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          images.isEmpty?Container():Container(
            width: 220,
            alignment: Alignment.center,
            child: SmoothPageIndicator(
                controller: pageController,
                count: images.length,
                effect: const ScrollingDotsEffect(
                  activeDotColor: Colors.indigoAccent,
                  activeStrokeWidth: 10,
                  activeDotScale: 1.7,
                  maxVisibleDots: 5,
                  radius: 16,
                  spacing: 10,
                  dotHeight: 16,
                  dotWidth: 16,
                )),
          ),
        ],
      ),
    );
  }

  Row imageRatioBtn() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                imageRatio = '1:1';
              });
            },
            child: Container(
              height: 50,
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Icon(Icons.square_outlined,
                        color:
                            imageRatio == '1:1' ? Colors.black : Colors.grey),
                    Text(
                      '1:1',
                      style: TextStyle(
                          color:
                              imageRatio == '1:1' ? Colors.black : Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                imageRatio = '4:5';
              });
            },
            child: Container(
              height: 50,
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Transform.rotate(
                        angle: 3.14 / 2,
                        child: Icon(Icons.rectangle_outlined,
                            color: imageRatio == '4:5'
                                ? Colors.black
                                : Colors.grey)),
                    Text(
                      '4:5',
                      style: TextStyle(
                          color:
                              imageRatio == '4:5' ? Colors.black : Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column selectWorkStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildWorkBox(
              '등',
              'back',
            ),
            const SizedBox(width: 20),
            buildWorkBox(
              '가슴',
              'chest',
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildWorkBox(
              '하체',
              'leg',
            ),
            const SizedBox(width: 20),
            buildWorkBox(
              '어깨',
              'shoulder',
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildWorkBox(
              '팔',
              'arm',
            ),
            const SizedBox(width: 20),
            buildWorkBox(
              '유산소',
              'running',
            ),
          ],
        )
      ],
    );
  }

  Row selectWorkBtn() {
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
              if (selectWorkList.isEmpty) {
                showToast('운동을 선택해주세요');
              } else {
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

  Column buildWorkBox(String workKr, String work) {
    return Column(
      children: [
        Text(workKr),
        GestureDetector(
          onTap: () {
            setState(() {
              if (selectWorkList.contains(work)) {
                selectWorkList.remove(work);
              } else {
                selectWorkList.add(work);
              }
            });
          },
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: selectWorkList.contains(work)
                      ? Colors.black
                      : const Color(0xffb9b9b9),
                  width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(selectWorkList.contains(work)
                        ? 'assets/images/${work}_black.png'
                        : 'assets/images/${work}_gray.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
