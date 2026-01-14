import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_verify/commonComponent/screen_size.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_not_required_text_field.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../commonComponent/customTextFiled.dart';
import '../../../commonComponent/custom_button.dart';
import '../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../ProfileScreen/bloc/profile_cubit.dart';
import '../ProfileScreen/bloc/profile_state.dart';
import '../ProfileScreen/model/profile_model.dart';
import '../VerificationForms/common/form_widget.dart';
import 'bloc/editProfile_cubit.dart';
import 'bloc/editProfile_sate.dart';

class EditProfile extends StatefulWidget {
  final String user_type;

  EditProfile({super.key, required this.user_type});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    //context.read<PickImageCubit>().clear();
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyHrController = TextEditingController();
  final TextEditingController companyHrNumberController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyAddressController = TextEditingController();

  int? user_type;
  final _formKey = GlobalKey<FormState>();

  void _updateProfile(
      {required String firstname,
      required String lastName,
      required String email,
      required String customer,
      File? profilePhoto}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? id = prefs.getString('id');
    if (token!.isNotEmpty) {
      context.read<EditProfileCubit>().editProfile(
        token: token,
        email: email,
        customerId: id!,
        profilePhoto: profilePhoto,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        companyName: companyNameController.text,
        contactPersonName: companyHrController.text,
        contactPersonPhone: companyHrNumberController.text,
        companyEmail: companyEmailController.text,
        companyAddress: companyAddressController.text,
        userType: user_type.toString(),
      );
    }
  }

  void getProfile() {
    final String token = context.read<TokenCubit>().state;
    final String id = context.read<IdCubit>().state;

    context.read<ProfileCubit>().getProfile(token: token, id: id);
  }

  final ImagePicker _picker = ImagePicker();
  File? _image;

  // Pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  // Pick an image using the camera
  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailAddressController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ScreenSize.screenHeight / 16),
          child: AppBar(
            title: const Text("Edit Profile"),
          ),
          //child: CustomAppbar(title: "Edit Profile")
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<PickImageCubit, File>(
                builder: (context, profilePath) {
              return BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profile) {
                  if (profile is ProfileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (profile is ProfileError) {
                    return Center(
                      child: Text(profile.errorMessage),
                    );
                  } else if (profile is ProfileSuccess) {
                    ProfileResult? data = profile.profileModel.profileResult;
                      user_type = data!.userTypeId!;
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              width: 130.58,
                              height: 130.58,
                              child: CircleAvatar(
                                  radius: 100.0,
                                  backgroundColor: Colors.white,
                                  backgroundImage: _image == null
                                      ? NetworkImage(data!.profilePhoto!)
                                      : FileImage(_image!)),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).primaryColorLight,
                                      title: Text(
                                        'Select Profile Image',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.white),
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      _pickImageFromGallery()
                                                          .then((_) {
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
                                                        .copyWith(
                                                            color: Colors.white))
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      _pickImageFromCamera()
                                                          .then((_) {
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
                                                        .copyWith(
                                                            color: Colors.white))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                //onTap: context.read<PickImageCubit>().pickImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      color: Colors.white,
                                      Icons.edit,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomRequiredTextField(
                                      validator: validateEmail,
                                      controller: emailAddressController..text = data.email!,
                                      titleText: "Email",
                                      hintText: "Enter Email",
                                      textInputType: TextInputType.text
                                  ),
                                  CustomRequiredTextField(
                                      controller: firstNameController..text = data.firstName!,
                                      titleText: "First Name",
                                      hintText: "Enter First Name",
                                      textInputType: TextInputType.text
                                  ),
                                  CustomRequiredTextField(
                                      controller: lastNameController..text = data.lastName!,
                                      titleText: "Last Name",
                                      hintText: "Enter Last Name",
                                      textInputType: TextInputType.text
                                  ),
                                  if(widget.user_type.toLowerCase() == "company")
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomRequiredTextField(
                                            controller: companyNameController..text = data.companyName!,
                                            titleText: "Company Name",
                                            hintText: "Enter Company Name",
                                            textInputType: TextInputType.text
                                        ),
                                        CustomRequiredTextField(
                                            controller: companyHrController..text = data.companyHr!,
                                            titleText: "Company Person / HR Name",
                                            hintText: "Enter Person / HR Name",
                                            textInputType: TextInputType.text
                                        ),
                                        CustomRequiredTextField(
                                            validator: validateMobile,
                                            controller: companyHrNumberController..text = data.companyHrNumber!,
                                            titleText: "Contact Person / HR Phone",
                                            hintText: "Enter Contact Person / HR Phone",
                                            textInputType: TextInputType.text
                                        ),
                                        CustomRequiredTextField(
                                            validator: validateEmail,
                                            controller: companyEmailController..text = data.companyEmail!,
                                            titleText: "Company Email",
                                            hintText: "Enter Company Email",
                                            textInputType: TextInputType.text
                                        ),
                                        CustomNotRequiredTextField(
                                            controller: companyAddressController..text = data.companyAddress!,
                                            titleText: "Company Address",
                                            hintText: "Enter Company Address",
                                            textInputType: TextInputType.text
                                        ),
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  BlocConsumer<EditProfileCubit,
                                          EditProfileState>(
                                      listener: (context, state) {
                                    if (state is EditProfileSuccess) {
                                      getProfile();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Profile update successfully")));
                                      Navigator.pop(context, false);
                                    } else if (state is EditProfileFailure) {}
                                  }, builder: (context, state) {
                                    return CustomButton(
                                        isLoading: state is EditProfileLoading,
                                        text: "Update Profile",
                                        gradientColors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorLight
                                        ],
                                        onTap: () {
                                          if (_formKey.currentState?.validate() ??
                                              false) {
                                            _updateProfile(
                                                firstname:
                                                    firstNameController.text,
                                                lastName: lastNameController.text,
                                                email:
                                                    emailAddressController.text,
                                                customer: data.id!.toString(),
                                                profilePhoto: _image);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Please fill all fields')));
                                          }
                                        });
                                  })
                                ],
                              ),
                            ),
                          ),
                        ), // BlocBuilder<EditProfileCubit, EditProfileState>(
                      ],
                    );
                  }
                  return const Center(
                    child: Text("Error..."),
                  );
                },
              );
            }),
          ),
        ));
  }
}
