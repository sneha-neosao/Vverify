import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_verify/screen/Complete-Profile/Bloc/register_cubit.dart';
import 'package:v_verify/screen/Complete-Profile/Bloc/register_state.dart';
import 'package:v_verify/screen/Complete-Profile/model/register_model.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_salutation_textfield.dart';
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

  String? selectedPrefix = 'Mr.';
  List<String> prefixValues = <String>[ 'Mr.','Mrs.','Ms.'];

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
      required String salutation
      // File? profilePhoto
      }) async {

    final String mobileNumberToSend = userType == "1" ? widget.mobileNum : "";
    final String hrNumberToSend = userType == "2" ? widget.mobileNum : companyHrNumber;

    // ✅ Print all values before sending to API print("Sending to API:");
    print("First Name: $firstName");
    print("Last Name: $lastName");
    print("Mobile Number: $mobileNumberToSend");
    print("Email: $email");
    print("User Type: $userType");
    print("Company Name: $companyName");
    print("Company HR: $companyHr");
    print("Company HR Number: $hrNumberToSend");
    print("Company Email: $companyEmail");
    print("Company Address: $companyAddress");
    print("Salutation: $salutation");

    context
        .read<RegisterCubit>()
        .userRegister(
            firstName: firstName,
            lastName: lastName,
            mobileNumber: mobileNumberToSend,
            email: email,
            userType: userType,
            companyName: companyName,
            companyHr: companyHr,
            companyHrNumber: hrNumberToSend,
            companyEmail: companyEmail,
            companyAddress: companyAddress,
            salutation: selectedPrefix ?? ""
            // profilePhoto: profilePhoto
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
                  Text("Complete Profile",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  Text(
                    "Please complete your profile so we can learn more about you.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  // Center(
                  //   child: Text(
                  //     "Add Profile Image",
                  //     style: Theme.of(context).textTheme.bodyLarge,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // Center(
                  //   child: InkWell(
                  //     borderRadius: BorderRadius.circular(50),
                  //     radius: 50,
                  //     onTap: () {
                  //       FocusManager.instance.primaryFocus?.unfocus();
                  //       showDialog<String>(
                  //         context: context,
                  //         builder: (BuildContext context) => AlertDialog(
                  //           backgroundColor: Theme.of(context).primaryColorLight,
                  //           title: Text(
                  //             'Select Profile Image',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .bodyLarge!
                  //                 .copyWith(color: Colors.white),
                  //           ),
                  //           content: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //             children: [
                  //               SizedBox(
                  //                 height: 100,
                  //                 child: Column(
                  //                   children: [
                  //                     IconButton(
                  //                         onPressed: () {
                  //                           _pickImageFromGallery().then((_) {
                  //                             context.pop();
                  //                           });
                  //                         },
                  //                         icon: const Icon(
                  //                           Icons.photo,
                  //                           size: 40,
                  //                           color: Colors.white,
                  //                         )),
                  //                     Text("Pick image",
                  //                         style: Theme.of(context)
                  //                             .textTheme
                  //                             .bodySmall!
                  //                             .copyWith(color: Colors.white))
                  //                   ],
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 height: 100,
                  //                 child: Column(
                  //                   children: [
                  //                     IconButton(
                  //                         onPressed: () {
                  //                           _pickImageFromCamera().then((_) {
                  //                             context.pop();
                  //                           });
                  //                         },
                  //                         icon: const Icon(
                  //                           Icons.camera_alt_outlined,
                  //                           size: 40,
                  //                           color: Colors.white,
                  //                         )),
                  //                     Text("Take Photo",
                  //                         style: Theme.of(context)
                  //                             .textTheme
                  //                             .bodySmall!
                  //                             .copyWith(color: Colors.white))
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     child: CircleAvatar(
                  //       radius: 60,
                  //       backgroundColor: Theme.of(context).primaryColorLight,
                  //       backgroundImage:
                  //           _image != null ? FileImage(_image!) : null,
                  //       child: _image == null
                  //           ? const Center(
                  //               child: Icon(
                  //               Icons.add,
                  //               size: 35,
                  //             ))
                  //           : null,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
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
                  if( broker == false && individual == true)
                  Column(
                    children: [
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
                          controller: TextEditingController(text: widget.mobileNum), // bind here
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
                    ],
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
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      // RichText(
                      //     text: TextSpan(
                      //       text: "Salutation",
                      //       style: Theme.of(context)
                      //           .textTheme
                      //           .bodySmall!
                      //           .copyWith(fontWeight: FontWeight.w700),
                      //     )),
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      // SizedBox(
                      //   height: 54,
                      //   child: Theme(
                      //     data: Theme.of(context).copyWith( highlightColor: Colors.black, ),
                      //     child: DropdownButtonFormField<String>(
                      //       value: prefixValues.contains(selectedPrefix) ? selectedPrefix : null,
                      //       hint: Text(
                      //         "Select Salutation",
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .bodySmall!
                      //             .copyWith(color: Colors.grey),
                      //       ),
                      //       onChanged: (String? value) {
                      //         setState(() {
                      //           selectedPrefix = value!.toLowerCase();
                      //         });
                      //       },
                      //       items: prefixValues.map((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
                      //         );
                      //       }).toList(),
                      //       dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                      //       decoration: InputDecoration(
                      //         contentPadding:
                      //         const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
                      //         enabledBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8),
                      //           borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8),
                      //           borderSide:
                      //           BorderSide(color: Theme.of(context).canvasColor, width: 1.0),
                      //         ),
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(8),
                      //           borderSide: BorderSide(color: Theme.of(context).canvasColor, width: 1.0),
                      //         ),
                      //         filled: true,
                      //         fillColor: Theme.of(context).scaffoldBackgroundColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // CustomRequiredTextField(
                      //     controller: companyHrController,
                      //     titleText: "Company Person / HR Name",
                      //     hintText: "Enter Person / HR Name",
                      //     textInputType: TextInputType.text
                      // ),
                      CustomSalutationTextField(
                          controller: companyHrController,
                          titleText: "Company Person / HR Name",
                          hintText: "Enter Person / HR Name",
                          textInputType: TextInputType.text,
                          salutations: prefixValues,
                          selectedSalutation: selectedPrefix,
                          onSalutationChanged: (value) {
                            setState(() {
                              selectedPrefix = value; // keep original casing and dot
                            });
                          }
                      ),
                      CustomRequiredTextField(
                          validator: validateMobile,
                          readOnly: true,
                          controller: TextEditingController(text: widget.mobileNum), // bind here
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
                              salutation: selectedPrefix!
                              // profilePhoto: _image
                          );
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
