import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/commonComponent/screen_size.dart';

 File? signImage;

class SignatureScreen extends StatefulWidget {
  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  // List to hold points of the signature
  List<Offset?> points = [];
  bool addSign = false;

  GlobalKey repaintKey = GlobalKey();

  Future<void> _captureAndSaveImage() async {
    try {
      RenderRepaintBoundary boundary = repaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var buffer = byteData!.buffer.asUint8List();

      // Save the image to a file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/drawing.png');
      await file.writeAsBytes(buffer);

      setState(() {
        signImage = file;
      });

    } catch (e) {
      print("Error saving image: $e");
    }
  }

  //Function to delete the image
  Future<void> _deleteImage(BuildContext context) async {
    try {
      // Deleting the image file from local storage
      if (signImage !=null) {
        File(signImage!.path).delete().then((_) {
          setState(() {
            signImage = null;
          });
        });
        // Show confirmation message
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Image deleted!')));
        // Pop the screen after deletion
      }
    } catch (e) {
      print("Error deleting image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Signature pad (CustomPainter and GestureDetector)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Signature",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 24),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        points.clear(); // Reset the list of points
                      });
                    },
                    child: const Text("Clear"))
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onPanStart: (value) {
                setState(() {
                  addSign = true;
                });
              },
              child: Container(
                height: ScreenSize.screenHeight / 1.53,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black)),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      points.add(details
                          .localPosition); // Capture the position where the user touches
                    });
                  },
                  onPanEnd: (details) {
                    points.add(null); // End of a stroke
                  },
                  child: RepaintBoundary(
                    key: repaintKey,
                    child: Container(
                      height: ScreenSize.screenHeight / 1.53,
                      color: Theme.of(context).cardColor,
                      child: CustomPaint(
                        size: const Size(double.infinity, 300),
                        painter: SignaturePainter(points, context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

        CustomButton(
          onTap: () {

            _captureAndSaveImage().then((_){
              //_deleteImage(context);
             context.pop();
            });



          },
          text: "SUBMIT",
          gradientColors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorLight
          ],
        )

            // BlocBuilder<UploadDocumentMumbaiTenantSignature, File>(
            //     builder: (context, sign) {
            //   return CustomButton(
            //     onTap: () {
            //       if (sign.path.isNotEmpty) {
            //         context
            //             .read<UploadDocumentMumbaiTenantSignature>()
            //             .clearImage();
            //         context
            //             .read<UploadDocumentMumbaiTenantSignature>()
            //             .captureAndSaveImage(repaintKey: repaintKey)
            //             .then((_) {
            //           try {
            //             // Deleting the image file from local storage
            //             if (sign.path.isNotEmpty) {
            //               File(sign.path).delete();
            //               // Show confirmation message
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                   const SnackBar(content: Text('Image deleted!')));
            //               // Pop the screen after deletion
            //             }
            //           } catch (e) {
            //             print("Error deleting image: $e");
            //             ScaffoldMessenger.of(context).showSnackBar(
            //                 const SnackBar(
            //                     content: Text('Failed to delete image')));
            //           }
            //            context.pop();
            //         });
            //       } else {
            //         context
            //             .read<UploadDocumentMumbaiTenantSignature>()
            //             .captureAndSaveImage(repaintKey: repaintKey)
            //             .then((_) {
            //           try {
            //             // Deleting the image file from local storage
            //             if (sign.path.isNotEmpty) {
            //               File(sign.path).delete();
            //               // Show confirmation message
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                   const SnackBar(content: Text('Image deleted!')));
            //               // Pop the screen after deletion
            //             }
            //           } catch (e) {
            //             print("Error deleting image: $e");
            //             ScaffoldMessenger.of(context).showSnackBar(
            //                 const SnackBar(
            //                     content: Text('Failed to delete image')));
            //           }
            //           context.pop();
            //         });
            //       }
            //     },
            //     text: "SUBMIT",
            //     gradientColors: [
            //       Theme.of(context).primaryColor,
            //       Theme.of(context).primaryColorLight
            //     ],
            //   );
            // })
          ],
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  BuildContext context;

  SignaturePainter(this.points, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).textTheme.bodyLarge!.color!
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i]!, points[i + 1]!, paint); // Draw line between points
      } else if (points[i] != null && points[i + 1] == null) {
        // Draw a small dot for single touch point
        canvas.drawCircle(points[i]!, 3.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Always repaint the signature as the user adds new points
  }
}
