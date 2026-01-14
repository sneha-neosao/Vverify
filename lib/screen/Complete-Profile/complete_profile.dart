import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_verify/commonComponent/customTextFiled.dart';
import 'package:v_verify/screen/Complete-Profile/Bloc/register_cubit.dart';
import 'package:v_verify/screen/Complete-Profile/Bloc/register_state.dart';
import 'package:v_verify/screen/Complete-Profile/model/register_model.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../commonComponent/custom_button.dart';
import '../../widgets/custom_not_required_text_field.dart';
import '../../widgets/custom_required_text_field.dart';
import '../PushNotification/Bloc/push_notification_cubit.dart';
import '../PushNotification/firebase_token.dart';

class CompleteProfile extends StatefulWidget {
  String mobileNum;

  CompleteProfile({super.key, required this.mobileNum});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  bool individual = true;
  bool broker = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyHrController = TextEditingController();
  final TextEditingController companyHrNumberController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyAddressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? _image;

  void CompleteProfile(
      {required String firstName,
      required String lastName,
      required String email,
      required String userType,
      required String companyName,
      required String companyHr,
      required String companyHrNumber,
      required String companyEmail,
      required String companyAddress,
      File? profilePhoto}) async {
    context
        .read<RegisterCubit>()
        .userRegister(
            firstName: firstName,
            lastName: lastName,
            mobileNumber: widget.mobileNum,
            email: email,
            userType: userType,
            companyName: companyName,
            companyHr: companyHr,
            companyHrNumber: companyHrNumber,
            companyEmail: companyEmail,
            companyAddress: companyAddress,
            profilePhoto: profilePhoto
    )
        .then((_) {});
  }

  void saveUserData({required String id, required String token}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('token', token).then((value) {
      pushNotification();
      context.go("/bottomNav");
    });
  }

  // Pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      print("image path ${_image!.uri}");
    }
  }

  // Pick an image using the camera
  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      print("image path ${_image!.parent}");
    }
  }

  void pushNotification() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    final String token = context.read<TokenCubit>().state;
    final String id = context.read<IdCubit>().state;
    context.read<PushNotificationCubit>().pushNotification(
        token: token,
        customerId: id,
        firebaseId: firebaseToken!,
        os_version: androidInfo.version.release,
        app_version: "1.0",
        mobile_model: androidInfo.model,
        device_type: "mobile");
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController mobileController =
        TextEditingController(text: widget.mobileNum);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text("Complete Profile",
                          style: Theme.of(context).textTheme.titleMedium)),
                  const SizedBox(height: 16),
                  Text(
                    textAlign: TextAlign.center,
                    "Please complete your profile so we can learn more about you.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Center(
                    child: Text(
                      "Add Profile Image",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      radius: 50,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: Theme.of(context).primaryColorLight,
                            title: Text(
                              'Select Profile Image',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _pickImageFromGallery().then((_) {
                                              context.pop();
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.photo,
                                            size: 40,
                                            color: Colors.white,
                                          )),
                                      Text("Pick image",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _pickImageFromCamera().then((_) {
                                              context.pop();
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                            color: Colors.white,
                                          )),
                                      Text("Take Photo",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Center(
                                child: Icon(
                                Icons.add,
                                size: 35,
                              ))
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Select your user type",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                        children: [
                          TextSpan(
                            text: " * ",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.w700, color: Colors.red),
                          ),
                        ]
                      )
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          Icons.person,
                          color: individual
                              ? Theme.of(context).primaryColorDark
                              : Colors.grey,
                        ),
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8)),
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.grey),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color: individual
                                                ? Theme.of(context)
                                                    .primaryColorDark
                                                : Colors.grey)))),
                        onPressed: () {
                          setState(() {
                            broker = false;
                            individual = true;
                          });
                        },
                        label: Text(
                          "Individual",
                          style: TextStyle(
                              color: individual
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.person,
                          color: broker
                              ? Theme.of(context).primaryColorDark
                              : Colors.grey,
                        ),
                        style: ButtonStyle(
                            padding: WidgetStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8)),
                            //backgroundColor:WidgetStateProperty.all<Color>(Colors.grey) ,
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.grey),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color: broker
                                                ? Theme.of(context)
                                                    .primaryColorDark
                                                : Colors.grey)))),
                        onPressed: () {
                          setState(() {
                            individual = false;
                            broker = true;
                          });
                        },
                        label: Text(
                          "Company",
                          style: TextStyle(
                              color: broker
                                  ? Theme.of(context).primaryColorDark
                                  : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  CustomRequiredTextField(
                      controller: firstNameController,
                      titleText: "First Name",
                      hintText: "Enter First Name",
                      textInputType: TextInputType.text
                  ),
                  CustomRequiredTextField(
                      controller: lastNameController,
                      titleText: "Last Name",
                      hintText: "Enter Last Name",
                      textInputType: TextInputType.text
                  ),
                  CustomRequiredTextField(
                      validator: validateMobile,
                      readOnly: true,
                      controller: mobileController,
                      titleText: "Mobile Number",
                      hintText: "Enter Last Name",
                      textInputType: TextInputType.text
                  ),
                  CustomRequiredTextField(
                      validator: validateEmail,
                      controller: emailController,
                      titleText: "Email Address",
                      hintText: "Enter Email Address",
                      textInputType: TextInputType.text
                  ),
                  if( broker == true && individual == false)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomRequiredTextField(
                          controller: companyNameController,
                          titleText: "Company Name",
                          hintText: "Enter Company Name",
                          textInputType: TextInputType.text
                      ),
                      CustomRequiredTextField(
                          controller: companyHrController,
                          titleText: "Company Person / HR Name",
                          hintText: "Enter Person / HR Name",
                          textInputType: TextInputType.text
                      ),
                      CustomRequiredTextField(
                          validator: validateMobile,
                          controller: companyHrNumberController,
                          titleText: "Contact Person / HR Phone",
                          hintText: "Enter Contact Person / HR Phone",
                          textInputType: TextInputType.text
                      ),
                      CustomRequiredTextField(
                          validator: validateEmail,
                          controller: companyEmailController,
                          titleText: "Company Email",
                          hintText: "Enter Company Email",
                          textInputType: TextInputType.text
                      ),
                      CustomNotRequiredTextField(
                          controller: companyAddressController,
                          titleText: "Company Address",
                          hintText: "Enter Company Address",
                          textInputType: TextInputType.text
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  BlocConsumer<RegisterCubit, RegisterState>(
                      listener: (context, register) {
                    if (register is RegisterSuccess) {
                      RegisterModel data = register.registerModel;
                      saveUserData(
                          id: data.result!.id.toString(),
                          token: data.token.toString());
        
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(data.message.toString())));
                    } else if (register is RegisterError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(register.errorMessage)));
                    }
                  }, builder: (context, register) {
                    return CustomButton(
                      isLoading: register is RegisterLoading,
                      onTap: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          CompleteProfile(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              userType: individual == true ? "1" : "2",
                              companyName: companyNameController.text,
                              companyHr: companyHrController.text,
                              companyHrNumber: companyHrNumberController.text,
                              companyEmail: companyEmailController.text,
                              companyAddress: companyAddressController.text,
                              profilePhoto: _image);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill all fields')));
                        }
                      },
                      text: "SAVE",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorLight
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
