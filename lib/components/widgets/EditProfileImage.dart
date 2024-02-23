import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/ImageDataModel.dart';
import '../constants/AppColors.dart';
import '../constants/AppFonts.dart';
import '../constants/AppIcons.dart';
import '../constants/AppStrings.dart';
import '../constants/TextStyles.dart';
import '../constants/constants.dart';
import '../coreComponents/AppBSheet.dart';
import '../coreComponents/ImageView.dart';
import '../coreComponents/TapWidget.dart';
import '../coreComponents/TextView.dart';

class EditProfileImage extends StatelessWidget {
  final double size;
  final ImageDataModel imageData;
  final Function(ImageDataModel)? onChange;
  final bool isEditable;
  final EdgeInsets? margin;
  final String? error;

  const EditProfileImage({super.key,
    required this.size, required this.imageData,  this.onChange,  this.isEditable = true, this.margin,  this.error = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Column(
        children: [
          Stack(
            children: [
              ImageView(
                url: imageData.type == ImageType.network ?
                    imageData.network! :
                    imageData.type == ImageType.file ?
                    imageData.file! :
                    AppIcons.dummyProfile,
                size: size,
                radius: size / 2,
                fit: BoxFit.cover,
                imageType: imageData.type,
              ),
              Visibility(
                visible: isEditable,
                child: Positioned(
                  right: 3,
                    bottom: 3,
                    child: ImageEditButton(size: AppFonts.s40,
                      onTap: (){
                      appBSheet(context, EditImageBSheetView(onItemTap: (source)async{
                        Navigator.pop(context);
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: source);
                        if(image != null){
                          ImageDataModel imageDataTemp = imageData;
                          imageDataTemp.file = image.path;
                          imageDataTemp.type = ImageType.file;
                          if(onChange != null){
                            onChange!(imageDataTemp);
                          }
                        }
                      },
                      ));
                      },
                    )
                ),
              )
            ],
          ),
          Visibility(
            visible: error != null && error!.isNotEmpty,
              child: TextView(text: error ?? '',textStyle: TextStyles.regular14Error,
                margin: const EdgeInsets.only(top: AppFonts.s7),
              )
          )
        ],
      ),
    );
  }
}

class ImageEditButton extends StatelessWidget {
  final double size;
  final Function()? onTap;
  const ImageEditButton({super.key, required this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(AppFonts.s10),
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(size / 2),
              border: Border.all(color: AppColors.primaryColor,width: 2)
          ),
          child: const ImageView(
            url: AppIcons.camera,
          ),
        ),
        Positioned.fill(child: TapWidget(onTap: onTap,))
      ],
    );
  }
}


class EditImageBSheetView extends StatelessWidget {
  final Function(ImageSource) onItemTap;
  const EditImageBSheetView({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppFonts.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const TextView(text: AppStrings.choosePhoto, textStyle: TextStyles.semiBold16Black,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppFonts.s20),
            child: Row(
              children: [
                ItemTile(onTap: ()=> onItemTap(ImageSource.camera),
                    image: AppIcons.camera, name: AppStrings.camera),
                const SizedBox(width: AppFonts.s20,),
                ItemTile(onTap: ()=> onItemTap(ImageSource.gallery),
                    image: AppIcons.gallery, name: AppStrings.gallery),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final String image;
  final String name;
  final Function()? onTap;
  const ItemTile({super.key, required this.image, required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            ImageView(
              url: image, size: AppFonts.s40,margin: const EdgeInsets.only(bottom: 5),),
            TextView(
              text: name, textStyle: TextStyles.regular14Black,),
          ],
        ),
        Positioned.fill(child: TapWidget(onTap: onTap,))
      ],
    );
  }
}



