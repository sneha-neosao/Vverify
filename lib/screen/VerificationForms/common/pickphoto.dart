import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:v_verify/screen/VerificationForms/common/Preview/preview.dart';

import '../../../commonComponent/dottedBorder.dart';

class PickPhoto extends StatelessWidget {
  void Function()? onPressedPickImage;
  void Function()? onPressedTakePhoto;
  void Function()? addSign;
  bool? isSign = false;
  String title;
  double? widthSize;
  File image;
  String mainTitle;
  String? starRemove;

  PickPhoto({
    super.key,
    required this.onPressedPickImage,
    required this.onPressedTakePhoto,
    this.addSign,
    this.isSign,
    required this.title,
    this.widthSize,
    required this.image,
    required this.mainTitle,
    this.starRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
                text: mainTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w700),
                children: [
              TextSpan(
                text: starRemove == null ? " * " : "",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w700, color: Colors.red),
              ),
            ])),
        const SizedBox(
          height: 8,
        ),
        CustomPaint(
          painter: DottedBorderPainter(context: context),
          child: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  title: Text(
                    title,
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
                                onPressed: onPressedPickImage,
                                icon: const Icon(
                                  Icons.photo,
                                  size: 40,
                                  color: Colors.white,
                                )),
                            Text("Pick image/File",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white))
                          ],
                        ),
                      ),
                      isSign != null
                          ? const SizedBox()
                          : SizedBox(
                              height: 100,
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: onPressedTakePhoto,
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
                      isSign == null
                          ? const SizedBox()
                          : SizedBox(
                              height: 100,
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: addSign,
                                      icon: const Icon(
                                        Icons.draw,
                                        size: 40,
                                        color: Colors.white,
                                      )),
                                  Text("Signature",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.white))
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.black)
              ),
              width: widthSize,
              height: 150,
              child: image.path.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.add,
                        size: 36,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    )
                  : image.path.contains("pdf")
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/pdf_logo.png",
                                width: 80,
                                height: 80,
                              ),
                              Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                image.path,
                              ),
                            ],
                          ),
                        )
                      : Image.file(
                          image,
                          fit: BoxFit.cover,
                        ),
            ),
          ),
        ),
      ],
    );
  }
}

class PickPhotoUpdate extends StatelessWidget {
  void Function()? onPressedPickImage;
  void Function()? onPressedTakePhoto;
  String title;
  double? widthSize;
  void Function()? addSign;
  bool? isSign = false;
  File image;
  String uploadImage;
  String mainTitle;
  String? starRemove;

  PickPhotoUpdate(
      {super.key,
      required this.onPressedPickImage,
      required this.onPressedTakePhoto,
      required this.title,
      this.addSign,
      this.isSign,
      this.widthSize,
      required this.image,
      required this.uploadImage,
      required this.mainTitle,
      this.starRemove});

  @override
  Widget build(BuildContext context) {
    print("imagepath ${image.path.isEmpty}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
                text: mainTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w700),
                children: [
              TextSpan(
                text: starRemove == null ? " * " : "",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w700, color: Colors.red),
              ),
            ])),
        const SizedBox(
          height: 8,
        ),
        CustomPaint(
          painter: DottedBorderPainter(context: context),
          child: InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  title: Text(
                    title,
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
                                onPressed: onPressedPickImage,
                                icon: const Icon(
                                  Icons.photo,
                                  size: 40,
                                  color: Colors.white,
                                )),
                            Text("Pick image/File",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white))
                          ],
                        ),
                      ),
                      isSign != null
                          ? const SizedBox()
                          : SizedBox(
                              height: 100,
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: onPressedTakePhoto,
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
                      isSign == null
                          ? const SizedBox()
                          : SizedBox(
                              height: 100,
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: addSign,
                                      icon: const Icon(
                                        Icons.draw,
                                        size: 40,
                                        color: Colors.white,
                                      )),
                                  Text("Signature",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.white))
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.black)
              ),
              width: widthSize,
              height: 150,
              child: image.path.isEmpty
                  ? uploadImage.contains("pdf")
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/pdf_logo.png",
                                width: 80,
                                height: 80,
                              ),
                              Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                uploadImage,
                              ),
                            ],
                          ),
                        )
                      : CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: uploadImage,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                  : image.path.contains("pdf")
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/pdf_logo.png",
                                width: 80,
                                height: 80,
                              ),
                              Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                image.path,
                              ),
                            ],
                          ),
                        )
                      : Image.file(
                          image,
                          fit: BoxFit.cover,
                        ),
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Preview(url: uploadImage)));
            },
            child: Text(
              "Preview",
              style: Theme.of(context).textTheme.bodyMedium,
            ))
      ],
    );
  }
}
