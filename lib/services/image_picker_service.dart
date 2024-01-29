import 'package:image_picker/image_picker.dart';

class ImagePickerService{
  static final ImagePickerService _imagePickerService = ImagePickerService._internal();

  factory ImagePickerService(){
    return _imagePickerService;
  }
  ImagePickerService._internal();

  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>> pickMultiImage() async{
    try{
      final pickedFile = await _picker.pickMultiImage();
      return pickedFile;
    } catch(e){
      return [];
    }
  }

  Future<XFile?> pickSingleImage() async{
    try{
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      return pickedFile;
    }catch(e){
      return null;
    }
  }
}