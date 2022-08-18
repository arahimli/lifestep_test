import 'dart:io';

import 'package:images_picker/images_picker.dart';
import 'package:lifestep/src/ui/user/form-submission-status.dart';

class ProfilePhotoState {
  final File? croppedFile;
  final Media? scannedDocument;
  final String? imageUrl;
  // bool get isValidPhone => phone != null && phone!.length > 3;


  final FormSubmissionStatus formStatus;

  ProfilePhotoState({
    this.croppedFile,
    this.scannedDocument,
    this.imageUrl,
    this.formStatus = const InitialFormStatus(),
  });

  ProfilePhotoState copyWith({

    File? croppedFile,
    Media? scannedDocument,
    String? imageUrl,
    FormSubmissionStatus? formStatus,
  }) {
    return ProfilePhotoState(
      croppedFile: croppedFile ?? this.croppedFile,
      scannedDocument: scannedDocument ?? this.scannedDocument,
      imageUrl: imageUrl ?? this.imageUrl,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}