
import 'package:expense_calc/components/constants/constants.dart';
import 'package:image_picker/image_picker.dart';

class Utils{
  static Future<XFile?> pickImage(ImagePickType type) async{
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: type == ImagePickType.camera ? ImageSource.camera : ImageSource.gallery);
  }
}
