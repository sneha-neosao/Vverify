import 'dart:io';
import 'package:flutter/material.dart';

import '../../../commonComponent/dottedBorder.dart';

class PickMultiplePhoto extends StatelessWidget {
  final void Function()? onPressedPickImage;
  final void Function()? onPressedTakePhoto;
  final void Function()? addSign;
  final bool? isSign;
  final String title;
  final double? widthSize;
  final List<File> files;
  final String mainTitle;
  final String? starRemove;

  /// NEW: callback for removing a file
  final void Function(int index)? onRemoveFile;

  const PickMultiplePhoto({
    super.key,
    required this.onPressedPickImage,
    required this.onPressedTakePhoto,
    this.addSign,
    this.isSign,
    required this.title,
    this.widthSize,
    required this.files,
    required this.mainTitle,
    this.starRemove,
    this.onRemoveFile, // ✅ added
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
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
                              icon: const Icon(Icons.photo,
                                  size: 40, color: Colors.white),
                            ),
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
                              icon: const Icon(Icons.camera_alt_outlined,
                                  size: 40, color: Colors.white),
                            ),
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
                              icon: const Icon(Icons.draw,
                                  size: 40, color: Colors.white),
                            ),
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
              ),
              width: widthSize,
              height: 150,
              child: files.isEmpty
                  ? Center(
                child: Icon(Icons.add,
                    size: 36,
                    color: Theme.of(context).primaryColorDark),
              )
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                itemCount: files.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final file = files[index];
                  return Stack(
                    children: [
                      file.path.toLowerCase().endsWith(".pdf")
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/pdf_logo.png",
                              width: 60, height: 60),
                          Text(
                            file.path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            if (onRemoveFile != null) {
                              onRemoveFile!(index);
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            child: const Icon(Icons.close,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
