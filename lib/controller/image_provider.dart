import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_picker_service.dart';

final imageProvider = StateNotifierProvider<ImageState, List<XFile>>((ref) {
  return ImageState();
});

class ImageState extends StateNotifier<List<XFile>> {
  ImageState() : super(<XFile>[]);
  final ImagePickerService picker = ImagePickerService();

  // @override
  // set state(List<XFile> value) {
  //   super.state = value;
  // }

  delImage(XFile image) {
    var list = [...super.state];
    list.remove(image);
    state = list;
  }

  void addImage(List<XFile> value) {
    var list = [...super.state];
    if (list.isEmpty) {
      state = value;
    } else {
      list.addAll(value);
      list.toSet().toList();
      state = list;
    }
    if (super.state.length > 5) {
      state = super.state.sublist(0, 5);
    }
  }

  Future getMultiImage() async {
    picker.pickMultiImage().then((value) {
      addImage(value);
    }).catchError((onError) {});
  }

  Future getSingleImage() async {
    picker.pickSingleImage().then((value) {
      state.clear();
      addImage([value!]);
    }).catchError((onError) {});
  }
}
