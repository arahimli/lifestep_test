import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:images_picker/images_picker.dart';
import 'package:lifestep/src/tools/common/validator.dart';
import 'package:lifestep/src/cubits/global/session/cubit.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';

import 'state.dart';

class ProfilePhotoCubit extends Cubit<ProfilePhotoState> {
  final UserRepository authRepo;
  final SessionCubit sessionCubit;
  FormValidator formValidator = FormValidator();



  initialize(){
    emit(
        state.copyWith(
          imageUrl: sessionCubit.currentUser!.image,
        )
    );
  }
  ProfilePhotoCubit({required this.authRepo, required this.sessionCubit}) : super(ProfilePhotoState()){
   initialize();
  }



  File? _croppedFile;
  Media? _scannedDocument;

  set croppedFile(File? value) {
    _croppedFile = value;
  }

  File? get croppedFile => _croppedFile;


  set scannedDocument(Media? value) {
    _scannedDocument = value;
  }

  Media? get scannedDocument => _scannedDocument;

  bool firstTapOnDocument = false;
  // File get scannedDocument => this._scannedDocument;

  set firstTapOnDocumentChange(value) {
    firstTapOnDocument = value;
  }


  pickImage() async {
    List<Media>? res = await ImagesPicker.openCamera(
      // pickType: PickType.video,
      pickType: PickType.image,
      quality: 0.8,
      maxSize: 800,
      // cropOpt: CropOption(
      //   aspectRatio: CropAspectRatio.wh16x9,
      // ),
      maxTime: 15,
    );
    // print(res);
    if (res != null) {
      // print(res[0].path);
      _scannedDocument = res[0];
      cropImagePicker();
      // _scannedDocument!.path;
    }
  }



  Future<void> cropImagePicker() async {
    //
    // final croppedFileItem = await ImageCropper().cropImage(
    //   aspectRatio: cropper.CropAspectRatio(ratioX: 1, ratioY: 1),
    //   sourcePath: _scannedDocument!.path,
    //   compressQuality: 20,
    //
    //   aspectRatioPresets: Platform.isAndroid
    //   ? [
    //     CropAspectRatioPreset.square,
    //   ]
    //   : [
    //       CropAspectRatioPreset.square,
    //   ],
    //   androidUiSettings: AndroidUiSettings(
    //       toolbarTitle:
    //       Utils.getStringWithoutContext("general__photo_crop__title"),
    //       statusBarColor: MainColors.mainColor,
    //       toolbarWidgetColor: MainColors.mainColor,
    //       toolbarColor: MainColors.white,
    //       activeControlsWidgetColor: Colors.blue,
    //       backgroundColor: Colors.black87,
    //       // backgroundColor: Colors.green,
    //       initAspectRatio: CropAspectRatioPreset.square,
    //       lockAspectRatio: true),
    //   iosUiSettings: IOSUiSettings(
    //
    //       minimumAspectRatio: 1.0,
    //       rectWidth: 300,
    //       rectHeight: 300,
    //       // aspectRatioPickerButtonHidden: true,
    //       // aspectRatioLockDimensionSwapEnabled: true,
    //
    //       title: Utils.getStringWithoutContext("general__photo_crop__title"),
    //       aspectRatioLockEnabled: true
    //   ),
    // );
    //
    // if (croppedFileItem != null) {
    //   croppedFile = croppedFileItem;
    // }else{
    //
    // }
    // print("*******croppedFile croppedFile croppedFile croppedFile croppedFile croppedFile ");
  }


}