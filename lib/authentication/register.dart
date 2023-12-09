import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/utils/DeviceUtils.dart';
import 'package:user_app/widgets/custom_text_field.dart';
import 'package:user_app/widgets/error_Dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:user_app/mainScreens/home_screen.dart';

import '../global/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String sellerImageUrl = "";

  // Variable to hold the selected image file
  PlatformFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: _DIMENS.BIG_WHITE_SPACING,
          ),
          InkWell(
            onTap: () {
              _pickImage();
            },
            child: ClipOval(
              child: Container(
                  height: _DIMENS.PROFILE_IMAGE_HEIGHT,
                  width: _DIMENS.PROFILE_IMAGE_WIDTH,
                  decoration: BoxDecoration(
                      border: Border.all(width: 5.0),
                      // border color
                      borderRadius: const BorderRadius.all(Radius.circular(100.0),),),
                  child: _imageFile != null
                      ? Image.memory(
                          Uint8List.fromList(_imageFile!.bytes!),
                    height: _DIMENS.PROFILE_IMAGE_HEIGHT,
                    width: _DIMENS.PROFILE_IMAGE_WIDTH,
                    fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.add_photo_alternate,
                          size: MediaQuery.of(context).size.width * 0.1,
                          color: Colors.grey,
                        )),
            ),
          ),
          SizedBox(
            height: _DIMENS.BIG_WHITE_SPACING,
          ),
          Form(
            key: _registerFormKey,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: DeviceUtils.fractionWidth(context, fraction: 3)),
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: 'Name',
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: 'Email',
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: 'Password',
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    isObsecre: true,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: _DIMENS.BIG_WHITE_SPACING,
          ),
          ElevatedButton(
            onPressed: () => {
              formValidation(),
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            ),
            child: const Text(
              "Sign Up",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: _DIMENS.BIG_WHITE_SPACING,
          )
        ],
      ),
    );
  }

  // Method to pick and display an image file
  Future<void> _pickImage() async {
    try {
      // Pick an image file using file_picker package
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      // If user cancels the picker, do nothing
      if (result == null) return;

      // If user picks an image, update the state with the new image file
      setState(() {
        _imageFile = result.files.first;
      });
    } catch (e) {
       ErrorDialog(message: "$e");
      if (kDebugMode) {
        print("Pick Image Exception ======== $e");
      }
    }
  }

  Future<void> formValidation() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(message: "Please select an image");
          });
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            emailController.text.isNotEmpty) {
             // start uploading the data
          showDialog(
              context: context,
              builder: (context) {
                return const LoadingDialog(
                  message: "Registering Account...",
                );
              });
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance
              .ref()
              .child('users')
              .child(fileName);
          fStorage.UploadTask uploadTask =
              reference.putFile(File(_imageFile!.path!));

          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;
            authenticateSellerAndSignUp();
          });
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return const ErrorDialog(
                    message: "Please Enter Required info for registration");
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(message: "Password don't match");
            });
      }
    }
  }

  void authenticateSellerAndSignUp() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      saveDataToFireStore(currentUser!).then((value) {
        Navigator.pop(context);
        Route newRoute =
            MaterialPageRoute(builder: (context) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFireStore(User currentUser) async {
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameController.text.trim(),
      "photo": sellerImageUrl,
      "status": "Approved",
      "userCart": ['garbageValue'],
    });

    // save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photo", sellerImageUrl);

    await sharedPreferences!.setStringList("userCart", ['garbageValue']);
  }
}

abstract class _DIMENS {
  static double BIG_WHITE_SPACING = 30.0;
  static double PROFILE_IMAGE_WIDTH = 200.0;
  static double PROFILE_IMAGE_HEIGHT = 200.0;
}
